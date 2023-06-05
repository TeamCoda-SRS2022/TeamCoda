import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "YLib/RhythmInput/MeasureTracker"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BattleInput').extends(Object)



function BattleInput:userPassed()
    local passed = true
    for _, validNote in ipairs(self.notePressed) do
        if not validNote then
            passed = false
        end
    end
    return passed and self.isValid
end

function BattleInput:handleCrankMove(change, acceleratedChange)
  local newY = self.cursor.y - change * (0.2)
  if newY >= self.cursorMax or newY <= self.cursorMin then
    newY = math.max(math.min(newY, self.cursorMax), self.cursorMin)
  end
  self.cursor:moveTo(self.cursor.x, newY)
end

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: BPM
function BattleInput:init(soundFilePath, notes, tempo)
    BattleInput.super.init(self)

    self.active = false

    self.notes = {}
    self.nextNote = 1
    self.notesOnScreen = {}

    --self.offset = 0.2 -- offset of mp3
    --self.startTime = -1.0 -- start time of song 
    --self.songPosition = 0.0 -- current position of song 
    self.tempo = tempo
    self.secPerBeat = 60.0 / tempo
    self.beatsInAdvance = 5  -- number of beats in advance to spawn notes (time signature + 1)

    self.cursorMin = 50.0  -- cursor y positions
    self.cursorMax = 150.0
    self.xThreshold = 200.0  -- cursor x position
    self.xSpawn = 350.0
    self.decisionX = ((self.xSpawn - self.xThreshold)/self.beatsInAdvance) + self.xThreshold 

    local cursorSprite = gfx.image.new( "Scenes/HouseTwo/connector.png" )
    self.cursor = gfx.sprite.new(cursorSprite)
    self.cursor:moveTo(self.decisionX, self.cursorMax)

    self.noteSprite = gfx.image.new( "Assets/BattleNote.png" )
    self.bar = gfx.sprite.new(gfx.image.new( "Assets/BattleInputBar.png" ))
    self.bar:moveTo(self.decisionX, (self.cursorMax+self.cursorMin)/2)

    -- Callbacks
    --[[
    self.complete = {}
    function self.complete:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.complete:pop()
        table.remove(self)
    end
    self.noteEnd = {}  -- calls these after each note window
    function self.noteEnd.push(callbackF)
      table.insert(self, callbackF)
    end]]

    -- Parse Notes
    for k, v in string.gmatch(notes, "(%w+)=(%w+)") do
        self.notes[#self.notes+1] = {
            BeatNum = (tonumber(k)),
            BeatLoc = (tonumber(v))  -- [0, 4], representing y loc
        }
    end


    local function songDone()
      self:stop()

    end

    --self.audio = pd.sound.fileplayer.new(soundFilePath)
    --self.audio:setFinishCallback(songDone)
    self.timer = pd.timer.new(1000000)
    self.timer:pause()

    self.noteSounds = {pd.sound.sampleplayer.new("Assets/SFX/note1"),pd.sound.sampleplayer.new("Assets/SFX/note2"),
    pd.sound.sampleplayer.new("Assets/SFX/note3"),pd.sound.sampleplayer.new("Assets/SFX/note4")}

    self.myInputHandlers = {
      BButtonDown = function()
        for i=#self.notesOnScreen,1,-1 do
          if math.abs(self.cursor.y - self.notesOnScreen[i]["sprite"].y) < 10 and math.abs(self.cursor.x - self.notesOnScreen[i]["sprite"].x) < 10 then
            print("hit")
            self.notesOnScreen[i]["sprite"]:remove()
            table.remove(self.notesOnScreen, i)
          end
        end
        
      end,
      cranked = function(change, acceleratedChange)
        self:handleCrankMove(change, acceleratedChange)
      end,
    
    }


  end


function BattleInput:update()
  if not self.active then
    return
  end
  if self.nextNote >= #self.notes and #self.notesOnScreen == 0 then
    self:stop()
    return    
  end
  --print(self.audio:getOffset(), pd.sound.getCurrentTime() - self.startTime)
  local songPosInBeats = (self.timer.currentTime / 1000) / self.secPerBeat


  if math.abs(songPosInBeats - math.floor(songPosInBeats)) < 0.05 then
    print(self.nextNote - #self.notesOnScreen)
    --self.noteSounds[self.nextNote - #self.notesOnScreen]:play()
  end

  -- move notes (interpolate!!)
  for i=#self.notesOnScreen,1,-1 do


    local newX = self.xSpawn - (self.xSpawn - self.xThreshold) * ((self.beatsInAdvance - (self.notesOnScreen[i]["beat"] - songPosInBeats)) / self.beatsInAdvance)
    self.notesOnScreen[i]["sprite"]:moveTo(newX, self.notesOnScreen[i]["sprite"].y)
    -- if notes pass threshold, remove (set nil)
    if self.notesOnScreen[i]["sprite"].x < self.xThreshold then
      self.notesOnScreen[i]["sprite"]:remove()
      table.remove(self.notesOnScreen, i)
      print("miss")
    end
  end
  
  -- spawn new notes

  if self.nextNote <= #self.notes and self.notes[self.nextNote]["BeatNum"] < songPosInBeats + self.beatsInAdvance then
    local newNote = {
      beat = self.notes[self.nextNote]["BeatNum"],
      sprite = gfx.sprite.new(self.noteSprite)
    }
    newNote["sprite"]:moveTo(self.xSpawn, self.notes[self.nextNote]["BeatLoc"]*24 + self.cursorMin + 12)
    newNote["sprite"]:add()
    table.insert(self.notesOnScreen, newNote)
    self.nextNote += 1
  end
  

end


function BattleInput:start()
    self.active = true
    --self.startTime = pd.sound.getCurrentTime()
    --self.audio:play()
    self.timer:start()
    pd.inputHandlers.push(self.myInputHandlers);
    self.cursor:add()
    self.bar:add()

    
end

function BattleInput:stop()
    self.active = false
    pd.inputHandlers.pop();
    self.cursor:remove()
    self.bar:remove()
    --self.audio:stop()
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "YLib/Interactable/InteractableBody"
import "Platforms/PlatformNoSprite"



local pd <const> = playdate
local gfx <const> = pd.graphics

class('FloorOne').extends(Scene)


lowerBound_y = 162
upperBound_y = 220

function FloorOne:init()
  FloorOne.super.init(self)

  local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
  local buttonSprite = gfx.image.new( "Assets/button.png" )
  local puzzleSprite = gfx.image.new( "Assets/growingRobot.png" )
  local conveyorBeltSprite = gfx.image.new( "Assets/conveyorbelt.png")

  self.offsetx = 0
  self.bg = gfx.sprite.new(gfx.image.new("Scenes/Backgrounds/factoryRoom1.PNG"))

  self.conveyorBelt = gfx.sprite.new(conveyorBeltSprite)
  self.conveyorBelt:moveTo(320, 133)

  self.player = Player(100, 160)

  self.crank1 = InteractableBody(225, 220, puzzleSprite, self.player, 0)
  self.crank2 = InteractableBody(300, 220, puzzleSprite, self.player, 0)
  self.crank3 = InteractableBody(375, 220, puzzleSprite, self.player, 0)
  self.crank4 = InteractableBody(450, 220, puzzleSprite, self.player, 0)

  self.conveyorButton = InteractableBody(575, 200, buttonSprite, self.player, 50)
  
  self.crankLocations = {self.crank1, self.crank2, self.crank3, self.crank4}
  self.lowestMIDI = 71
  self.notes = {
    {["step"] = 1, ["note"] = self.lowestMIDI, ["length"] = 1, ["velocity"] = 1},
    {["step"] = 3, ["note"] = self.lowestMIDI, ["length"] = 1, ["velocity"] = 1},
    {["step"] = 5, ["note"] = self.lowestMIDI, ["length"] = 1, ["velocity"] = 1},
    {["step"] = 7, ["note"] = self.lowestMIDI, ["length"] = 1, ["velocity"] = 1},
  }
  self.scales = {0, 0, 0, 0}  -- scales between 0 and 10 for note pitches and robot heights
  
  self.synth = playdate.sound.synth.new(playdate.sound.kWaveSine)
  self.noteTrack = playdate.sound.track.new()
  self.noteTrack:setInstrument(self.synth)

  self.noteTrack:setNotes(self.notes)

  self.solutionNotes = {71, 71, 76, 72}
  self.solved = false
	
  self.sequence = playdate.sound.sequence.new()
  self.sequence:setTempo(4)  -- steps per second
  self.sequence:addTrack(self.noteTrack)
  self.sequence:setLoops(1, 8, 1)

  local doorSprite = gfx.image.new( "SceneTransition/door.png" )  
  self.door = SceneTransition(41, 200, doorSprite, self.player, 12, true, 80)

  self.ambience = pd.sound.fileplayer.new("Assets/SFX/floorOne")

  self.sceneObjects = {
      self.player,
      self.player.interactableSprite,
      self.crank1,
      self.crank2,
      self.crank3,
      self.crank4,

      PlatformNoSprite(0, 220, 640, 7),
      PlatformNoSprite(-7, 0, 7, 240),
      PlatformNoSprite(640, 0, 7, 240),
      self.conveyorButton,
      self.conveyorBelt,

      self.door,
      
      
  }
end


function FloorOne:load()
  FloorOne.super.load(self)

  self.conveyorButton.callbacks:push(
    function() 
      self.sequence:play(
        function()
          valid = true
          for i, _ in ipairs(self.notes) do
            print(self.notes[i]["note"])
            if self.notes[i]["note"] ~= self.solutionNotes[i] then
              valid = false
            end
          end
          print(valid)
          self.solved = valid or self.solved
          if self.solved then
            self.door.locked = false
            self.ambience:stop()
            self.bg:setImage(gfx.image.new("Scenes/Backgrounds/factoryRoom1Lit.PNG"))
          end
        end
      )
    end
    )

    local myInputHandlers = {
      cranked = function(change, acceleratedChange)
        for i, crank in ipairs(self.crankLocations) do
          local sprites = crank:overlappingSprites()
          if #sprites > 0 then  -- player collision
            self.scales[i] += change * (0.01)
            if self.scales[i] >= 10 or self.scales[i] <= 0 then
              self.scales[i] = math.max(math.min(self.scales[i], 10), 0)
            end
  
            self.notes[i]["note"] = self.lowestMIDI + math.floor(self.scales[i])
            self.noteTrack:setNotes(self.notes)
            crank:moveTo(crank.x, upperBound_y - (upperBound_y-lowerBound_y)*(self.scales[i])/(10))
          end
        end
      end,
    }
    playdate.inputHandlers.push(myInputHandlers)


	self.bg:setCenter(0, 0)
  self.bg:moveTo(0, 45)
  self:add(self.bg)
  self.bg:setZIndex(-1)

  gfx.setBackgroundColor(playdate.graphics.kColorBlack)

  self.ambience:play(0)
end

function FloorOne:unload()
  FloorOne.super.unload(self)
  playdate.inputHandlers.pop()
  
end

function FloorOne:update()
  FloorOne.super.update(self)
  gfx.fillRect(0, 221, 640, 20)
  gfx.fillRect(0, 0, 640, 45)
  self.offsetx = - (self.player.x - 200)
  if(self.offsetx > 0) then self.offsetx = 0 end
  if(self.offsetx < -240) then self.offsetx = -240 end
  gfx.setDrawOffset(self.offsetx, 0)

end
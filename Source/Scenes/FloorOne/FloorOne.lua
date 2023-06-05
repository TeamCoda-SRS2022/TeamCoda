import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "YLib/Interactable/InteractableBody"


local pd <const> = playdate
local gfx <const> = pd.graphics

class('FloorOne').extends(Scene)


lowerBound_y = 173
upperBound_y = 231

function FloorOne:init()
  FloorOne.super.init(self)

  local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
  local buttonSprite = gfx.image.new( "Assets/button.png" )
  local puzzleSprite = gfx.image.new( "Assets/growingRobot.png" )
  local conveyorBeltSprite = gfx.image.new( "Assets/conveyorbelt.png")
  local doorSprite = gfx.image.new( "SceneTransition/door.png" )

  self.conveyorBelt = gfx.sprite.new(conveyorBeltSprite)
  self.conveyorBelt:moveTo(320, 145)

  self.player = Player(100, 100)

  self.crank1 = InteractableBody(225, 231, puzzleSprite, self.player, 0)
  self.crank2 = InteractableBody(275, 231, puzzleSprite, self.player, 0)
  self.crank3 = InteractableBody(325, 231, puzzleSprite, self.player, 0)
  self.crank4 = InteractableBody(375, 231, puzzleSprite, self.player, 0)

  self.conveyorButton = InteractableBody(150, 200, buttonSprite, self.player, 50)
  
  self.crankLocations = {self.crank1, self.crank2, self.crank3, self.crank4}
  self.lowestMIDI = 63
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

  self.solutionNotes = {67, 67, 67, 63}
  self.solved = false
	
  self.sequence = playdate.sound.sequence.new()
  self.sequence:setTempo(4)  -- steps per second
  self.sequence:addTrack(self.noteTrack)
  self.sequence:setLoops(1, 8, 1)

  local doorSprite = gfx.image.new( "SceneTransition/door.png" )  
  self.door = SceneTransition(41, 200, doorSprite, self.player, 12, true, 80)

  self.sceneObjects = {
      self.player,
      self.player.interactableSprite,
      self.crank1,
      self.crank2,
      self.crank3,
      self.crank4,

    
      self.conveyorButton,
      self.conveyorBelt,

      self.door,
      
      Platform(32, 240, platformSprite),
      Platform(96, 240, platformSprite),
      Platform(160, 240, platformSprite),
      Platform(224, 240, platformSprite),
      Platform(288, 240, platformSprite),
      Platform(352, 240, platformSprite),
      
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
            if self.notes[i]["note"] ~= self.solutionNotes[i] then
              valid = false
            end
          end
          print(valid)
          self.solved = valid or self.solved
          if self.solved then
            self.door.locked = false
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

  local backgroundImage = gfx.image.new( "Scenes/Backgrounds/factoryTemplate2.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, -7 )
		end
	)
end

function FloorOne:unload()
  FloorOne.super.unload(self)
  playdate.inputHandlers.pop()
end
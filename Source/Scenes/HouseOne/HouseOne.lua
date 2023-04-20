import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Scenes/HouseOne/Frequency"
import "CoreLibs/Crank"
import "Player/RhythmInput"
import "YLib/Interactable/InteractableBody"
import "SceneTransition/SceneTransition"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HouseOne').extends(Scene)

function HouseOne:init()
    HouseOne.super.init(self)
  
  self.sfreq = {164.81, 196.00, 261.63, 130.81}

  self.completed = false
  
  self.player = Player(110, 200)

  self.freqs = {Frequency(255, 120, self.sfreq[1]), Frequency(275, 120, self.sfreq[2]), Frequency(295, 120, self.sfreq[3]), Frequency(315, 120, self.sfreq[4])}
  self.freqNum = 1
    
  self.recordPlayer = InteractableBody(165, 186, gfx.image.new("SceneTransition/door.png"), self.player, 0)
  self.recordPlayer:setVisible(false)
  
  local doorSprite = gfx.image.new( "SceneTransition/door.png" )
  local TownDoor = SceneTransition(110, 186, doorSprite, self.player, 1, false, 60)

  self.sceneObjects = {
    TownDoor,
    self.player.interactableSprite,
    self.freqs[1],
    self.freqs[2],
    self.freqs[3],
    self.freqs[4],
    self.player,
    Platform(200, 224, gfx.image.new("Scenes/HouseOne/background.png")),
    self.recordPlayer
  } 
end

function HouseOne:load()
  HouseOne.super.load(self)

  if not self.completed then self.freqs[self.freqNum]:start() end

  local backgroundImage = gfx.image.new("Scenes/Backgrounds/bg.png")
  assert( backgroundImage )
  gfx.sprite.setBackgroundDrawingCallback(
    function( x, y, width, height )
      backgroundImage:drawCentered( 200, 120 )
    end
	)
end 

function HouseOne:update()
    HouseOne.super.update(self)

    if self.freqNum < 5 then
            
        for _, freq in ipairs(self.freqs) do
            if not freq.completed then freq:onCrank() end
        end

        if self.freqs[self.freqNum].completed then 
            self.freqNum = self.freqNum + 1
            if(self.freqNum == 5) then
                self.completed = true
                return
            end
            self.freqs[self.freqNum]:start()
        end
    end
end
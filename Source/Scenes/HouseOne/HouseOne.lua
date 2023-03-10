import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Scenes/HouseOne/Frequency"
import "CoreLibs/Crank"
import "Player/RhythmInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HouseOne').extends(Scene)

function HouseOne:init()
    HouseOne.super.init(self)
  
  self.sfreq = {164.81, 196.00, 261.63, 130.81}
  
  self.freqs = {Frequency(255, 120, self.sfreq[1]), Frequency(275, 120, self.sfreq[2]), Frequency(295, 120, self.sfreq[3]), Frequency(315, 120, self.sfreq[4])}
  self.freqNum = 1
    
  self.player = Player(110, 200)

  self.recordPlayer = InteractableBody(225, 231, "", self.player, 0)

  self.sceneObjects = {
    self.recordPlayer,
    self.freqs[1],
    self.freqs[2],
    self.freqs[3],
    self.freqs[4],
    self.player
  } 
end

function HouseOne:load()
    HouseOne.super.load(self)

  self.freqs[self.freqNum]:start()

  local backgroundImage = gfx.image.new("Scenes/Backgrounds/bg.png")
  assert( backgroundImage )
  gfx.sprite.setBackgroundDrawingCallback(
    function( x, y, width, height )
      backgroundImage:drawCentered( 200, 125 )
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
                print("completed")
                return
            end
            self.freqs[self.freqNum]:start()
        end
    end
end
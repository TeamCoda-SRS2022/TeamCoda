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

class('MichTest').extends(Scene)

function MichTest:init()
  MichTest.super.init(self)
  
  self.valid = true
  
  self.sfreq = {164.81, 196.00, 261.63, 130.81}
  
  self.freqs = {Frequency(255, 120, self.sfreq[1]), Frequency(275, 120, self.sfreq[2]), Frequency(295, 120, self.sfreq[3]), Frequency(315, 120, self.sfreq[4])}
  self.freqNum = 1
    
  self.player = Player(110, 200)

  self.sceneObjects = {
    self.freqs[1],
    self.freqs[2],
    self.freqs[3],
    self.freqs[4],
    self.player
  } 
end

function MichTest:load()
  MichTest.super.load(self)

  self.freqs[self.freqNum]:start()

  local backgroundImage = gfx.image.new("Scenes/Backgrounds/bg.png")
  assert( backgroundImage )
  gfx.sprite.setBackgroundDrawingCallback(
    function( x, y, width, height )
      backgroundImage:drawCentered( 200, 125 )
    end
	)
end 

function MichTest:update()
  MichTest.super.update(self)

  if self.freqNum < 5 then
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

function MichTest:add(obj)
  table.insert(self.sceneObjects, obj)
  obj:add()
  self.valid = false
end

function MichTest:remove(obj)
  obj:remove()
end
import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/Crank"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Frequency").extends(gfx.sprite)

function Frequency:init(x, y, freq)
   Frequency.super.init(self)
   self:moveTo(x, y)
   self:setCollideRect(0, 0, self:getSize())
   self.freq = 0
   
end

function Frequency:update()
    Frequency.super.update(self)
    self.turnOnCrank = true
    if self.turnOnCrank == true then
      self:onCrank()
    end
    if self.freq == 60 then
      --print("hey")
    end
    

end

function Frequency:onCrank()
  local change, acceleratedChange = playdate.getCrankChange()
  local cranky = playdate.getCrankPosition()
  self.freq = cranky
  --print(change, acceleratedChange, cranky)
  if self.freq < 0 and change then 
      self.freq = 359
  end 
  if self.freq > 359 and change then 
      self.freq = 1
  end
  
  local maxWidth = 10
  local height = 90

	local bar_image = gfx.image.new(maxWidth, height, gfx.kColorWhite)
  
	gfx.pushContext(bar_image)
	gfx.fillRect(0, 0, maxWidth, 10)
	gfx.popContext()
	self:setImage(bar_image)
end

function Frequency:getFreq()
  return self.freq
end
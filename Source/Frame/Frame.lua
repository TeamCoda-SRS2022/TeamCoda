import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "Frame/Frequency"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Frame").extends(gfx.sprite)

function Frame:init(x, y, image) -- each part of the picture frame is its own object
   Frame.super.init(self)
   self:setImage(image)
   self:moveTo(x, y)
   self.moving = true
   self:setCollideRect(0, 0, self:getSize())
   self.colliding = false
   self.x = x
   self.response = gfx.sprite.kCollisionTypeOverlap
   self.freqs = Frequency(x, y - 150, 90)
   
end
  
  
-- somewhere else in the code

function Frame:update()
    Frame.super.update(self)
    self:moveWithCollisions(self.x,self.y)
    actualX, actualY, collisions, length = self:moveWithCollisions(self.x, self.y)
    --print (self.x, self.y)
    if collisions[1] ~= nil then 
      self.freqs:update(true)
      
    end
end


function Frame:collisionResponse(self, other)
    print ("collision ", self.response)
    return self.response
end



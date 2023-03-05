import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "Frame/Frame"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("LP").extends(gfx.sprite)

function LP:init(x, y, image) -- each part of the picture frame is its own object
    LP.super.init(self)
    self.static = true
    self:setImage(image)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())
    self.isColliding = false;
    self.x = x
    
end

function LP:update()
    actualX, actualY, collisions, length = self:checkCollisions(self.x, self.y)
      self.isColliding = true;

    end    





function LP:collisionResponse(self, other)
    return gfx.sprite.kCollisionTypeOverlap
end




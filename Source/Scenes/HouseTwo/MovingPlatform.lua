import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad

class('MovingPlatform').extends(gfx.sprite)  --not a RigidBody2D

function MovingPlatform:init(x, y)
    MovingPlatform.super.init(self)
    local platformSprite = gfx.image.new("Scenes/HouseTwo/connector.png" )
    self:setImage(platformSprite)
    self:moveTo(x, y)
    
    self.centerX = x
    self.centerY = y

    self.radius = 62
end

function MovingPlatform:update() --this is extending the sprites update function
    MovingPlatform.super.update(self)
    
    xPosition = self.centerX + cos(rad(pd.getCrankPosition() - 90))*self.radius
    yPosition = self.centerY + sin(rad(pd.getCrankPosition() - 90))*self.radius
    self:moveTo(xPosition, yPosition)
    
end
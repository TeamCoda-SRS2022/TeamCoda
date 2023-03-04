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
    local platformSprite = gfx.image.new("Platforms/PlatedPlatform.png" )
    self:setImage(platformSprite)
    self:moveTo(x, y)
    self:add()
end

function MovingPlatform:update() --this is extending the sprites update function
    MovingPlatform.super.update(self)
    xPosition = 200 + cos(rad(pd.getCrankPosition()))*100
    yPosition = 120 + sin(rad(pd.getCrankPosition()))*100
    self:moveTo(xPosition, yPosition)
end
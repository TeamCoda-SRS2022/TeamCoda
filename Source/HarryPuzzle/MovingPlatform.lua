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
    local platformSprite = gfx.image.new("HarryPuzzle/connector.png" )
    self:setImage(platformSprite)
    self:moveTo(x, y)
    self:add()
end

function MovingPlatform:update() --this is extending the sprites update function
    MovingPlatform.super.update(self)
    xPosition = 270 + cos(rad(pd.getCrankPosition()))*62
    yPosition = 114 + sin(rad(pd.getCrankPosition()))*62
    self:moveTo(xPosition, yPosition)
end
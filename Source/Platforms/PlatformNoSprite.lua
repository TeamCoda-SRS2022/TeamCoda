import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/Physics/RigidBody2D"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('PlatformNoSprite').extends(RigidBody2D)


function PlatformNoSprite:init(x, y, width, height)
    PlatformNoSprite.super.initNoSprite(self, x, y, width, height)
    self.width = width
	self.height = height
    self.static = true
end
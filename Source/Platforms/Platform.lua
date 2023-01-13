import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform').extends(RigidBody2D)

function Platform:init(spriteString, x, y)
    Platform.super.init(self, spriteString, x, y)
    self.static = true
end
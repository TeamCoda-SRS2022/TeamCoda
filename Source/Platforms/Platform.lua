import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/Physics/RigidBody2D"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Platform').extends(RigidBody2D)

function Platform:init(x, y, image)
    Platform.super.init(self, x, y, image)
    self.static = true
end
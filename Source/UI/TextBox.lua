import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate

class('RigidBody2D').extends(Object)

function TextBox:init()
    RigidBody2D.super.init(self)
end

function TextBox:update()
    RigidBody2D.super.update(self)
end
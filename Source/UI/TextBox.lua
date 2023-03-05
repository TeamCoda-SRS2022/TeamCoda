import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate

class('TextBox').extends(Object)

function TextBox:init()
    TextBox.super.init(self)
end

function TextBox:update()
    TextBox.super.update(self)
end
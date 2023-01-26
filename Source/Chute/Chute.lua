import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Chute').extends(gfx.sprite)

function Chute:init(x, y, image)
    Chute.super.init(self, x, y, image)
    self:setImage(image)
    self:moveTo( x, y )
end
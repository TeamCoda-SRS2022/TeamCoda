import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class("Frame").extends(gfx.sprite)

function Frame:init(x, y, image) -- each part of the picture frame is its own object
   Frame.super.init(self)
   self:setImage(image)
   self:moveTo(x, y)
end


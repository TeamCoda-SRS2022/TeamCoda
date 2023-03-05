import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/Crank"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "LP/LP"


local pd <const> = playdate
local gfx <const> = pd.graphics

class("Button").extends(gfx.sprite)

function Button:init(x, y, image)
    Frequency.super.init(self)
    self:moveTo(x, y)
    self:setCollideRect(0, 0, self:getSize())   
    self:setImage(image)
    self.bar = Frequency(x, y-30)

end
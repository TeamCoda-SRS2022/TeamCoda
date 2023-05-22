import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Deadbot').extends(gfx.sprite)

local INITIAL_Y_POS = 20;

function Deadbot:init(x, image)
    Deadbot.super.init(self, x, INITIAL_Y_POS, image)
    self:setImage(image)
    self:setZIndex(-1)
    self:moveTo( x, INITIAL_Y_POS )
    self.velocity = 0
end

function Deadbot:update()
    self.velocity += gravity
    self:moveTo(self.x, self.y + self.velocity)
end

function Deadbot:reset_dead_bot()
    self.velocity = 0
    self.y = INITIAL_Y_POS
end
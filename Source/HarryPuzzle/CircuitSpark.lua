import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('CircuitSpark').extends(gfx.sprite)

function CircuitSpark:init(x, y, direction)
    CircuitSpark.super.init(self)
    self.direction = direction
    local sparkSprite = gfx.image.new("HarryPuzzle/spark.png" )
    self:setImage(sparkSprite)
    self:moveTo(x, y)
    self:add()
end

function CircuitSpark:update()
    CircuitSpark.super.update(self)

    if self.direction == 'right' then
        self:moveBy(1, 0)
    elseif self.direction == 'left' then
        self:moveBy(-1, 0)
    elseif self.direction == 'up' then
        self:moveBy(0, 1)
    elseif self.direction == 'down' then
        self:moveBy(0, -1)
    else
        error('invalid direction to spark movement')
    end
end
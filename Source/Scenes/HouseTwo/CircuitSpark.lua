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
    self.success = false
    local sparkSprite = gfx.image.new("Scenes/HouseTwo/spark.png" )
    self:setImage(sparkSprite)
    self:moveTo(x, y)

    self.speed = 4
end

function CircuitSpark:update()
    CircuitSpark.super.update(self)

    if self.direction == 'right' then
        if self.x < 270 then
            self:moveBy(self.speed, 0)
        else
            self:remove()
        end
    elseif self.direction == 'left' then
        if self.x > 270 then
            self:moveBy(-self.speed, 0)
        else
            self:remove()
        end
    elseif self.direction == 'up' then
        if self.y < 114 then
            self:moveBy(0, self.speed)
        else
            self:remove()
        end
    elseif self.direction == 'down' then
        if self.y > 114 then
            self:moveBy(0, -self.speed)
        else
            self:remove()
        end
    else
        error('invalid direction to spark movement')
    end
end

function CircuitSpark:setSuccess(bool)
    self.success = bool
end

function CircuitSpark:getSuccess()
    return self.success
end

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "Scenes/HouseTwo/MovingPlatform"
import "Scenes/HouseTwo/CircuitSpark"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad


class('CrankOsu').extends(gfx.sprite)

function CrankOsu:init(tempo, winScore)
    self.MovingPlatform = MovingPlatform(200, 120)
    self.spawnTimer = pd.timer.performAfterDelay(tempo, function() self:spawnSpark() end)
    self.spawnTimer.repeats = true
    self.updateTimer = pd.timer.new(1, function() self:update() end)
    self.updateTimer.repeats = true

    self.complete = false
    self.winScore = winScore;
    self.score = 0
    self.sparks = {}
end

function CrankOsu:spawnSpark()
    direction = math.random(4)
    
    if direction == 1 then
        pos = math.random(2)
        if pos == 1 then
            spark = CircuitSpark(40, 88, 'right')
            spark:add()
            self.sparks[#self.sparks+1] = spark
        else
            spark = CircuitSpark(40, 139, 'right')
            spark:add()
            self.sparks[#self.sparks+1] = spark
        end
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'right', self.sceneObjects))
    elseif direction == 2 then
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'left', self.sceneObjects))
        pos = math.random(2)
        if pos == 1 then
            spark = CircuitSpark(360, 88, 'left')
            spark:add()
            self.sparks[#self.sparks+1] = spark
        else
            spark = CircuitSpark(360, 139, 'left')
            spark:add()
            self.sparks[#self.sparks+1] = spark
        end
    elseif direction == 3 then
        spark = CircuitSpark(270, 40, 'up')
        spark:add()
        self.sparks[#self.sparks+1] = spark
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'up', self.sceneObjects))
    elseif direction == 4 then
        spark = CircuitSpark(270, 200, 'down')
        spark:add()
        self.sparks[#self.sparks+1] = spark
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'down', self.sceneObjects))
    end
end

function CrankOsu:update()
    for i, spark in ipairs(self.sparks) do
        if (distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y) < 10) and (not spark:getSuccess()) then
            self.score += 1
            spark:setSuccess(true)
        elseif (distance(spark.x, spark.y, 270, 114) < 61) and (not spark:getSuccess()) then
            spark:remove()
            table.remove(self.sparks, i)
        end
    end

    if self.score >= self.winScore then
        self.complete = true
        self.spawnTimer:remove()
        local backgroundImage = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOn1.png" )
        assert( backgroundImage )
        gfx.sprite.setBackgroundDrawingCallback(
            function( x, y, width, height )
                backgroundImage:draw( 40, 32 )
            end
        )
    end

end

function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end


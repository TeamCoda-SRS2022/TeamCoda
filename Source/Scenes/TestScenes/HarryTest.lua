import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Scenes/Town"
import "Scenes/FactoryElevator"
import "Scenes/TestScenes/CrankOsuAssets/MovingPlatform"
import "Scenes/TestScenes/CrankOsuAssets/CircuitSpark"
import "Scenes/TestScenes/CrankOsuAssets/CrankOsu"

local pd <const> = playdate
local gfx <const> = pd.graphics


class('HarryTest').extends(Scene)

function HarryTest:init()
    HarryTest.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
    local DoorSprite = gfx.image.new("SceneTransition/door.png")

    self.player = Player(100, 100)
    self.player:setZIndex(2)

    --self.puzzle = CrankOsu(3000, 3)

    self.MovingPlatform = MovingPlatform(200, 120)

    self.spawnTimer = pd.timer.performAfterDelay(2000, function() self:spawnSpark() end)
    self.spawnTimer.repeats = true
    self.updateTimer = pd.timer.new(1, function() self:update() end)
    self.updateTimer.repeats = true

    self.complete = false
    self.winScore = 3;
    self.score = 0
    self.sparks = {}

    self.TownEntrance = SceneTransition(81, 175, DoorSprite, self.player, Town(), false, 30)
    self.TownEntrance:setZIndex(-10)
    self.NextPuzzleEntrance = SceneTransition(340, 175, DoorSprite, self.player, FactoryElevator(), true, 30)
    self.NextPuzzleEntrance:setZIndex(-10)

    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        Platform(200, 200, platformSprite),
        Platform(250, 200, platformSprite),
        Platform(300, 200, platformSprite),
        self.TownEntrance,
        self.NextPuzzleEntrance,
        self.MovingPlatform
    }
end


function HarryTest:load()
    HarryTest.super.load(self)

    local receiverImage = gfx.image.new( "Scenes/TestScenes/CrankOsuAssets/Receiver.png" )
    assert ( receiverImage )
    local receiverSprite = gfx.sprite.new( receiverImage )
    self.receiverSprite = receiverSprite
    receiverSprite:moveTo( 270, 114 )
    receiverSprite:setZIndex(1)
    receiverSprite:add()

    local backgroundImage = gfx.image.new( "Scenes/TestScenes/CrankOsuAssets/PowerPlant-LightsOff.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 40, 32 )
		end
	)
end


function HarryTest:spawnSpark()
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


function HarryTest:update()
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
        self.updateTimer:remove()
        self.NextPuzzleEntrance:toggleLock()
        local backgroundImage = gfx.image.new( "Scenes/TestScenes/CrankOsuAssets/PowerPlant-LightsOn1.png" )
        assert( backgroundImage )
        gfx.sprite.setBackgroundDrawingCallback(
            function( x, y, width, height )
                backgroundImage:draw( 40, 32 )
            end
        )
    end

end


function HarryTest:unload()
    self.spawnTimer:remove()
    self.updateTimer:remove()
    self.receiverSprite:remove()

    for i=1, #self.sceneObjects,1
    do
        self.sceneObjects[i]:remove()
    end

    for i, spark in ipairs(self.sparks) do
        spark:remove()
    end

    --gfx.clear()

    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )
	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end


function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
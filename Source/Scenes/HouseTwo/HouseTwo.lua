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
import "Scenes/HouseTwo/MovingPlatform"
import "Scenes/HouseTwo/CircuitSpark"

local pd <const> = playdate
local gfx <const> = pd.graphics


class('HouseTwo').extends(Scene)

function HouseTwo:init()
    HouseTwo.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
    local DoorSprite = gfx.image.new("SceneTransition/door.png")

    self.player = Player(100, 100)
    self.player:setZIndex(2)

    self.MovingPlatform = MovingPlatform(270, 114)

    self.complete = false
    self.winScore = 8
    self.score = 0
    self.sparks = {}

    self.sparkPattern = {-1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 1, 1, 0, 1, 0, 0, -1, -1}
    self.curSpark = #self.sparkPattern

    self.audio = pd.sound.fileplayer.new("Scenes/HouseTwo/HouseTwo")

    self.bpm = 80
    self.spawnTimer = pd.timer.performAfterDelay(60 * 1000 / self.bpm, function() 
        self.curSpark += 1
        if self.curSpark > #self.sparkPattern then
            self.audio:play()
            self.score = 0
            self.curSpark = 1
        end
        print(self.curSpark)

        if self.sparkPattern[self.curSpark] > -1 then
            self:spawnSpark(self.sparkPattern[self.curSpark])
        end
    end)
    self.spawnTimer.repeats = true

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


function HouseTwo:load()
    HouseTwo.super.load(self)

    local receiverImage = gfx.image.new( "Scenes/HouseTwo/Receiver.png" )
    assert ( receiverImage )
    local receiverSprite = gfx.sprite.new( receiverImage )
    self.receiverSprite = receiverSprite
    receiverSprite:moveTo( 270, 114 )
    receiverSprite:setZIndex(1)
    self:add(receiverSprite)

    local backgroundImage = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOff.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 40, 32 )
		end
	)
end


function HouseTwo:spawnSpark(pos)
    if pos == 1 then
        spark = CircuitSpark(40, 88, 'right')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    else
        spark = CircuitSpark(40, 139, 'right')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    end
end


function HouseTwo:update()
    HouseTwo.super.update(self)

    for i, spark in ipairs(self.sparks) do
        if (distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y) < 10) and (not spark:getSuccess()) then
            self.score += 1
            spark:setSuccess(true)
        elseif (distance(spark.x, spark.y, self.MovingPlatform.centerX, self.MovingPlatform.centerY) < 61) and (not spark:getSuccess()) then
            self:remove(spark)
            table.remove(self.sparks, i)
        end
    end

    if self.score >= self.winScore then
        self.complete = true
        self.spawnTimer:remove()
        self.NextPuzzleEntrance:toggleLock()
        local backgroundImage = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOn1.png" )
        assert( backgroundImage )
        gfx.sprite.setBackgroundDrawingCallback(
            function( x, y, width, height )
                backgroundImage:draw( 40, 32 )
            end
        )
    end

end


function HouseTwo:unload()
    HouseTwo.super.unload(self)

    self.spawnTimer:remove()
    self.receiverSprite:remove()

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
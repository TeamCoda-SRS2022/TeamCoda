import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
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

    self.MovingPlatform = MovingPlatform(200, 114)

    self.completed = false
    self.winScore = 8
    self.score = 0
    self.sparks = {}

    self.sparkPattern = {-1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 1, 1, 2, 2, 3, 3, -1, -1}
    self.curSpark = #self.sparkPattern

    self.audio = pd.sound.fileplayer.new("Scenes/HouseTwo/HouseTwo")

    self.bpm = 80

    

    self.TownEntrance = SceneTransition(81, 175, DoorSprite, self.player, 1, false, 30)
    self.TownEntrance:setZIndex(-10)

    self.sceneObjects = {
        self.player.interactableSprite,
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        Platform(200, 200, platformSprite),
        Platform(250, 200, platformSprite),
        Platform(300, 200, platformSprite),
        self.TownEntrance,
        self.MovingPlatform
    }
end


function HouseTwo:load()
    HouseTwo.super.load(self)

    self.spawnTimer = pd.timer.performAfterDelay(60 * 1000 / self.bpm, function() 
        self.curSpark += 1
        if self.curSpark > #self.sparkPattern then
            self.audio:play()
            self.score = 0
            self.curSpark = 1
        end
       -- print(self.curSpark)

        if self.sparkPattern[self.curSpark] > -1 then
            self:spawnSpark(self.sparkPattern[self.curSpark])
        end
    end)
    self.spawnTimer.repeats = true

    local backgroundImage = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOff1.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 40, 32 )
		end
	)
end


function HouseTwo:spawnSpark(pos)
    if pos == 0 then
        spark = CircuitSpark(360, 139, 'left')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    elseif pos == 1 then 
        spark = CircuitSpark(360, 88, 'left')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    elseif pos == 2 then
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
        print(self.score, self.MovingPlatform.x)
        print((distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y)))
        if (distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y) < 11) and (not spark:getSuccess()) then
            self.score += 1
            spark:setSuccess(true)
        elseif (distance(spark.x, spark.y, self.MovingPlatform.centerX, self.MovingPlatform.centerY) < 61) and (not spark:getSuccess()) then
            self:remove(spark)
            table.remove(self.sparks, i)
        end
        --print(spark.x, spark.y)
    end

    if self.score >= self.winScore then
        self.completed = true
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


function HouseTwo:unload()
    HouseTwo.super.unload(self)

    self.spawnTimer:remove()


    
    self.audio:stop()
end


function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
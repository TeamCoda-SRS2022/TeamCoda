import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/animation"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/PlatformNoSprite"
import "SceneTransition/SceneTransition"
import "Scenes/HouseTwo/MovingPlatform"
import "Scenes/HouseTwo/CircuitSpark"

local pd <const> = playdate
local gfx <const> = pd.graphics


class('HouseTwo').extends(Scene)

function HouseTwo:init()
    HouseTwo.super.init(self)

    local DoorSprite = gfx.image.new("SceneTransition/door.png")
    DoorSprite = DoorSprite:scaledImage(1.25)

    self.player = Player(100, 100)
    self.player:setZIndex(2)

    self.MovingPlatform = MovingPlatform(200, 102)

    self.completed = false
    self.winScore = 8
    self.score = 0
    self.sparks = {}

    self.sparkPattern = {-1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 1, 1, 2, 2, 3, 3, -1, -1}
    self.curSpark = #self.sparkPattern

    self.audio = pd.sound.fileplayer.new("Scenes/HouseTwo/HouseTwo")

    self.bpm = 80

    local bgimagetable = gfx.imagetable.new("Scenes/HouseTwo/PowerPlant/PowerPlant-LightsOn")
    self.completeAnimation = gfx.animation.loop.new(250 , bgimagetable, true)  
    self.bgDone = gfx.sprite.new()
    self.bgDone:setCenter(0, 0)
    self.bgDone:moveTo(0, 0)
    self.bgDone:setZIndex(-32768)
    self.bgDone:setIgnoresDrawOffset(true)

    self.TownEntrance = SceneTransition(51, 190, DoorSprite, self.player, 1, false, 30)
    self.TownEntrance:setZIndex(-10)

    self.sceneObjects = {
        self.player.interactableSprite,
        self.player,

        PlatformNoSprite(0, 220, 400, 75),
        PlatformNoSprite(-50, 0, 50, 240),
        PlatformNoSprite(400, 0, 50, 240),
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

    self.completedSFX = pd.sound.sampleplayer.new("Assets/SFX/sparkle")
    self.notehitSFX = pd.sound.sampleplayer.new("Assets/SFX/notehit")

    gfx.setBackgroundColor(playdate.graphics.kColorBlack)

    local backgroundImage = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOff1.png" )
	assert( backgroundImage )
	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:drawScaled( 0, 0, 1.25 )
		end
	)
end


function HouseTwo:spawnSpark(pos)
    if pos == 0 then
        spark = CircuitSpark(400, 134, 'left')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    elseif pos == 1 then 
        spark = CircuitSpark(400, 70, 'left')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    elseif pos == 2 then
        spark = CircuitSpark(0, 70, 'right')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark
    else 
        spark = CircuitSpark(0, 134, 'right')
        self:add(spark)
        self.sparks[#self.sparks+1] = spark  
    end
end


function HouseTwo:update()
    HouseTwo.super.update(self)
    
    for i, spark in ipairs(self.sparks) do
        --print(self.score, self.MovingPlatform.x)
        --print((distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y)))
        if (distance(spark.x, spark.y, self.MovingPlatform.x, self.MovingPlatform.y) < 11) and (not spark:getSuccess()) then
            self.notehitSFX:play()
            self.score += 1
            spark:setSuccess(true)
        elseif (distance(spark.x, spark.y, self.MovingPlatform.centerX, self.MovingPlatform.centerY) < 78) and (not spark:getSuccess()) then
            self:remove(spark)
            table.remove(self.sparks, i)
        end
        --print(spark.x, spark.y)
    end

    if not self.completed and self.score >= self.winScore then  -- called once after completion
        self.completed = true
        self.completedSFX:play()
        self.spawnTimer:remove()

    end

    if self.completed then
        self.bgDone:setImage(self.completeAnimation:image(), gfx.kImageUnflipped, 1.25)
        self.bgDone:add()
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
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "Scenes/TestScenes/CrankOsuAssets/MovingPlatform"
import "Scenes/TestScenes/CrankOsuAssets/CircuitSpark"
import "Scenes/TestScenes/CrankOsuAssets/CrankOsu"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad

class('HarryTest').extends(Scene)

function HarryTest:init()
    HarryTest.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )

    self.player = Player(100, 100)
    --self.MovingPlatform = MovingPlatform(200, 120)

    --self.spawnTimer = playdate.timer.performAfterDelay(500, function() self:spawnSpark() end)
    --self.spawnTimer.repeats = true

    self.puzzle = CrankOsu(3000, 3)

    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        self.MovingPlatform,
    }
end


function HarryTest:load()
    HarryTest.super.load(self)

    local receiverImage = gfx.image.new( "Scenes/TestScenes/CrankOsuAssets/Receiver.png" )
    assert ( receiverImage )
    local receiverSprite = gfx.sprite.new( receiverImage )
    --receiverSprite:setZIndex(30000)
    receiverSprite:moveTo( 270, 114 )
    receiverSprite:setZIndex(10)
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
            CircuitSpark(40, 88, 'right'):add()
        else
            CircuitSpark(40, 139, 'right'):add()
        end
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'right', self.sceneObjects))
    elseif direction == 2 then
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'left', self.sceneObjects))
        pos = math.random(2)
        if pos == 1 then
            CircuitSpark(360, 88, 'left'):add()
        else
            CircuitSpark(360, 139, 'left'):add()
        end
    elseif direction == 3 then
        CircuitSpark(270, 40, 'up'):add()
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'up', self.sceneObjects))
    elseif direction == 4 then
        CircuitSpark(270, 200, 'down'):add()
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'down', self.sceneObjects))
    end
end


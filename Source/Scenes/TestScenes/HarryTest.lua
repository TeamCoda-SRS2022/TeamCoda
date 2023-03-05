import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "HarryPuzzle/MovingPlatform"
import "HarryPuzzle/CircuitSpark"

local pd <const> = playdate
local gfx <const> = pd.graphics
local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad

class('HarryTest').extends(Scene)

function HarryTest:init()
    HarryTest.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )

    self.player = Player(100, 100)
    self.MovingPlatform = MovingPlatform(200, 120)
    self.sparks = {}

    --self.spawnTimer = playdate.timer.performAfterDelay(5000, self.spawnSpark)
    --self.spawnTimer.repeats = true
    -- self.sparks = {CircuitSpark(100, 150, 'right'), CircuitSpark(100, 90, 'right'),
    --                 CircuitSpark(300, 150, 'left'), CircuitSpark(300, 90, 'left'),
    --                 CircuitSpark(200, 40, 'up'), CircuitSpark(200, 200, 'down')}


    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        self.MovingPlatform,
        --self.sparks
    }
end



function HarryTest:load()
    HarryTest.super.load(self)

    local backgroundImage = gfx.image.new( "HarryPuzzle/PowerPlant-LightsOff.png" )
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
        table.insert(self.sparks, CircuitSpark(100, 150, 'right'))
    elseif direction == 2 then
        table.insert(self.sparks, CircuitSpark(100, 150, 'left'))
    elseif direction == 3 then
        table.insert(self.sparks, CircuitSpark(100, 150, 'up'))
    elseif direction == 4 then
        table.insert(self.sparks, CircuitSpark(100, 150, 'down'))
    end
end


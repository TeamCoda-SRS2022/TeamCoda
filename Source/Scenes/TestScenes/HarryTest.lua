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

    self.spawnTimer = playdate.timer.performAfterDelay(5000, function() self:spawnSpark() end)
    self.spawnTimer.repeats = true

    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        self.MovingPlatform,
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
        CircuitSpark(100, 150, 'right'):add()
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'right', self.sceneObjects))
    elseif direction == 2 then
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'left', self.sceneObjects))
        CircuitSpark(100, 150, 'left'):add()
    elseif direction == 3 then
        CircuitSpark(100, 150, 'up'):add()
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'up', self.sceneObjects))
    elseif direction == 4 then
        CircuitSpark(100, 150, 'down'):add()
        -- table.insert(self.sceneObjects, CircuitSpark(100, 150, 'down', self.sceneObjects))
    end
end


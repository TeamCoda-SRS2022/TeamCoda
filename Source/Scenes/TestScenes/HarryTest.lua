import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "Platforms/MovingPlatform"

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

    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        self.MovingPlatform
    }
end



function HarryTest:load()
    HarryTest.super.load(self)
    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end


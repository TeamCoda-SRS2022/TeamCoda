import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('YunTest').extends(Scene)

function YunTest:init()
    self.sceneObjects = {
        Player(100, 100),
        Platform("Platforms/PlatedPlatform.png", 100, 200)
    }

    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end
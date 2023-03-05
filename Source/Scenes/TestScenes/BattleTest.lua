import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "YLib/RhythmInput/RhythmInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BattleTest').extends(Scene)

function BattleTest:init()
    BattleTest.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )

    self.sceneObjects = {
        Platform(32, 240-8, platformSprite),
        Platform(32+64, 240-8, platformSprite),
        Platform(32+64*2, 240-8, platformSprite),
        Platform(32+64*3, 240-8, platformSprite),
        Platform(32+64*4, 240-8, platformSprite),
        Platform(32+64*5, 240-8, platformSprite),
        Platform(32+64*6, 240-8, platformSprite),
    }
end

function BattleTest:load()
    BattleTest.super.load(self)
    
    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "player"
import "platform"

local gfx <const> = playdate.graphics

local a = RigidBody2D("Images/playerImage.png", 200,50);
local b = Platform;

local function init()
	b:init(200, 200)

	local backgroundImage = gfx.image.new( "Images/playerImage.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end
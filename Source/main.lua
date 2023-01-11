import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "player"

local gfx <const> = playdate.graphics

local function init()

	-- local backgroundImage = gfx.image.new( "" )
	-- assert( backgroundImage )

	-- gfx.sprite.setBackgroundDrawingCallback(
	-- 	function( x, y, width, height )
	-- 		backgroundImage:draw( 0, 0 )
	-- 	end
	-- )
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/YunTest"

local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5

local scene = YunTest()

local function init()
	scene:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/YunTest"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5

local curScene = YunTest()

local function init()
	curScene:load()
end

init()

function playdate.update()

	if pd.buttonIsPressed( pd.kButtonUp ) then
		loadScene(YunTest())
	end

	gfx.sprite.update()
	playdate.timer.updateTimers()
end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
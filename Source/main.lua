import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/TestScenes/HarryTest"
import "Scenes/TestScenes/YunTest"
import "Scenes/TestScenes/ChargingTest"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 100

local curScene = HarryTest()

local function init()
	curScene:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
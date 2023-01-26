import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/TestScenes/EricTest"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 150

local curScene = EricTest()

local function init()
	math.randomseed(playdate.getSecondsSinceEpoch())
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
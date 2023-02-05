import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/TestScenes/BattleTest"
import "Scenes/TestScenes/ChargingTest"
import "UI/RhythmInputUI"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 2
offset = -4

local curScene = BattleTest()

local function init()
	curScene:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	Scene.update()
end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
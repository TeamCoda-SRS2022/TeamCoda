import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/TestScenes/RhythmInputTest"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
local curScene = RhythmInputTest(4000, {0, 1000, 2000, 3000}, 100)

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
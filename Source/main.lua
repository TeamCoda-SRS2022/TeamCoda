import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "Scenes/Town"
import "Scenes/FloorOne/FloorOne"
import "Scenes/HouseTwo/HouseTwo"


local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 0.5
offset = 0

local curScene = FloorOne()

local function init()
	curScene:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	curScene:update()
    -- pd.drawFPS(200,200)
end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
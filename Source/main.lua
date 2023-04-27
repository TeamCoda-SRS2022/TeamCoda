import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "Scenes/Town"
import "Scenes/HouseOne/HouseOne"
import "Scenes/HouseTwo/HouseTwo"
import "Scenes/FloorOne/FloorOne"
import "Scenes/TestScenes/BossBattle"


local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 0.5
offset = 0

local curScene = 1
local scenes = {
	--Town(),
	--HouseOne(),
	--HouseTwo(),
	--FloorOne(),
	BossBattle(),
}

local function init()
	scenes[curScene]:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	scenes[curScene]:update()

	-- if scenes[2].completed and scenes[3].completed then
	-- 	scenes[1].BigDoor.locked = false
	-- end
    -- pd.drawFPS(200,200)
end

function loadScene(sceneNum)
	scenes[curScene]:unload()
	curScene = sceneNum
	scenes[curScene]:load()
end
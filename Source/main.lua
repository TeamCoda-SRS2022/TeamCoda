import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"
import "Scenes/Town"
import "Scenes/HouseOne/HouseOne"
import "Scenes/HouseTwo/HouseTwo"
import "Scenes/FloorOne/FloorOne"
import "Scenes/FactoryOne/FactoryOne"
import "Scenes/Cavern"
import "Scenes/TestScenes/BossBattle"
import "Scenes/Tutorial"
import "Scenes/FactoryElevator/FactoryElevator"
import "Scenes/MinibossScene/MinibossScene"


local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0.5
timeWindowLength = 0.5
offset = 0

local curScene = 6
local scenes = {
	Town(),
	HouseOne(),
	HouseTwo(),
	Cavern(),
	FloorOne(),
	FactoryOne(),
	BossBattle(),
	Tutorial(),
	FactoryElevator(5), -- Elevator to FloorOne
	MinibossScene(),
	FactoryElevator(1), -- Elevator to Town
	FactoryElevator(6), -- Elevator to FactoryOne
	FactoryElevator(10), -- Elevator to MinibossScene
}

local function init()
	math.randomseed(playdate.getSecondsSinceEpoch())
	scenes[curScene]:load()
end

init()

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	scenes[curScene]:update()

	if scenes[2].completed and scenes[3].completed then
		scenes[1].BigDoor.locked = false
		scenes[1].doorOpen = true
	end
	--pd.drawFPS(200,200)
end

function loadScene(sceneNum)
	scenes[curScene]:unload()
	curScene = sceneNum
	scenes[curScene]:load()
end
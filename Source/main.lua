import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
<<<<<<< HEAD
import "Scenes/MichTest"
=======
import "Scenes/TestScenes/BattleTest"
import "Scenes/TestScenes/ChargingTest"
>>>>>>> cda7c30cb75bc37ff72cda799b5dcfaca1163854

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
<<<<<<< HEAD
gravity = 0

local curScene = MichTest()
=======
gravity = 0.5
timeWindowLength = 0.5
offset = 0

local curScene = BattleTest()
>>>>>>> cda7c30cb75bc37ff72cda799b5dcfaca1163854

local function init()
	curScene:load()
end

init()

function playdate.update()
<<<<<<< HEAD

--	if pd.buttonIsPressed( pd.kButtonUp )  then
--		loadScene(MichTest())
--	end

=======
>>>>>>> cda7c30cb75bc37ff72cda799b5dcfaca1163854
	gfx.sprite.update()
	playdate.timer.updateTimers()
	playdate.frameTimer.updateTimers()
	Scene.update()
    pd.drawFPS(200,200)
end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
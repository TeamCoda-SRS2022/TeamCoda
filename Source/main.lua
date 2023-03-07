import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Scenes/MichTest"

local pd <const> = playdate
local gfx <const> = playdate.graphics

-- Global Variables
gravity = 0

local curScene = MichTest()

local function init()
	curScene:load()
end

init()

function playdate.update()

--	if pd.buttonIsPressed( pd.kButtonUp )  then
--		loadScene(MichTest())
--	end

gfx.sprite.update()

curScene:update()

end

function loadScene(sceneObj)
	curScene:unload()
	curScene = sceneObj
	curScene:load()
end
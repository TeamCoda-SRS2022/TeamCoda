
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

local TUTORIAL_INDEX <const> = 8
class('TitleScreen').extends(Scene)

function TitleScreen:init()
    TitleScreen.super.init(self)
    self.sceneObjects = {

    }
end

function TitleScreen:load()
    TitleScreen.super.load(self)
    local bg = gfx.image.new("Scenes/Backgrounds/title.png")
    assert(bg)
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
        bg:drawCentered(200, 120)
        end
    )
end

function TitleScreen:update()
    if
        pd.buttonIsPressed("right") or
        pd.buttonIsPressed("left") or
        pd.buttonIsPressed("a") or
        pd.buttonIsPressed("b") or
        pd.buttonIsPressed("up") or 
        pd.buttonIsPressed("down") 
    then
        loadScene(TUTORIAL_INDEX)
    end
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Credits').extends(Scene)

function Credits:init()
    TitleScreen.super.init(self)
    self.sceneObjects = {

    }
end

function Credits:load()
    TitleScreen.super.load(self)
    local bg = gfx.image.new("Scenes/Backgrounds/title_screen.png")
    assert(bg)
    gfx.sprite.setBackgroundDrawingCallback(
        function(x, y, width, height)
        bg:drawCentered(200, 120)
        end
    )
end

function Credits:update()
  
end
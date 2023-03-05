import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FactoryElevator').extends(Scene)

function FactoryElevator:init()
    FactoryElevator.super.init(self)

    self.player = Player(100, 100)


    local platformSprite = gfx.image.new("Platforms/PlatedPlatform.png")

    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite)
    }
end

function FactoryElevator:load()
    FactoryElevator.super.load(self)
    
end
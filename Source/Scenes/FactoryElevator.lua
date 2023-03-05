import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FactoryElevator').extends(Scene)

function FactoryElevator:init()
    FactoryElevator.super.init(self)

    self.sceneObjects = {
    }
end

function FactoryElevator:load()
    FactoryElevator.super.load(self)
    
end
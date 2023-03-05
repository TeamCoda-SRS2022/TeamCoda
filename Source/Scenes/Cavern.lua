import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cavern').extends(Scene)

function Cavern:init()
    Cavern.super.init(self)

    self.sceneObjects = {
        
    }
end

function Cavern:load()
    Cavern.super.load(self)
    
end
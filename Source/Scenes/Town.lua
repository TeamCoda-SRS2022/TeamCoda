import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Town').extends(Scene)

function Town:init()
    Town.super.init(self)

    self.player = Player(100, 100)
    
    self.sceneObjects = {

    }
end

function Town:load()
    Town.super.load(self)
    
end
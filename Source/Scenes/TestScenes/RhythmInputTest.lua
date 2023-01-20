import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('RhythmInputTest').extends(Scene)

function RhythmInputTest:init()
    RhythmInputTest.super.init(self)

    self.sceneObjects = {
        
    }
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cavern').extends(Scene)

function Cavern:init()
    Cavern.super.init(self)

    local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )

    self.player = Player(100, 100)
    
    self.sceneObjects = {
        self.player,
        Platform(100, 200, platformSprite)
    }
end

function Cavern:load()
    Cavern.super.load(self)
    
end
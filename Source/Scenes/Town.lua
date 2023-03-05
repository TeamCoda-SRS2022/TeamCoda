import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Scenes/Cavern"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Town').extends(Scene)

function Town:init()
    Town.super.init(self)

    local platformSprite = gfx.image.new("Platforms/PlatedPlatform.png")

    local FancyDoorSprite = gfx.image.new("SceneTransition/FancyDoor.png")

    self.player = Player(100, 100)

    local CavernEntrance = SceneTransition(190, 140, FancyDoorSprite, self.player, Cavern(), false, 80)

    self.sceneObjects = {
        self.player,
        CavernEntrance,
        Platform(100, 200, platformSprite)
    }
end

function Town:load()
    Town.super.load(self)
    
end
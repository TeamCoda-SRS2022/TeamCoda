import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cavern').extends(Scene)

function Cavern:init()
    Cavern.super.init(self)
    self.offsetx = 0

    self.platformSprite = gfx.image.new("Assets/floor.png")

    self.player = Player(100, 100)
    
    self.sceneObjects = {
        self.player,
        Platform(337, 237, self.platformSprite),
        Platform(900, 237, self.platformSprite),
        Platform(337, 237, gfx.image.new("Assets/caveBg.png"))
    }
end

function Cavern:load()
    Cavern.super.load(self)
    playdate.graphics.setDrawOffset(self.offsetx, 0)

    local bg = gfx.sprite.new(gfx.image.new("Assets/caveBg.png"))
    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    self:add(bg)
    bg:setZIndex(-1)
    local plat = gfx.image.new( "Scenes/HouseTwo/PowerPlant-LightsOff1.png" )
end

function Cavern:unload()
    Town.super.unload(self)
    playdate.graphics.setDrawOffset(0, 0)
end

function Cavern:update()
    Town.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -800) then self.offsetx = -800 end
    print(self.offsetx)
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end
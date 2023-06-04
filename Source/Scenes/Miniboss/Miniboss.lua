import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "Platforms/PlatformNoSprite"
import "SceneTransition/SceneTransition"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Miniboss').extends(Scene)

function Miniboss:init()
    Miniboss.super.init(self)
    self.offsetx = 0
    self.player = Player(100, 100)
    
    local platformSprite = gfx.image.new("Assets/floor.png")
    local doorSprite = gfx.image.new("SceneTransition/door.png")

    self.exit_door = SceneTransition(440, 200, doorSprite, self.player, 4, true, 80)
    self.sceneObjects = {
        self.player,
        Platform(337, 237, platformSprite),
        PlatformNoSprite(-10, 0, 10, 240),
        PlatformNoSprite(520, 0, 10, 240),
        self.exit_door
    }

end

function Miniboss:load()
    Miniboss.super.load(self)
    bg = gfx.sprite.new(gfx.image.new("Scenes/Miniboss/miniboss_bg.png"))
    playdate.graphics.setDrawOffset(self.offsetx, 0)

    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    self:add(bg)
    bg:setZIndex(-1)
end

function Miniboss:update()
    Miniboss.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -110) then self.offsetx = -110 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end
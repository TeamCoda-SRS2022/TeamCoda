import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Player/RhythmInput"
import "Platforms/PlatformNoSprite"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SmallPlat').extends(Platform)

-- function SmallPlat:init(x, y)
--     local 
--     SmallPlat.super.init(self, x, y, )
-- end


class('BossOne').extends(Scene)

function BossOne:init()
    BossOne.super.init(self)
    self.x_offset = 0
    self.y_offset = 0

    self.player = Player(100, 200)

    self.bg = gfx.sprite.new(gfx.image.new("Scenes/BossOne/boss_one_bg.png"))

    local smallPlatSprite = gfx.image.new("Scenes/BossOne/small_plat.png")
    assert(smallPlatSprite)
    self.sceneObjects = {
        self.player,
        PlatformNoSprite(103, 730, 1000, 10),
        Platform(55, 732, smallPlatSprite),
        Platform(27, 685, smallPlatSprite),
        Platform(56, 640, smallPlatSprite),
        Platform(93, 601, smallPlatSprite),
        Platform(143, 572, smallPlatSprite),
        Platform(197, 551, smallPlatSprite),
        Platform(233, 521, smallPlatSprite),

        Platform(320, 458, smallPlatSprite),
        Platform(320, 487, smallPlatSprite),


        Platform(615, 714, smallPlatSprite),
        Platform(550, 679, smallPlatSprite),
        Platform(615, 646, smallPlatSprite),
        Platform(550, 611, smallPlatSprite),
        Platform(615, 577, smallPlatSprite),

        Platform(550, 542, smallPlatSprite),
        Platform(615, 504, smallPlatSprite),
        Platform(550, 469, smallPlatSprite),
        Platform(615, 437, smallPlatSprite),
        Platform(550, 402, smallPlatSprite),
        Platform(615, 368, smallPlatSprite),

        Platform(550, 333, smallPlatSprite),
        Platform(615, 300, smallPlatSprite),
        Platform(550, 267, smallPlatSprite),
        Platform(615, 234, smallPlatSprite),
        Platform(550, 201, smallPlatSprite),
        Platform(615, 168, smallPlatSprite),

        PlatformNoSprite(69, 503, 109, 9),
        PlatformNoSprite(255, 504, 132, 9),
        PlatformNoSprite(86, 753, 177, 10)

    }
end

function BossOne:load()
    BossOne.super.load(self)

    playdate.graphics.setDrawOffset(self.x_offset, self.y_offset)
    -- playdate.graphics.setDrawOffset(self.x_offset, 0)

    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 0)
    self:add(self.bg)
    self.bg:setZIndex(-1)
end

function BossOne:update()
    BossOne.super.update(self)

    self.x_offset = - (self.player.x - 200)
    if(self.x_offset > 0) then self.x_offset = 0 end
    if(self.x_offset < -680) then self.x_offset = -680 end

    self.y_offset = - (self.player.y - 150)
    if(self.y_offset > 0) then self.y_offset = 0 end
    if(self.y_offset < -680) then self.y_offset = -680 end

    gfx.setDrawOffset(self.x_offset, self.y_offset)
end
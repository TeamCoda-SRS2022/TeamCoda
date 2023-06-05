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

class('SmallPlat').extends(PlatformNoSprite)

function SmallPlat:init(x, y)
    SmallPlat.super.init(self, x, y, 27, 11)
end


class('BossOne').extends(Scene)

function BossOne:init()
    BossOne.super.init(self)
    self.x_offset = 0
    self.y_offset = 0

    self.player = Player(100, 200)

    self.bg = gfx.sprite.new(gfx.image.new("Scenes/BossOne/boss_one_bg.png"))

    self.sceneObjects = {
        self.player,
        PlatformNoSprite(90, 710, 1000, 10),
        SmallPlat(42, 727),
        SmallPlat(14, 680),
        SmallPlat(43, 635),
        SmallPlat(80, 596)
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

    self.y_offset = - (self.player.y - 200)
    if(self.y_offset > 0) then self.y_offset = 0 end
    if(self.y_offset < -680) then self.y_offset = -680 end

    gfx.setDrawOffset(self.x_offset, self.y_offset)
end
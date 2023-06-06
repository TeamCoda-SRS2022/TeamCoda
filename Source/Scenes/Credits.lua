import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "YLib/SceneManagement/Scene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Credits').extends(Scene)

function Credits:init()
    Credits.super.init(self)

    self.sceneObjects = {

    }
end

function Credits:load()
    Credits.super.load(self)
    self.bg = gfx.sprite.new(gfx.image.new("Scenes/Backgrounds/Credits.png"))

    self.animator = gfx.animator.new(6000, 0, 240, pd.easingFunctions.outSine, 1000)

    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 0)
    self:add(self.bg)
    self.bg:setZIndex(-1)
end

function Credits:update()
  gfx.setDrawOffset(0, -self.animator:currentValue())
end
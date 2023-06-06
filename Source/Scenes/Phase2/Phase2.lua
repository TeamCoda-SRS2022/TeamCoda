import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/PlatformNoSprite"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Ylib/RhythmInput/BattleInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Phase2').extends(Scene)

function Phase2:init()
    Phase2.super.init(self)
    self.offsetx = 0
    self.offsety = 400
    self.player = Player(400, 425)
    

    math.randomseed(playdate.getSecondsSinceEpoch())

    local chartString = ""
    local chartLength = 50
    --local chartPattern = {0, 1, 2, 3, 2, 1, 0, 2, 3, -1, -1, 1, 2, 0, -1, 1, 0, 2, -1, 0, 0, 0}
    for i=1,chartLength do
        v = math.random(-1, 3)
        if v ~= -1 then
            local pattern = (i + 3) .. "=" .. v .. ","
            chartString = chartString .. pattern
        end
    end
    print(chartString)

    self.battle = BattleInput("", chartString, 120, 75.0, 285.0)
    self.battle.complete:push(
        function() 
            
        end
    )
    self.battleStarted = false

    local platformSprite = gfx.image.new("Platforms/PlatedPlatform.png")


    self.platform1 = PlatformNoSprite(346, 448, 105, 15)
    self.platform2 = PlatformNoSprite(293, 391, 56, 17)
    self.platform3 = PlatformNoSprite(450, 391, 56, 17)

    self.screen = gfx.sprite.new()
    self.screen:setCollideRect(0, 0, 200, 29)
    self.screen:setGroups(2)
    self.screen:setCollidesWithGroups(3)
    self.screen:moveTo(300, 214)
    

    self.sceneObjects = {
        self.player,
        self.player.interactableSprite,
        self.platform1,
        self.platform2,
        self.platform3,
        Platform(200, 342, platformSprite),
        Platform(246, 285, platformSprite),
        Platform(600, 342, platformSprite),
        Platform(554, 285, platformSprite),
        PlatformNoSprite(297, 249, 206, 39),
        self.screen,
    }

end

function Phase2:load()
    Phase2.super.load(self)
    self.bg = gfx.sprite.new(gfx.image.new("Scenes/Phase2/Phase2Robot.png"))
    playdate.graphics.setDrawOffset(self.offsetx, self.offsety)


    local myInputHandlers = {
      upButtonDown = function () 
        local sprites = self.screen:overlappingSprites()
            if #sprites > 0 and not self.battleStarted then  -- player collision
              self.battleStarted = true
              self.bg:setImage(gfx.image.new("Scenes/Phase2/Phase2BlankRobot.png"))
              self.battle:start()
            end
      end
  }
  pd.inputHandlers.push(myInputHandlers)

    gravity = 0.25

    --self.bg:setScale(0.75, 0.75)
    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 0)
    self:add(self.bg)
    self.bg:setZIndex(-1)
end

function Phase2:update()
    Phase2.super.update(self)
    if self.player.y > 480 then
      self.player:moveTo(400, 425)
    end


    if self.battleStarted then
      self.battle:update()
    end
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -400) then self.offsetx = -400 end
    self.offsety = - (self.player.y - 200)
    playdate.graphics.setDrawOffset(self.offsetx, self.offsety)
end
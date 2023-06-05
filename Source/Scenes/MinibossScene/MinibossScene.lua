import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"
import "Platforms/PlatformNoSprite"
import "SceneTransition/SceneTransition"
import "Miniboss/Miniboss"
import "Ylib/RhythmInput/BattleInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MinibossScene').extends(Scene)

function MinibossScene:init()
    MinibossScene.super.init(self)
    self.offsetx = 0
    self.player = Player(100, 200)
    
    local platformSprite = gfx.image.new("Assets/floor.png")
    local doorSprite = gfx.image.new("Scenes/MinibossScene/miniboss_door.png")

    self.miniboss = Miniboss(350, 200)

    self.minibossState = "idle"
    self.bossStarted = false
    self.bossDefeated = false

    math.randomseed(playdate.getSecondsSinceEpoch())

    local chartString = ""
    local chartLength = 20
    --local chartPattern = {0, 1, 2, 3, 2, 1, 0, 2, 3, -1, -1, 1, 2, 0, -1, 1, 0, 2, -1, 0, 0, 0}
    for i=1,chartLength do
        v = math.random(-1, 3)
        if v ~= -1 then
            local pattern = (i + 3) .. "=" .. v .. ","
            chartString = chartString .. pattern
        end
    end
    print(chartString)

    self.exit_door = SceneTransition(436, 189, doorSprite, self.player, 4, true, 80)
    self.battle = BattleInput("", chartString, 120)
    self.battle.complete:push(
        function() 
            self.exit_door.locked = false 
            self.miniboss:setCollidesWithGroups({1})
            self.miniboss:setGroups(5)
            self.miniboss:recover()
            self.bossDefeated = true
        end
    )
    

    
    self.sceneObjects = {
        self.player,
        Platform(337, 237, platformSprite),
        PlatformNoSprite(-10, 0, 10, 240),
        PlatformNoSprite(520, 0, 10, 240),
        self.exit_door,
        self.miniboss,
    }

end

function MinibossScene:load()
    MinibossScene.super.load(self)
    bg = gfx.sprite.new(gfx.image.new("Scenes/MinibossScene/miniboss_bg.png"))
    playdate.graphics.setDrawOffset(self.offsetx, 0)

    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    self:add(bg)
    bg:setZIndex(-1)
end

function MinibossScene:update()

    if self.player.x > 200 and not self.bossDefeated and not self.bossStarted then
        self.bossStarted = true
        self.battle:start()
    end
        
    if self.bossStarted and not self.bossDefeated then
        self.battle:update()
        if self.minibossState == "idle" then
            if math.random(4) == 1 then
                self.minibossState = "attack"
                self.miniboss:attack()
                pd.timer.performAfterDelay(2500, 
                    function ()
                        self.miniboss:idle()
                        self.minibossState = "idle"
                    end
                )
            else 
                self.minibossState = "waiting"
                pd.timer.performAfterDelay(2500, 
                    function ()
                    self.minibossState = "idle"
                    end
                )
                end
        end 
            
    end


    MinibossScene.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -110) then self.offsetx = -110 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end
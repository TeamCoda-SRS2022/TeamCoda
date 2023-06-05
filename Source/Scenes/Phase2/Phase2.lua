import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/PlatformNoSprite"
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

    self.battle = BattleInput("", chartString, 120)
    self.battle.complete:push(
        function() 
            
        end
    )

    self.platform1 = PlatformNoSprite(346, 448, 105, 15)
    self.platform2 = PlatformNoSprite(293, 391, 56, 17)
    self.platform3 = PlatformNoSprite(450, 391, 56, 17)
    

    self.sceneObjects = {
        self.player,
        self.platform1,
        self.platform2,
        self.platform3,
    }

end

function Phase2:load()
    Phase2.super.load(self)
    self.bg = gfx.sprite.new(gfx.image.new("Scenes/Phase2/Phase2Robot.png"))
    playdate.graphics.setDrawOffset(self.offsetx, self.offsety)

    --self.bg:setScale(0.75, 0.75)
    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 0)
    self:add(self.bg)
    self.bg:setZIndex(-1)
end

function Phase2:update()


    Phase2.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -600) then self.offsetx = -600 end
    self.offsety = - (self.player.y - 200)
    playdate.graphics.setDrawOffset(self.offsetx, self.offsety)
end
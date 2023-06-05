import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/math"
import "YLib/SceneManagement/Scene"
import "Platforms/PlatformNoSprite"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cavern').extends(Scene)

function Cavern:init()
    Cavern.super.init(self)
    self.offsetx = 0
    self.bgScale = 1.2
    self.objScale = 1.0

    self.platformSprite = gfx.image.new("Assets/floor.png")

    self.player = Player(50, 200)
    -- during zoom
    self.platform1 = PlatformNoSprite(0, 218, 350, 7)
    self.platform2 = PlatformNoSprite(350, 230, 50, 7)
    self.platform3 = PlatformNoSprite(400, 220, 50, 7)
    self.platform4 = PlatformNoSprite(425, 213, 50, 7)
    self.platform5 = PlatformNoSprite(450, 206, 50, 7)
    -- post zoom bridge
    self.platform7 = PlatformNoSprite(475, 185, 25, 7)
    self.platform8 = PlatformNoSprite(500, 178, 25, 7)
    self.platform9 = PlatformNoSprite(525, 171, 25, 7)
    self.platform10 = PlatformNoSprite(550, 164, 25, 7)
    self.platform11 = PlatformNoSprite(575, 157, 25, 7)
    self.platform12 = PlatformNoSprite(600, 150, 25, 7)
    self.platform13 = PlatformNoSprite(625, 143, 25, 7)
    self.platform14 = PlatformNoSprite(650, 136, 25, 7)
    self.platform15 = PlatformNoSprite(675, 129, 25, 7)
    self.platform16 = PlatformNoSprite(700, 122, 25, 7)
    -- after bridge
    self.platform17 = PlatformNoSprite(725, 132, 38, 7)
    self.platform18 = PlatformNoSprite(763, 135, 38, 7)
    self.platform19 = PlatformNoSprite(801, 126, 22, 7)
    self.platform20 = PlatformNoSprite(823, 118, 21, 7)
    self.platform21 = PlatformNoSprite(844, 102, 27, 7)
    self.platform22 = PlatformNoSprite(871, 85, 85, 7)
    self.platform23 = PlatformNoSprite(956, 75, 185, 7)
    self.platform24 = PlatformNoSprite(1141, 0, 7, 75)


    self.bg = gfx.sprite.new(gfx.image.new("Assets/caveBg.png"))
    self.ambience = pd.sound.fileplayer.new("Assets/SFX/cave_ambience")
    
    local elevatorSprite = gfx.image.new("Assets/TutorialroomElevator.PNG")

    self.sceneObjects = {
        self.player,
        self.player.interactableSprite,
        self.platform1,
        self.platform2,
        self.platform3,
        self.platform4,
        self.platform5,

        self.platform7,
        self.platform8,
        self.platform9,
        self.platform10,
        self.platform11,
        self.platform12,
        self.platform13,
        self.platform14,
        self.platform15,
        self.platform16,

        self.platform17,
        self.platform18,
        self.platform19,
        self.platform20,
        self.platform21,
        self.platform22,
        self.platform23,
        self.platform24,
        SceneTransition(1096, 41, elevatorSprite, self.player, 9, false, 80)
    }
end

function Cavern:load()
    Cavern.super.load(self)
    playdate.graphics.setDrawOffset(self.offsetx, 0)

    
    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, -45)
    self:add(self.bg)
    self.bg:setZIndex(-1)

    self.ambience:play(0)
end

function Cavern:unload()
    Town.super.unload(self)
    playdate.graphics.setDrawOffset(0, 0)
    self.ambience:stop()
end

function Cavern:update()
    Town.super.update(self)
        
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -800) then self.offsetx = -800 end

    local scale = (self.player.x - 350.0)/100.0
    
    self.bgScale = math.max(1.0, math.min(1.2, pd.math.lerp(1.2, 1.0, scale)))
    self.bg:moveTo(0, math.max(-45.0, math.min(0, pd.math.lerp(-45, 0, scale))))
    self.bg:setScale(self.bgScale, self.bgScale)

    self.objScale = math.max(0.8, math.min(1.0, pd.math.lerp(1.0, 0.8, scale)))
    self.player:setScale(self.objScale)
    self.player:setCollideRect(0, 0, self.player:getSize())
    self.platform1:setCollideRect(0, 0, self.objScale*self.platform1.width, self.objScale*self.platform1.height)
    self.platform2:setCollideRect(0, 0, self.objScale*self.platform2.width, self.objScale*self.platform2.height)
    self.platform3:setCollideRect(0, 0, self.objScale*self.platform3.width, self.objScale*self.platform3.height)
    self.platform4:setCollideRect(0, 0, self.objScale*self.platform4.width, self.objScale*self.platform4.height)
    self.platform5:setCollideRect(0, 0, self.objScale*self.platform5.width, self.objScale*self.platform5.height)


    playdate.graphics.setDrawOffset(self.offsetx, 0)
end
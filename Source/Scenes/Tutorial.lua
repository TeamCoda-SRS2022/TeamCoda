import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "YLib/SceneManagement/Scene"
import "Platforms/PlatformNoSprite"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "YLib/Interactable/InteractableBody"
import "YLib/Physics/RigidBody2D"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Tutorial').extends(Scene)

function Tutorial:init()
    Tutorial.super.init(self)

    self.offsetx = 0

    self.player = Player(600, 50)

    self.platform0 = PlatformNoSprite(-7, 0, 7, 149)
    self.platform1 = PlatformNoSprite(0, 149, 164, 7)
    self.platform2 = PlatformNoSprite(164, 187, 84, 7)
    self.platform3 = PlatformNoSprite(248, 168, 12, 7)
    self.platform4 = PlatformNoSprite(260, 155, 15, 7)
    self.platform5 = PlatformNoSprite(275, 139, 16, 7)
    self.platform6 = PlatformNoSprite(287, 124, 16, 7)
    self.platform7 = PlatformNoSprite(300, 110, 10, 7)
    self.platform8 = PlatformNoSprite(309, 102, 360, 7)
    self.platform9 = PlatformNoSprite(669, 108, 331, 7)
    self.platform10 = PlatformNoSprite(1000, 0, 7, 108)

    local doorCover = gfx.sprite.new(gfx.image.new("Assets/TutorialroomDoorCover.PNG"))
    doorCover:moveTo(850, 55)

    local door = gfx.image.new("Assets/TutorialroomDoor.png")
    self.door = RigidBody2D(850, 55, door)

    self.doorLever = gfx.sprite.new()
    self.doorLever:setCollideRect(0, 0, 33, 33)
    self.doorLever:setGroups(2)
    self.doorLever:setCollidesWithGroups(3)
    self.doorLever:moveTo(783, 75)


    self.bg = gfx.sprite.new(gfx.image.new("Assets/TutorialroomOPEN.PNG"))

    
    --self.ambience = pd.sound.fileplayer.new("Assets/SFX/cave_ambience")
    
    self.sceneObjects = {
        self.player,
        self.player.interactableSprite,
        self.platform0,
        self.platform1,
        self.platform2,
        self.platform3,
        self.platform4,
        self.platform5,
        self.platform6,
        self.platform7,
        self.platform8,
        self.platform9,
        self.platform10,
        self.door,
        doorCover,
        self.doorLever
    }
end

function Tutorial:load()
    Tutorial.super.load(self)
    gfx.setDrawOffset(self.offsetx, 0)

    
    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 0)
    self:add(self.bg)
    self.bg:setZIndex(-1)


    --self.ambience:play(0)
end

function Tutorial:unload()
    Tutorial.super.unload(self)
    playdate.graphics.setDrawOffset(0, 0)
    --self.ambience:stop()
end

function Tutorial:update()
    Tutorial.super.update(self)
        
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -680) then self.offsetx = -680 end
    gfx.setDrawOffset(self.offsetx, 0)

end
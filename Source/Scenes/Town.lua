import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Platforms/PlatformNoSprite"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Town').extends(Scene)

function Town:init()
    Town.super.init(self)
    self.offsetx = 0

    local platformSprite = gfx.image.new("Assets/floor.png")

    local FancyDoorSprite = gfx.image.new("SceneTransition/FancyDoor.png")
    local doorSprite = gfx.image.new( "SceneTransition/door.png" )

    self.ambience = pd.sound.fileplayer.new("Assets/SFX/town_music")

    self.player = Player(100, 200)

    local MINIBOSS_ROOM_INDEX <const> = 10

    local HouseOneDoor = SceneTransition(263, 225, doorSprite, self.player, 2, false, 80)
    local HouseTwoDoor = SceneTransition(540, 215, doorSprite, self.player, 3, false, 80)
    self.BigDoor = SceneTransition(410, 260, doorSprite, self.player, MINIBOSS_ROOM_INDEX, true, 80)

    self.doorOpen = false

    self.sceneObjects = {
        self.player,
        self.player.interactableSprite,
        HouseOneDoor,
        HouseTwoDoor,
        self.BigDoor,
        Platform(337, 237, platformSprite),
        PlatformNoSprite(-50, 0, 50, 240),
        PlatformNoSprite(675, 0, 50, 240),
    }
end

function Town:load()
    Town.super.load(self)


    playdate.graphics.setDrawOffset(self.offsetx, 0)

    if self.doorOpen then
        bg = gfx.sprite.new(gfx.image.new("Assets/openDoorTown.png"))
    else 
        bg = gfx.sprite.new(gfx.image.new("Assets/completeTown.png"))
    end
    
    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    self:add(bg)
    bg:setZIndex(-1)

    self.ambience:play(0)
    
end

function Town:unload()
    Town.super.unload(self)
    playdate.graphics.setDrawOffset(0, 0)
    self.ambience:stop()
end

function Town:update()
    Town.super.update(self)

    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -274) then self.offsetx = -274 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end

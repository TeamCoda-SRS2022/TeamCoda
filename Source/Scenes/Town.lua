import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
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

    self.player = Player(100, 100)

    local HouseOneDoor = SceneTransition(263, 225, doorSprite, self.player, 2, false, 80)
    local HouseTwoDoor = SceneTransition(540, 215, doorSprite, self.player, 3, false, 80)
    self.BigDoor = SceneTransition(410, 260, doorSprite, self.player, 5, true, 80)

    self.sceneObjects = {
        self.player,
        self.player.interactableSprite,
        HouseOneDoor,
        HouseTwoDoor,
        self.BigDoor,
        Platform(337, 237, platformSprite)
    }
end

function Town:load()
    Town.super.load(self)


    playdate.graphics.setDrawOffset(self.offsetx, 0)

    local bg = gfx.sprite.new(gfx.image.new("Assets/demo town.png"))
    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    self:add(bg)
    bg:setZIndex(-1)

    -- local backgroundImage = gfx.image.new( "Assets/demo town.png" )  -- replace with town backgroundImage
	-- assert( backgroundImage )

	-- gfx.sprite.setBackgroundDrawingCallback(
	-- 	function( x, y, width, height )
	-- 		backgroundImage:draw( 0, 0 )
	-- 	end
	-- )
    
end

function Town:unload()
    Town.super.unload(self)
    playdate.graphics.setDrawOffset(0, 0)
end

function Town:update()
    Town.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -274) then self.offsetx = -274 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end
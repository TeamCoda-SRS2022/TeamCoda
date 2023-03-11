import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Scenes/FactoryElevator"
import "Platforms/Platform"
import "SceneTransition/SceneTransition"
import "Player/Player"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Town').extends(Scene)

function Town:init()
    Town.super.init(self)

    local platformSprite = gfx.image.new("Assets/floor.png")

    local FancyDoorSprite = gfx.image.new("SceneTransition/FancyDoor.png")

    self.player = Player(100, 100)

    -- local FactoryElevatorEntrance = SceneTransition(190, 140, FancyDoorSprite, self.player, FactoryElevator(), false, 80)

    self.sceneObjects = {
        self.player,
        -- FactoryElevatorEntrance,
        Platform(337, 237, platformSprite)
    }
end

function Town:load()
    Town.super.load(self)

    local bg = gfx.sprite.new(gfx.image.new("Assets/demo town.png"))
    bg:setCenter(0, 0)
    bg:moveTo(0, 0)
    bg:add()
    bg:setZIndex(-1)

    -- local backgroundImage = gfx.image.new( "Assets/demo town.png" )  -- replace with town backgroundImage
	-- assert( backgroundImage )

	-- gfx.sprite.setBackgroundDrawingCallback(
	-- 	function( x, y, width, height )
	-- 		backgroundImage:draw( 0, 0 )
	-- 	end
	-- )
    
end

function Town:update()
    Town.super.update(self)
    local offsetx = - (self.player.x - 200)
    if(offsetx > 0) then offsetx = 0 end
    if(offsetx < -274) then offsetx = -274 end
    playdate.graphics.setDrawOffset(offsetx, 0)
end
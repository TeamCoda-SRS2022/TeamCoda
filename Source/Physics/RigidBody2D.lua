import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('RigidBody2D').extends(gfx.sprite)

function RigidBody2D:init(spriteString, x, y)
    RigidBody2D.super.init(self)

	local playerImage = gfx.image.new(spriteString)
	assert( playerImage )
	
	self:setImage(playerImage)
	self:moveTo( x, y )
	self:setCollideRect( 0, 0, self:getSize() )
	self:add()

	self.velocity = geo.vector2D.new(0, 0)
end

function RigidBody2D:update()
	if pd.buttonIsPressed( pd.kButtonUp ) then
		self.velocity.y = -2
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		self:move( 2, 0 )
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		self:move( -2, 0 )
	end
	
	self.velocity.y += 0.1
	self:move(0, self.velocity.y)
end

function RigidBody2D:move(x, y)
	local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + x, self.y + y)
	if collisions[1] ~= nil and collisions[1].normal.y == -1 then
		self.velocity.y = 0
	end
end
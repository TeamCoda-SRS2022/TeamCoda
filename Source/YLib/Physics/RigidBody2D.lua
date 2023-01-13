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

	self.velocity = geo.vector2D.new(0, 0)
	self.static = false
end

function RigidBody2D:update()
	if not self.static then
		self.velocity.y += gravity
		self:move(0, self.velocity.y)
	end
end

function RigidBody2D:move(x, y)
	local actualX, actualY, collisions, length = self:moveWithCollisions(self.x + x, self.y + y)
	if collisions[1] ~= nil and collisions[1].normal.y == -1 then
		self.velocity.y = 0
	end
end
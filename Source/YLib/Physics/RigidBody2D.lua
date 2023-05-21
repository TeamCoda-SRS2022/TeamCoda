import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('RigidBody2D').extends(gfx.sprite)

function RigidBody2D:init(x, y, sprite)
    RigidBody2D.super.init(self)
	
	self:setImage(sprite)
	self:setCollideRect( 0, 0, sprite:getSize() )
	self:setGroups(1) -- rigid body group 
	self:setCollidesWithGroups(1) -- only collide with rigid bodies
	self:moveTo( x, y )

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
	for i, collision in ipairs(collisions) do
		if collision.normal.y == -1 and collision.other:getGroupMask() == 1 then
			self.velocity.y = 0
		end
	end
	
	return actualX, actualY, collisions, length
end
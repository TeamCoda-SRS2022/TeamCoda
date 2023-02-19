import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "YLib/Physics/RigidBody2D"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(RigidBody2D)

local jumpHeight = 32

function Player:init(x, y)
	local idle = gfx.imagetable.new("Player/Animations/Idle/PlayerIdle")
	self.curAnim = gfx.animation.loop.new(125, idle, true)
	Player.super.init(self, x, y, self.curAnim:image())

	self.speed = 1
	self.jumpVelocity = math.sqrt(2 * gravity * jumpHeight)
	self.isFacingLeft = playdate.graphics.kImageUnflipped
	self.grounded = false
	self.collision = false
	self:setCollideRect(0, 0, self:getSize())

	
end

function Player:update()
	Player.super.update(self)

	self:setImage(self.curAnim:image())
	self:setImageFlip(self.isFacingLeft)

	if pd.buttonIsPressed( pd.kButtonRight ) or pd.buttonIsPressed( pd.kButtonLeft ) then 
		self.curAnim:setImageTable(gfx.imagetable.new("Player/Animations/Walk/PlayerWalk"))
	else
		self.curAnim:setImageTable(gfx.imagetable.new("Player/Animations/Idle/PlayerIdle"))
	end
	if pd.buttonIsPressed( pd.kButtonA ) and self.grounded then
		self.velocity.y = -self.jumpVelocity
		self.grounded = false
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		self:move( self.speed, 0 )
		self.isFacingLeft = playdate.graphics.kImageUnflipped
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		self:move( -self.speed, 0 )
		self.isFacingLeft = playdate.graphics.kImageFlippedX
	end
	if pd.buttonIsPressed( pd.kButtonDown ) then
		self:move( 0, self.speed )
	end
	self.collisionResponse = function(other)
		return gfx.sprite.kCollisionTypeOverlap
	end
end

function Player:move(x, y)
	local actualX, actualY, collisions, length = Player.super.move(self, x, y)
	if collisions[1] ~= nil and collisions[1].normal.y == -1 then
		self.grounded = true
		self.collision = true
	end
end

function Player:isCollision()
	print(self.collision)
	return self.collision
end
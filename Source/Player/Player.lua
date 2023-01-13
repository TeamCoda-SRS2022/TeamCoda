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
	local idle = gfx.imagetable.new("Player/Animations/PlayerIdle")
	self.curAnim = gfx.animation.loop.new(250, idle, true)
	Player.super.init(self, x, y, self.curAnim:image())

	print(gravity)
	self.jumpVelocity = math.sqrt(2 * gravity * jumpHeight)
	self.isFacingLeft = playdate.graphics.kImageUnflipped
	self.grounded = false
	
end

function Player:update()
	Player.super.update(self)

	self:setImage(self.curAnim:image())
	self:setImageFlip(self.isFacingLeft)

	if pd.buttonIsPressed( pd.kButtonUp ) and self.grounded then
		self.velocity.y = -self.jumpVelocity
		self.grounded = false
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		self:move( 2, 0 )
		self.isFacingLeft = playdate.graphics.kImageUnflipped
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		self:move( -2, 0 )
		self.isFacingLeft = playdate.graphics.kImageFlippedX
	end
end

function Player:move(x, y)
	local actualX, actualY, collisions, length = Player.super.move(self, x, y)
	if collisions[1] ~= nil and collisions[1].normal.y == -1 then
		self.grounded = true
	end
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "YLib/Physics/RigidBody2D"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(RigidBody2D)

function Player:init(x, y)
	-- local playerImage = gfx.image.new()
	-- assert( playerImage )
	local idle = gfx.imagetable.new("Player/Animations/PlayerIdle")
	self.curAnim = gfx.animation.loop.new(250, idle, true)

	assert(self.curAnim)

	Player.super.init(self, x, y, idle:getImage(1), true)
	
end

function Player:update()
	Player.super.update(self)

	self.curAnim:draw(self.x, self.y)

	if pd.buttonIsPressed( pd.kButtonUp ) then
		self.velocity.y = -2
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		-- self:move( 2, 0 )
		self:setImageFlip(playdate.graphics.kImageUnflipped)
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		-- self:move( -2, 0 )
		self:setImageFlip(playdate.graphics.kImageFlippedX)
	end
end
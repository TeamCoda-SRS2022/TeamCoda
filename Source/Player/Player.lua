
import "YLib/Physics/RigidBody2D"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Player').extends(RigidBody2D)

function Player:init(x, y)
	Player.super.init(self, "Player/Player.png", x, y)
end

function Player:update()
	Player.super.update(self)

	if pd.buttonIsPressed( pd.kButtonUp ) then
		self.velocity.y = -2
	end
	if pd.buttonIsPressed( pd.kButtonRight ) then
		self:move( 2, 0 )
		self:setImageFlip(playdate.graphics.kImageUnflipped)
	end
	if pd.buttonIsPressed( pd.kButtonLeft ) then
		self:move( -2, 0 )
		self:setImageFlip(playdate.graphics.kImageFlippedX)
	end
end
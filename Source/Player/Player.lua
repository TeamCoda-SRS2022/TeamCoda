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

	self:setZIndex(1)

	self.speed = 2
	self.jumpVelocity = math.sqrt(2 * gravity * jumpHeight)
	self.isFacingLeft = playdate.graphics.kImageUnflipped
	self.grounded = false

	self:setGroups(3) -- player group
	self:setCollidesWithGroups({1, 2}) -- only collide with rigid bodies and interactable bodies
	self.showInteractableIcon = false

	local interactableIcon = gfx.image.new("UI/Images/exclamation.png")
	self.interactableSprite = gfx.sprite.new(interactableIcon)
	self.interactableSprite:moveTo(x, y)
	self.interactableSprite:setVisible(false)
	self.interactableSprite:setZIndex(100)
	
	self.walkingSFX = pd.sound.sampleplayer.new("Assets/SFX/basicwalking")
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
	if (pd.buttonIsPressed(pd.kButtonRight) or pd.buttonIsPressed(pd.kButtonLeft)) and not self.walkingSFX:isPlaying() and self.grounded then
		self.walkingSFX:play()
	end
	if (pd.buttonJustReleased(pd.kButtonRight) or pd.buttonJustReleased(pd.kButtonLeft) or not self.grounded) and self.walkingSFX:isPlaying() then
		self.walkingSFX:stop()
	end
	
	if self.showInteractableIcon then
		if not self.interactableSprite:isVisible() then
			self.interactableSprite:setVisible(true)
		end
		self.interactableSprite:moveTo(self.x, self.y - 25)
	else
		if self.interactableSprite:isVisible() then
			self.interactableSprite:setVisible(false)
		end
	end

end


function Player:collisionResponse(other)
	if other:getGroupMask() == 2 then -- interactable group
		return "overlap"
	end
	return "freeze"
end

function Player:move(x, y)
	self.showInteractableIcon = false
	local actualX, actualY, collisions, length = Player.super.move(self, x, y)
	for i, collision in ipairs(collisions) do
		if collision.other:getGroupMask() == 2 then  -- interactable group
			-- display icon
			self.showInteractableIcon = true
		elseif collision.normal.y == -1 then
			self.grounded = true
		end
	end
end

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"
import "YLib/Physics/RigidBody2D"


local pd <const> = playdate
local gfx <const> = pd.graphics


class('Miniboss').extends(RigidBody2D)


function Miniboss:init(x, y)
	local idle = gfx.imagetable.new("Miniboss/Animations/Standing/MinibossStanding")

  self.curAnim = gfx.animation.loop.new(375, idle, true)
	Miniboss.super.init(self, x, y, self.curAnim:image())

	self:setZIndex(1)


	self.isFacingLeft = playdate.graphics.kImageFlippedX
  self:setImageFlip(self.isFacingLeft)
  

	self:setGroups(1) -- rigidbody group
	self:setCollidesWithGroups({1, 3})  -- collide with rigidbody, player


end

function Miniboss:attack()
  --self.curAnim = gfx.animation.loop.new(250, gfx.imagetable.new("Miniboss/Animations/Attacking/MinibossAttacking"), true)
  self.curAnim:setImageTable(gfx.imagetable.new("Miniboss/Animations/Attacking/MinibossAttacking"))
end

function Miniboss:idle()
  --self.curAnim = gfx.animation.loop.new(500, gfx.imagetable.new("Miniboss/Animations/Standing/MinibossStanding"), true)
  self.curAnim:setImageTable(gfx.imagetable.new("Miniboss/Animations/Standing/MinibossStanding"))
end

function Miniboss:update()
	Miniboss.super.update(self)

	self:setImage(self.curAnim:image())
	self:setImageFlip(self.isFacingLeft)
	
end


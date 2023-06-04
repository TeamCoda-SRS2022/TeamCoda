import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('InteractableBody').extends(gfx.sprite)

function InteractableBody:init(x, y, sprite, player, threshold_distance)
	InteractableBody.super.init(self)

	if sprite ~= nil then
		self:setImage(sprite)
	end
	
	self:moveTo(x, y)

	self.nearby = false
	
	self:setCollideRect( 0, 0, sprite:getSize() )

	self:setGroups(2) -- interactable group
	self:setCollidesWithGroups(3) -- only collide with player

	self.player = player
	self.threshold_distance = threshold_distance
	
	self.callbacks = {}
	function self.callbacks:push(callbackF)
		table.insert(self, callbackF)
	end
	function self.callbacks:pop()
		table.remove(self)
	end

	local myInputHandlers = {
		upButtonDown = function () 
			self:handleInput()
		end
	}
	--pd.inputHandlers.push(myInputHandlers)
end

function InteractableBody:update()
	self.nearby = pd.geometry.distanceToPoint(self.x, self.y, self.player.x, self.player.y) < self.threshold_distance
end

function InteractableBody:handleInput()
	local sprites = self:overlappingSprites()
	if #sprites > 0 then  -- player collision
		for _, i in ipairs(self.callbacks) do i() end
	end

end

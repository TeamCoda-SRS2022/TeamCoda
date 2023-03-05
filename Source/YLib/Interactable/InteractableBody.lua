import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry

class('InteractableBody').extends(gfx.sprite)

function InteractableBody:init(x, y, sprite, button, player, threshold_distance)
	InteractableBody.super.init(self)

	self:setImage(sprite)
	self:moveTo(x, y)

	self.player = player
	self.threshold_distance = threshold_distance
	
	self.callbacks = {}
	function self.callbacks:push(callbackF)
		table.insert(self, callbackF)
	end
	function self.callbacks:pop()
		table.remove(self)
	end



	if (button == "B") then
		local myInputHandlers = {
			BButtonDown = function () 
				self:handleInput()
			end
		}
		pd.inputHandlers.push(myInputHandlers)
	end

	if (button == "A") then
		local myInputHandlers = {
			AButtonDown = function () 
				self:handleInput()
			end
		}
		pd.inputHandlers.push(myInputHandlers)
	end

	if (button == "U") then
		local myInputHandlers = {
			upButtonDown = function () 
				self:handleInput()
			end
		}
		pd.inputHandlers.push(myInputHandlers)
	end

	if (button == "L") then
		local myInputHandlers = {
			leftButtonDown = function () 
				self:handleInput()
			end
		}
		pd.inputHandlers.push(myInputHandlers)
	end

	if (button == "R") then
		local myInputHandlers = {
			leftButtonDown = function () 
				self:handleInput()
			end
		}
		pd.inputHandlers.push(myInputHandlers)
	end
end

function InteractableBody:update()
	--InteractableBody.super.update(self)
end


function InteractableBody:handleInput()
	if (pd.geometry.distanceToPoint(self.x, self.y, self.player.x, self.player.y) < self.threshold_distance) then
		for _, i in ipairs(self.callbacks) do i() end
	end
end

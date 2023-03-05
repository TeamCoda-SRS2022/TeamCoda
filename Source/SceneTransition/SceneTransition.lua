import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/Interactable/InteractableBody"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneTransition').extends(InteractableBody)

function SceneTransition:init(x, y, sprite, player, destinationScene)
    
    SceneTransition.super.init(self, x, y, sprite, player, 50)
    self.locked = true
    self.callbacks:push(
        function() 
            if not self.locked then 
                loadScene(destinationScene)
            end 
        end)
end

function SceneTransitions:toggleLock()
    self.locked = not self.locked
end

function SceneTransitions:updateSprite(sprite)
    self:setImage(sprite)
end
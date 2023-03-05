import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/Interactable/InteractableBody"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('SceneTransition').extends(InteractableBody)

function SceneTransition:init(x, y, sprite, player, destinationScene, isLocked)
    SceneTransition.super.init(self, x, y, sprite, player, 50)
    self.locked = isLocked
    self.callbacks:push(
        function() 
            if not self.locked then 
                loadScene(destinationScene)
            end 
        end)
end

function SceneTransition:toggleLock()
    self.locked = not self.locked
end

function SceneTransition:updateSprite(sprite)
    self:setImage(sprite)
end
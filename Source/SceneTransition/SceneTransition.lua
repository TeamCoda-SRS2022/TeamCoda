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

    self.callbacks:push(function() loadScene(destinationScene) end)
end
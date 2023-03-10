import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

class('Scene').extends(Object)

function Scene:init()
    self.interactables = {}
end

function Scene:load()
    for i=1, #self.sceneObjects,1
    do
        self.sceneObjects[i]:add()
        if self.sceneObjects[i]["handleInput"] ~= nil then
            self.interactables[#self.interactables+1] = self.sceneObjects[i]
        end
    end

    playdate.inputHandlers.push({
        upButtonDown = function()
            for _, interactable in ipairs(self.interactables) do
                interactable:handleInput()
            end    
        end
    })
end

function Scene:add(obj)
    print(self.sceneObjects)
    table.insert(self.sceneObjects, obj)
    obj:add()
end

function Scene:remove(obj)
    obj:remove()
    -- May need to implement a filter function to maintain sceneObjects size
end

function Scene:unload()
    for i=1, #self.sceneObjects,1
    do
        self.sceneObjects[i]:remove()
    end
end

function Scene:update()

end

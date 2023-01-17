import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

class('Scene').extends(Object)

function Scene:init()
    
end

function Scene:load()
    for i=1, #self.sceneObjects,1
    do
        self.sceneObjects[i]:add()
    end
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


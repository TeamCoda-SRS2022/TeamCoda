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

function Scene:unload()
    for i=1, #self.sceneObjects,1
    do
        self.sceneObjects[i]:add()
    end
end

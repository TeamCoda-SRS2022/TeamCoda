import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Player/Charging"

class('ChargingTest').extends(Scene)

function ChargingTest:init()
    ChargingTest.super.init(self)

    self.sceneObjects = {

    }
end

function ChargingTest:load()
    ChargingTest.super.load(self)
    local charging = Charging(144)
    createChargeDisplay();    
end
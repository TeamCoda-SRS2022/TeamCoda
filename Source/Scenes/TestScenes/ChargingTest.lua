import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Player/Charging"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ChargingTest').extends(Scene)

function ChargingTest:init()
    ChargingTest.super.init(self)

    self.chargeBar = Charging(144)

    self.sceneObjects = {
        self.chargeBar
    }
    print("Scene Init")
end

function ChargingTest:load()
    ChargingTest.super.load(self)
    print("loaded")
end
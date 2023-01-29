import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "UI/ChargeBar"

local pd <const> = playdate
local gfx <const> = pd.graphics

-- Based on current UI element, we want something divisible by 8
local MAX_CHARGE <const> = 144 

local DEPLETE_RATE <const> = 100

class('ChargingTest').extends(Scene)

function ChargingTest:init()
    ChargingTest.super.init(self)

    self.chargeBar = ChargeBar(MAX_CHARGE, DEPLETE_RATE)

    self.sceneObjects = {
        self.chargeBar
    }
end

function ChargingTest:load()
    ChargingTest.super.load(self)
end
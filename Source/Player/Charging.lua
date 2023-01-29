import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

local chargeSprite
local charge = 0

class ('Charging').extends(gfx.sprite)

function Charging:init(maxCharge)
    
    self.maxChargeLevel = maxCharge
    local myInputHandlers = {
        cranked = function (change)
            self:processCrankTurn(change)
        end
    }
    playdate.inputHandlers.push(myInputHandlers)
    -- createChargeTimer()

    local chargeBarTable = gfx.imagetable.new("UI/Animations/ChargeBar/ChargeBar")

    Charging.super.init(self)
    self:setImage(chargeBarTable[1])

    print("initialized")
end

function Charging:processCrankTurn(change)
    if change < 0 then
        return
    end
    change = math.floor(change / 10)
    print(change)
    if charge + change > self.maxChargeLevel then
        charge = self.maxChargeLevel
    else
        charge += change    
    end
    print(charge)
end

--Placeholder until final UI element design in finished
-- function createChargeDisplay()
--     chargeSprite = gfx.sprite.new()
--     updateChargeDisplay()
--     chargeSprite:setCenter(0, 0)
--     chargeSprite:add()
-- end

-- function updateChargeDisplay()
--     local chargeInfo = "Charge: " .. charge
--     local textWidth, textHeight = gfx.getTextSize(chargeInfo)
--     local chargeImage = gfx.image.new(textWidth, textHeight)
--     gfx.pushContext(chargeImage)
--         gfx.drawText(chargeInfo, 0, 0)
--     gfx.popContext()
--     chargeSprite:setImage(chargeImage)
-- end

function updateChargeDisplay()
    if charge > 0 then
        self:setImage(chargeBarTable[5])
    end
end

-- function decrementCharge()
--     if charge > 0 then
--         charge -= 1
--     end
--     updateChargeDisplay()
--     print("decremented")
-- end

-- function createChargeTimer()
--     playdate.timer.performAfterDelay(1000, function()
--         createChargeTimer()
--         decrementCharge()
--     end)
-- end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

local chargeSprite
local charge = 0

class ('Charging').extends(Object)

function Charging:init(maxCharge, chargeRate)
    Charging.super.init(self)
    self.curChargeLevel = maxCharge / 2
    self.maxChargeLevel = maxCharge
    self.chargeRate = chargeRate
    local myInputHandlers = {
        cranked = function (change)
            self:processCrankTurn(change)
        end
    }
    playdate.inputHandlers.push(myInputHandlers)
end

function Charging:processCrankTurn(change)
    -- if self.curChargeLevel + change > self.maxChargeLevel then
    --     self.curChargeLevel = self.maxChargeLevel
    -- else
    --     self.curChargeLevel += change
    -- end
    print(change)

    charge += change
    updateChargeDisplay()
end

--Placeholder until final UI element design in finished
function createChargeDisplay()
    chargeSprite = gfx.sprite.new()
    updateChargeDisplay()
    chargeSprite:setCenter(0, 0)
    chargeSprite:add()
end

function updateChargeDisplay()
    local chargeInfo = "Charge: " .. charge
    local textWidth, textHeight = gfx.getTextSize(chargeInfo)
    local chargeImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(chargeImage)
        gfx.drawText(chargeInfo, 0, 0)
    gfx.popContext()
    chargeSprite:setImage(chargeImage)
end
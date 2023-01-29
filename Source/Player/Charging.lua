import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = pd.graphics

local chargeSprite
local charge = 0

class ('Charging').extends(Object)

function Charging:init(maxCharge)
    Charging.super.init(self)
    self.maxChargeLevel = maxCharge
    local myInputHandlers = {
        cranked = function (change)
            self:processCrankTurn(change)
        end
    }
    playdate.inputHandlers.push(myInputHandlers)
    createChargeTimer()
end

function Charging:processCrankTurn(change)
    change = math.floor(change / 10)
    print(change)
    if charge + change > self.maxChargeLevel then
        charge = self.maxChargeLevel
    else
        charge += change    
    updateChargeDisplay()
    end
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

function decrementCharge()
    if charge > 0 then
        charge -= 1
    end
    updateChargeDisplay()
    print("decremented")
end

function createChargeTimer()
    playdate.timer.performAfterDelay(1000, function()
        createChargeTimer()
        decrementCharge()
    end)
end
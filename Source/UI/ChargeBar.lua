import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/animation"

local pd <const> = playdate
local gfx <const> = pd.graphics

class ('ChargeBar').extends(gfx.sprite)

function ChargeBar:init(maxCharge, depletionRate)
    self.maxChargeLevel = maxCharge
    self.depletionRate = depletionRate
    self.curCharge = 0
    local myInputHandlers = {
        cranked = function (change)
            self:processCrankTurn(change)
        end
    }
    playdate.inputHandlers.push(myInputHandlers)

    self.chargeBarTable = gfx.imagetable.new("UI/Animations/ChargeBar/ChargeBar")

    ChargeBar.super.init(self)
    self:moveTo(100, 100)
    self:updateChargeBarLevel()
    self.createChargeTimer(self)

end

function ChargeBar:processCrankTurn(change)
    if change < 0 then
        return
    end

    -- keep charge variable as a relatively small integer
    change = math.floor(change / 10)

    if self.curCharge + change > self.maxChargeLevel then
        self.curCharge = self.maxChargeLevel
    else
        self.curCharge += change    
    end
    self.updateChargeBarLevel(self)
end

-- TODO: Optimize the logic
function ChargeBar:updateChargeBarLevel()
    local frac = self.curCharge / self.maxChargeLevel
    if frac > 7/8 then
        self:setImage(self.chargeBarTable[9])
    elseif frac > 6/8 then
        self:setImage(self.chargeBarTable[8])
    elseif frac > 5/8 then
        self:setImage(self.chargeBarTable[7])
    elseif frac > 4/8 then
        self:setImage(self.chargeBarTable[6])
    elseif frac > 3/8 then
        self:setImage(self.chargeBarTable[5])
    elseif frac > 2/8 then
        self:setImage(self.chargeBarTable[4])
    elseif frac > 1/8 then
        self:setImage(self.chargeBarTable[3])
    elseif frac > 0 then
        self:setImage(self.chargeBarTable[2])
    else
        self:setImage(self.chargeBarTable[1])
    end
end

function ChargeBar:decrementCharge()
    if self.curCharge > 0 then
        self.curCharge -= 1
    end
    self.updateChargeBarLevel(self)
    print("Decremented: ".. self.curCharge)
end

function ChargeBar:createChargeTimer()
    playdate.timer.performAfterDelay(self.depletionRate, function()
        self.createChargeTimer(self)
        self.decrementCharge(self)
    end)
end
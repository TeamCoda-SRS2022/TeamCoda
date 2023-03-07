import "CoreLibs/object"
import "CoreLibs/crank"
import "CoreLibs/graphics"
import "CoreLibs/Crank"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "LP/LP"


local pd <const> = playdate
local gfx <const> = pd.graphics

class("Frequency").extends(gfx.sprite)

function Frequency:init(x, y, freq) -- each part of the picture frame is its own object
   Frequency.super.init(self)
   self:moveTo(x, y)
   self:setCollideRect(0, 0, self:getSize())
   self.freq = 0
   self.list = {100, 200, 50, 300}
   self.sta = false
   self:add()
   self.counter = 0
   self.turnOnCrank = false
   
end

function Frequency:update()
    Frequency.super.update(self)
    if self.turnOnCrank == false then
        Frequency:onCrank()
    end
    

end

function Frequency:getFreq()
    return self.freq
end

function Frequency:onCrank()
    local change, acceleratedChange = playdate.getCrankChange()
    local cranky = playdate.getCrankPosition()
    self.freq = cranky
    --print(change, acceleratedChange, cranky)
    if self.freq < 0 and change then 
        self.freq = 1
    end 
    if self.freq > 359 and change then 
        self.freq = 359
    end
    if change < 0 then -- if going ccw
        self.freq = self.freq - 1
    else -- going cw
        self.freq = self.freq + 1
    end
    
    local maxWidth = 10
    local height = 90 -- max height
    
    local healthbarHeight = self.freq + 1
    print (healthbarHeight, self.freq, cranky)
    local healthbarImage = gfx.image.new(maxWidth, (self.freq/4)+1)
    gfx.pushContext(healthbarImage)
        gfx.fillRect(0, 0, maxWidth, healthbarHeight)
    gfx.popContext()
    self:setImage(healthbarImage)
end



    --local on = gfx.image.new("Frame/On.png")
    --local off = gfx.image.new("Frame/Off.png")
    --if status then
    --    self:setImage(off)
    --else 
    --    self:setImage(on)
    --end 
    --self.sta = self.sta
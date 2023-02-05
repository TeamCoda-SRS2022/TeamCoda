import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('RhythmInputUI').extends(Object)

function RhythmInputUI:init(beatLength)
    RhythmInputUI.super.init(self)
    
    self.tempoI = gfx.sprite.new(gfx.image.new("UI/Images/OuterBorder.png"))
    self.tempoI:setImageDrawMode(gfx.kDrawModeNXOR)
    self.tempoI:setCenter(0, 0)
    
    local function flash()
        self.tempoI:add()
        pd.timer.new(100, function() self.tempoI:remove() end)
    end
    self.timer = pd.timer.new(beatLength, beatLength, flash);
    self.timer:stop()
end

function RhythmInputUI:start()
    
end

function RhythmInputUI:update()
    RhythmInputUI.super.update(self)

end
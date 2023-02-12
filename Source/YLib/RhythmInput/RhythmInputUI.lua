import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/frameTimer"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('RhythmInputUI').extends(Object)

function RhythmInputUI:init(beatLength)
    RhythmInputUI.super.init(self)
    
    self.tempoI = gfx.sprite.new(gfx.image.new("UI/Images/OuterBorder.png"))
    self.tempoI:setImageDrawMode(gfx.kDrawModeNXOR)
    self.tempoI:setCenter(0, 0)

    self.right = gfx.sprite.new(gfx.image.new("UI/Images/InnerRightBorder.png"))
    self.right:setImageDrawMode(gfx.kDrawModeNXOR)
    self.right:setCenter(0, 0)

    self.left = gfx.sprite.new(gfx.image.new("UI/Images/InnerLeftBorder.png"))
    self.left:setImageDrawMode(gfx.kDrawModeNXOR)
    self.left:setCenter(0, 0)

    self.up = gfx.sprite.new(gfx.image.new("UI/Images/InnerUpBorder.png"))
    self.up:setImageDrawMode(gfx.kDrawModeNXOR)
    self.up:setCenter(0, 0)

    self.down = gfx.sprite.new(gfx.image.new("UI/Images/InnerBottomBorder.png"))
    self.down:setImageDrawMode(gfx.kDrawModeNXOR)
    self.down:setCenter(0, 0)
    
    self.beatLength = beatLength
    local function flash()
        self.tempoI:add()
        pd.timer.new(100, function() self.tempoI:remove() end)
    end
    self.tempoTimer = pd.frameTimer.new(beatLength, flash)
    self.tempoTimer.repeats = true
    self.tempoTimer:pause()

    self.active = false
end

function RhythmInputUI:start()
    self.tempoTimer:reset()
    self.tempoTimer:start()
    self.tempoI:add()
    pd.timer.new(100, function() self.tempoI:remove() end)

    self.active = true
end

function RhythmInputUI:stop()
    self.tempoTimer:remove()
    self.tempoI:remove()

    self.active = false
end
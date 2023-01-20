import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('RhythmInputTest').extends(Scene)




function RhythmInputTest:processButtonPressA()
    self.isValid = false
    self.prevButtonPress = self.timer._currentTime
    for _, noteTime in ipairs(self.noteTimes) do
        if math.abs(noteTime - self.timer._currentTime) <= self.delay then
            self.isValid = true
        end
    end
    -- check for buttons pressed in previous measure 
    if self.noteTimes[1] + (self.measureLength - self.prevButtonPress) <= self.delay then
        self.isValid = true
    end
end

-- measureLength: length of measure in ms
-- noteTimes: array of note times for the measure, in ms
-- delay: maximum valid input delay in ms
function RhythmInputTest:init(measureLength, noteTimes, delay)
    RhythmInputTest.super.init(self)
    
    self.measureLength = measureLength
    self.noteTimes = noteTimes
    self.delay = delay
    self.isValid = true  -- whether measure is valid, resets every measure
    self.prevButtonPress = measureLength + delay + 1  -- last button press of previous measure (for beat 1)
    local function newMeasure()
        print(self.isValid)
        self.isValid = true
    end
    self.timer = playdate.timer.keyRepeatTimerWithDelay(measureLength, measureLength, newMeasure)
    local myInputHandlers = {
        AButtonDown = function () 
            print(self.timer._currentTime)
            self:processButtonPressA()
        end,
    }
    playdate.inputHandlers.push(myInputHandlers)
    self.sceneObjects = {

    }
end
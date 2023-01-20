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


function RhythmInputTest:userPassed()
    local passed = true
    for _, validNote in ipairs(self.notePressed) do
        if not validNote then
            passed = false
        end
    end
    return passed and self.isValid
end


function RhythmInputTest:processButtonPressA()
    self.isValid = false
    for i, noteTime in ipairs(self.noteTimes) do
        if math.abs(noteTime - self.timer._currentTime) <= self.delay then
            self.isValid = true
            self.notePressed[i] = true
        end
    end
    -- check for buttons pressed in previous measure 
    if self.noteTimes[1] + (self.measureLength - self.prevButtonPress) <= self.delay then
        self.isValid = true
        self.notePressed[1] = true
    end
    self.prevButtonPress = self.timer._currentTime
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
    self.prevButtonPress = -delay  -- last button press of previous measure (for beat 1)
    self.notePressed = {}  -- list of correct note presses
    for i=1, #noteTimes do
        self.notePressed[i] = false
    end
    local function newMeasure()
        print(self:userPassed())
        for i=1, #self.notePressed do
            self.notePressed[i] = false
        end
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
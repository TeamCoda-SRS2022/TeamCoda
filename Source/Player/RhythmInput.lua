import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Platforms/Platform"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('RhythmInput').extends(Object)

function RhythmInput:userPassed()
    local passed = true
    for _, validNote in ipairs(self.notePressed) do
        if not validNote then
            passed = false
        end
    end
    return passed and self.isValid
end

function RhythmInput:processButtonPress()
    self.isValid = false
    for i, note in ipairs(self.notes) do
        if math.abs(note.MSTime - self.timer._currentTime) <= self.delay then
            -- self.isValid = true
            -- self.notePressed[i] = true
            print("test")
        end
    end
end

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: time per beat in ms
function RhythmInput:init(measureLength, notes, tempo)
    RhythmInput.super.init(self)
    
    self.measureLength = measureLength
    self.tempo = tempo
    self.beatLength = 60 / tempo 
    self.measureLengthMS = measureLength * self.beatLength

    self.notes = {}
    for i=1, #notes do
        print(notes[i])
        self.notes[i] = {
            -- button = notes[i].button,
            MSTime = notes[i] * self.beatLength
        }
    end
    
    self.success = false
    self.curNote = 1

    local function newMeasure()
        if self.success == true and self.curNote > #notes then
            self.timer:remove()
            print("win")
        end
        self.curNote = 1
    end
    
    self.timer = playdate.timer.keyRepeatTimerWithDelay(self.measureLengthMS, self.measureLengthMS, newMeasure)

    local myInputHandlers = {
        AButtonDown = function () 
            print(self.timer._currentTime)
            self:processButtonPress()
        end
    }
    playdate.inputHandlers.push(myInputHandlers)
end
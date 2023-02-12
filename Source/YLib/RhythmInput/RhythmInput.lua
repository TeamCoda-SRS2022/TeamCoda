import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "YLib/RhythmInput/RhythmInputUI"

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

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: time per beat in ms
function RhythmInput:init(soundFolderPath, measureLength, notes, tempo)
    RhythmInput.super.init(self)

    self.active = false

    local notes = {}

    for k, v in string.gmatch(notes, "(%w+)=(%w+)") do
        self.notes[#self.notes+1] = {
            BeatNum = (tonumber(k)),
            Button = v
        }
    end
    
    self.success = false
    self.curMeasure = 1
    self.complete = {}
    function self.complete:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.complete:pop()
        table.remove(self)
    end
end

function RhythmInput:start()
    self.active = true
    self.timer:reset()
    self.timer:start()
    self.success = true
        self.curNote = 1
        pd.timer.new(
            0.5 * self.beatLength,
            function()
                self.audio:stop()
                self.audio:play()
                self.UI:start()
            end
        )
end

function RhythmInput:stop()
    self.active = false
    self.timer:pause()
    self.audio:stop()
    self.UI:stop()
end
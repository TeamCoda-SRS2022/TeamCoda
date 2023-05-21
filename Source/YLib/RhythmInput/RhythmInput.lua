import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "YLib/RhythmInput/RhythmInputUI"
import "YLib/RhythmInput/MeasureTracker"

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
-- tempo: BPM
function RhythmInput:init(soundFilePaths, measureLength, notes, tempo)
    RhythmInput.super.init(self)

    self.active = false

    self.notes = {}
    self.measures = {}

    self.success = false
    self.curMeasure = 1

    -- Callbacks
    self.complete = {}
    function self.complete:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.complete:pop()
        table.remove(self)
    end
    self.measureStarted = {}
    function self.measureStarted:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.measureStarted:pop()
        table.remove(self)
    end

    -- Parse Notes
    for k, v in string.gmatch(notes, "(%w+)=(%w+)") do
        self.notes[#self.notes+1] = {
            BeatNum = (tonumber(k)),
            Button = v
        }
    end

    -- Generate Measures
    local genMeasure = 0
    local genMeasureNotes = {}
    for _, note in ipairs(self.notes) do
        while (note.BeatNum - 1) // measureLength ~= genMeasure do
            self.measures[#self.measures+1] = MeasureTracker(soundFilePaths[genMeasure+1], measureLength, genMeasureNotes, tempo)
            self.measures[#self.measures].complete:push(function ()
                self.curMeasure += 1
                self.measures[self.curMeasure]:start()
                for _, i in ipairs(self.measureStarted) do i(self.curMeasure) end
            end)
            genMeasure += 1
            genMeasureNotes = {}
        end
        note.BeatNum -= genMeasure * measureLength
        genMeasureNotes[#genMeasureNotes+1] = note
    end
    self.measures[#self.measures+1] = MeasureTracker(soundFilePaths[genMeasure+1], measureLength, genMeasureNotes, tempo)

    -- Repeat music at end
    local function repeatMusic()
        self.success = true
        for _, measure in ipairs(self.measures) do
            if measure.completed == false then
                self.success = false
            end
        end

        if self.success then
            for _, i in ipairs(self.complete) do i() end
            self:stop()
            return
        else
            for _, measure in ipairs(self.measures) do measure.completed = false end
            self:start()
        end
    end
    self.measures[#self.measures].complete:push(repeatMusic)
end

function RhythmInput:start()
    self.active = true
    self.curMeasure = 1
    self.measures[self.curMeasure]:start()
    for _, i in ipairs(self.measureStarted) do i(self.curMeasure) end
end

function RhythmInput:stop()
    self.active = false
    self.measures[self.curMeasure]:stop()
end
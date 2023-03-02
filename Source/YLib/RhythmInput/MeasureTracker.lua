import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "YLib/RhythmInput/RhythmInputUI"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MeasureTracker').extends(Object)

function MeasureTracker:userPassed()
    local passed = true
    for _, validNote in ipairs(self.notePressed) do
        if not validNote then
            passed = false
        end
    end
    return passed and self.isValid
end

function MeasureTracker:processButtonPress(button)
    if not self.active or self.curNote > #self.notes then
        return
    end

    if math.abs(self.notes[self.curNote].Time - self.audio:getOffset()) <= timeWindowLength and button == self.notes[self.curNote].Button then
        print(self.curNote)
        self.curNote = self.curNote + 1
    else
        self.success = false
        print(self.curNote)
        print(self.notes[self.curNote].Time)
        print(self.notes[self.curNote].Time - self.audio:getOffset())
    end
end

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: BPM
function MeasureTracker:init(soundPath, measureLength, notes, tempo)
    MeasureTracker.super.init(self)

    self.active = false
    
    self.tempo = tempo
    -- These values are in seconds
    self.beatLength = 60.0 / tempo
    self.measureLength = measureLength
    self.measureLengthSeconds = measureLength * self.beatLength

    self.notes = notes
    for _, note in ipairs(self.notes) do
        note.Time = (note.BeatNum - 1) * self.beatLength
    end
    
    self.completed = false
    self.success = false
    self.curNote = 1
    self.complete = {}
    function self.complete:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.complete:pop()
        table.remove(self)
    end

    local function newMeasure()
        self:stop()
        if self.success == true and self.curNote > #self.notes then
            self.completed = true
        end
        for _, i in ipairs(self.complete) do i() end
    end

    self.audio = pd.sound.fileplayer.new(soundPath)
    self.audio:setFinishCallback(newMeasure)
    
    self.UI = RhythmInputUI(self.beatLength)

    self.myInputHandlers = {
        AButtonDown = function () 
            self:processButtonPress("A")
            self.UI.up:add()
            self.UI.down:add()
            self.UI.left:add()
            self.UI.right:add()
        end,
        AButtonUp = function () 
            self.UI.up:remove()
            self.UI.down:remove()
            self.UI.left:remove()
            self.UI.right:remove()
        end,
        downButtonDown = function ()
            self:processButtonPress("D")
            self.UI.down:add()
        end,
        downButtonUp = function ()
            self.UI.down:remove()
        end,
        upButtonDown = function ()
            self:processButtonPress("U")
            self.UI.up:add()
        end,
        upButtonUp = function ()
            self.UI.up:remove()
        end,
        leftButtonDown = function ()
            self:processButtonPress("L")
            self.UI.left:add()
        end,
        leftButtonUp = function ()
            self.UI.left:remove()
        end,
        rightButtonDown = function ()
            self:processButtonPress("R")
            self.UI.right:add()
        end,
        rightButtonUp = function ()
            self.UI.right:remove()
        end
    }
end

function MeasureTracker:start()
    self.active = true
    self.success = true
    self.curNote = 1
    self.audio:play()
    self.UI:start()
    playdate.inputHandlers.push(self.myInputHandlers)
end

function MeasureTracker:stop()
    self.active = false
    self.audio:stop()
    self.UI:stop()
    playdate.inputHandlers.pop()
end
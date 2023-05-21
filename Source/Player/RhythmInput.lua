import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

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

function RhythmInput:processButtonPress(button)
    if not self.active or self.curNote > #self.notes then
        return
    end

    if math.abs(self.notes[self.curNote].MSTime - self.timer._currentTime) <= timeWindowLength and button == self.notes[self.curNote].Button then
        print(self.curNote)
        self.curNote = self.curNote + 1
    else
        self.success = false
    end
end

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: time per beat in ms
function RhythmInput:init(soundPath, measureLength, notes, tempo)
    RhythmInput.super.init(self)

    self.active = false
    
    self.tempo = tempo
    self.beatLength = 60.0 * 1000.0 / tempo 
    self.measureLength = measureLength
    self.measureLengthMS = measureLength * self.beatLength

    self.notes = {}

    for k, v in string.gmatch(notes, "(%w+)=(%w+)") do
        self.notes[#self.notes+1] = {
            MSTime = (tonumber(k) - 0.5) * self.beatLength,
            Button = v
        }
    end

    self.audio = pd.sound.fileplayer.new(soundPath)
    
    self.success = false
    self.curNote = 1
    self.complete = {}
    self.measureEndCallbacks = {}
    function self.complete:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.complete:pop()
        table.remove(self)
    end
    function self.measureEndCallbacks:push(callbackF)
        table.insert(self, callbackF)
    end
    function self.measureEndCallbacks:pop()
        table.remove(self)
    end

    local function newMeasure()
        for _, i in ipairs(self.measureEndCallbacks) do i() end

        if self.success == true and self.curNote > #self.notes then
            self:stop()
            for _, i in ipairs(self.complete) do i() end
        end
        self.success = true
        self.curNote = 1
    end
    
    self.timer = playdate.timer.keyRepeatTimerWithDelay(self.measureLengthMS - 0.5 * self.beatLength, self.measureLengthMS, newMeasure)

    local myInputHandlers = {
        AButtonDown = function () 
            self:processButtonPress("A")
        end,
        downButtonDown = function ()
            self:processButtonPress("D")
        end,
        upButtonDown = function ()
            self:processButtonPress("U")
        end,
        leftButtonDown = function ()
            self:processButtonPress("L")
        end,
        rightButtonDown = function ()
            self:processButtonPress("R")
        end
    }
    playdate.inputHandlers.push(myInputHandlers)

    self.timer:pause()
end

function RhythmInput:start()
    self.active = true
    self.timer:reset()
    self.timer:start()
    self.audio:play(0)
    
end

function RhythmInput:stop()
    self.active = false
    self.timer:pause()
    self.audio:stop()
end

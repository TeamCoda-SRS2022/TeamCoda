import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/frameTimer"
import "UI/RhythmInputUI"

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

    if math.abs(self.notes[self.curNote].FrameTime - self.timer.frame) <= timeWindowLength and button == self.notes[self.curNote].Button then
        print(self.curNote)
        self.curNote = self.curNote + 1
    else
        self.success = false
        print(self.notes[self.curNote].FrameTime - self.timer.frame)
    end
end

-- measureLength: length of measure in quarter notes
-- noteTimes: array of note times for the measure, in quarter ntoes
-- tempo: time per beat in ms
function RhythmInput:init(soundPath, measureLength, notes, tempo)
    RhythmInput.super.init(self)

    self.active = false
    
    self.tempo = tempo
    -- These values are in frames
    self.beatLength = 60.0 * 30.0 / tempo
    self.measureLength = measureLength
    self.measureLengthFrames = measureLength * self.beatLength

    self.notes = {}

    for k, v in string.gmatch(notes, "(%w+)=(%w+)") do
        self.notes[#self.notes+1] = {
            FrameTime = (tonumber(k) - 0.5) * self.beatLength + offset,
            Button = v
        }
    end

    self.audio = pd.sound.fileplayer.new(soundPath)
    
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
        if self.success == true and self.curNote > #self.notes then
            self:stop()
            for _, i in ipairs(self.complete) do i() end
            return
        end
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
    
    self.timer = playdate.frameTimer.new(self.measureLengthFrames, newMeasure)
    self.timer.repeats = true
    
    self.UI = RhythmInputUI(self.beatLength)

    local myInputHandlers = {
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
    playdate.inputHandlers.push(myInputHandlers)

    self.timer:pause()
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
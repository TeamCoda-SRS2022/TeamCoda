import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Frame/Button"
import "Frame/Frequency"
import "CoreLibs/Crank"
import "Player/RhythmInput"
import "LP/LP"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MichTest').extends(Scene)

function MichTest:init()
    MichTest.super.init(self)
    
    self.valid = true
    
    self.sfreq = {30, 70, 60, 50}
    self.freq1 = Frequency(30, 100, 90)
    self.freq2 = Frequency(100, 100, 90)
    self.freq3 = Frequency(170, 100, 90)
    self.freq4 = Frequency(240, 100, 90)
    self.i = 1

    self.synth = playdate.sound.synth.new(playdate.sound.kWaveSine)
    self.chordInstrument = playdate.sound.instrument.new()
    self.chordInstrument:addVoice(self.synth)
    chordInstrument:playMIDINote(48) 
      
    self.player = Player(10, 200)
    self.freq = {30, 70, 40, 50}
    valid = true
    counter = 0

    

    self.sceneObjects = { -- set pieces of picture frame in different areas of the house
        self.freq1, 
        self.freq2, 
        self.freq3, 
        self.freq4, 
        self.player
    }
    

end

function MichTest:load()
    MichTest.super.load(self)

    print (self.i)

    local backgroundImage = gfx.image.new("Scenes/Backgrounds/black.png")
    assert( backgroundImage )
    gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
  local counter = 0
  print (self.freq1:getFreq())
end 

function MichTest:update()
  MichTest.super.update(self)

  
  -- if self.i < 5 then 
  --   if (sfreq[self.i] == self.sceneObjects[self.i]:getFreq()) then 
  --     self:remove(self.sceneObjects[self.i])
  --     chordInstrument:noteOff(48)
  --     self.i = self.i + 1
  --   end
  -- end

  -- if self.i == 5 then
  --   print("Puzzle complete")

  -- end

end

function MichTest:add(obj)
  table.insert(self.sceneObjects, obj)
  obj:add()
  self.valid = false
end

function MichTest:remove(obj)
  obj:remove()
end
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
    local button = gfx.image.new("Frame/Off.png")

    

    local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
    self.freq1 = Frequency(30, 100, 90)
    self.freq2 = Frequency(100, 100, 90)
    self.freq3 = Frequency(170, 100, 90)
    self.freq4 = Frequency(240, 100, 90)

      
    self.player = Player(10, 200)
    self.freq = {30, 70, 40, 50}

    self.sceneObjects = { -- set pieces of picture frame in different areas of the house
        self.player, 
        self.freq1
    }

end

function MichTest:load()
    MichTest.super.load(self)

    local backgroundImage = gfx.image.new("Scenes/Backgrounds/black.png")
    assert( backgroundImage )
    gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
  local counter = 0


end 

function MichTest:update()
    MichTest.super.update(self)
    local i = 0
    local counter = 0
    for i in self.freq do 
      if self.freq[i] == self.freq1:getFreq() then
        counter = 1
      end
    end
    
end

function MichTest:add(obj)
  table.insert(self.sceneObjects, obj)
  obj:add()
end

function MichTest:remove(obj)
  obj:remove()
end
  
  



  

    


     -- for puzzle, only press either A or B button, for now let's just say A and B are needed to beat the puzzle
    -- when coda interacts with each part of the broken picture frame, 
    


         -- solve the puzzle for that particular part of the frame, solve it four times total
    -- if the user presses the right buttons at the right times, then puzzle is complete and picture frame is automatically moved 
       -- move the frame auto, for now let's move all pieces to the same spot
    -- local pickUp = true
    -- can't pick up another piece until coda sets it down 
    --  frame:moveTo(Player:update())
    -- puzzle.complete:push("Coda put the frame back together!")

  --  for _, frame in ipairs(self.sceneObjects) do
    --    pressButton(beats[0], beats[1], beats[2])
    --    frame:moveTo(0, 0)
  --  end

--end




 -- idea > inside the house, there is a broken picture frame. coda decides to put it together. picture frame responds to the music from coda. gotta put together the picture frame in certain order? 
 -- collect something?
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Frame/Frame"
import "Frame/Framey"

import "Player/RhythmInput"
import "LP/LP"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MichTest').extends(Scene)

function MichTest:init()
    MichTest.super.init(self)
    
   local on = gfx.image.new("Frame/On.png")
   local off = gfx.image.new("Frame/Off.png")

    local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
      
    self.player = Player(10, 200)

    self.sceneObjects = { -- set pieces of picture frame in different areas of the house
        self.player,
        Framey(55, 50, on),
        Framey(225, 50, off)
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
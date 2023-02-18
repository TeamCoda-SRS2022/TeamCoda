import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Frame/Frame"
import "Player/RhythmInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('MichTest').extends(Scene)

function MichTest:init()
    MichTest.super.init(self)
    
    local imageA = gfx.image.new("Buttons/AButton.png")
    local imageB = gfx.image.new("Buttons/BButton.png")
    local pictopleft = gfx.image.new("Frame/frame1.png")
    local picbottomleft = gfx.image.new("Frame/frame2.png")
    local pictopright = gfx.image.new("Frame/frame3.png")
    local picbottomright = gfx.image.new("Frame/frame4.png")

    self.Player = Player(50, 50)

    self.sceneObjects = { -- set pieces of picture frame in different areas of the house
        self.Player, 
        Frame(20, 350, pictopleft), 
        Frame(300, 200, picbottomleft),
        Frame(260, 100, pictopright),
        Frame(100, 30, picbottomright)
    }

end

function MichTest:load()
    MichTest.super.load(self)
    local backgroundImage = gfx.image.new("Scenes/Backgrounds/black.png")

    local beats = "1=A, 2=B" -- for puzzle, only press either A or B button, for now let's just say A and B are needed to beat the puzzle
    for _, frame in ipairs(self.sceneObjects) do -- when coda interacts with each part of the broken picture frame, 
        local puzzle = RhythmInput("Sound/100BPM.mp3", 4, beats, 100) -- solve the puzzle for that particular part of the frame, solve it four times total
    -- if the user presses the right buttons at the right times, then puzzle is complete and picture frame is automatically moved 
        frame:moveTo(100, 100) -- move the frame auto, for now let's move all pieces to the same spot
    -- local pickUp = true
    -- can't pick up another piece until coda sets it down 
    --  frame:moveTo(Player:update())
    end
    -- puzzle.complete:push("Coda put the frame back together!")
end
    
  --  for _, frame in ipairs(self.sceneObjects) do
    --    pressButton(beats[0], beats[1], beats[2])
    --    frame:moveTo(0, 0)
  --  end

--end

--[[
function MichTest:pressButton(note1, note2, note3)
    local stateButtons = false
    while stateButtons == false do -- if user doesn't correctly press buttons, then keep going
        if pd.buttonIsPressed(pd.note1) then 
            if pd.buttonIsPressed(pd.note2) then
                if pd.buttonIsPressed(pd.note3) then 
                    stateButtons = true
                -- if user presses buttons in the correct order, then they passed yay
                end
            end
        end
    end

end
--]]



 -- idea > inside the house, there is a broken picture frame. coda decides to put it together. picture frame responds to the music from coda. gotta put together the picture frame in certain order? 
 -- collect something?
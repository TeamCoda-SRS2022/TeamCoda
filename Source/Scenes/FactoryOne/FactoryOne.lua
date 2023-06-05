import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Player/RhythmInput"
import "Platforms/Platform"
import "Scenes/FactoryOne/Chute/Chute"
import "Scenes/FactoryOne/Deadbot/Deadbot"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FactoryOne').extends(Scene)

function FactoryOne:init()
    FactoryOne.super.init(self)
    self.offsetx = 0

    local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
    local floorSprite = gfx.image.new( "Assets/floor.png")
    local chuteSprite = gfx.image.new( "Chute/Chute.png" )
    self.deadbotSprite = gfx.image.new( "Deadbot/Deadbot.png" )

    self.player = Player(100, 100)

    self.beats = {false, false, false, false}
    for i=1, 4 do
        -- 50% chance to have a dead robot on a certain chute.
        -- if (math.random() < 0.5) then
        --     self.beats[i] = true
        -- end
        self.beats[i] = true
    end

    self.sceneObjects = {
        -- Chute(260, 120, chuteSprite),
        -- Chute(300, 120, chuteSprite),
        -- Chute(340, 120, chuteSprite),
        -- Chute(480, 120, chuteSprite),
        Platform(305, 210, floorSprite),
    }

    for i=1, 4 do
        if (self.beats[i] == true) then
            table.insert(self.sceneObjects, Deadbot(415 + 37*(i-1), self.deadbotSprite))
        end
    end


    table.insert(self.sceneObjects, self.player)
end

function FactoryOne:load()
    print("Loading the scene")
    FactoryOne.super.load(self)

    local bg = gfx.sprite.new(gfx.image.new( "Scenes/FactoryOne/LightsOff.png" ))
    assert( bg )
    bg:setCenter(0, 0)
    bg:moveTo(0, 32)
    self:add(bg)
    bg:setZIndex(-2)


    local rhythmSolnString = ""
    for i=1, 4 do
        if self.beats[i] then
            rhythmSolnString = rhythmSolnString..(tostring(i).."=U, ")
        end
    end
    print(rhythmSolnString)

    local puzzle = RhythmInput("Test/TunePocket-Metronome-120-Bpm-Loop-Preview", 4, rhythmSolnString, 120)
    puzzle.complete:push(function() print("Puzzle Solved") end)


    function resetDeadbots()
        for _, obj in ipairs(self.sceneObjects) do
            if obj.reset_dead_bot ~= null then
                obj:reset_dead_bot()
            end
        end
    end

    puzzle.measureEndCallbacks:push(resetDeadbots)
    puzzle:start()

    -- gfx.sprite.setBackgroundDrawingCallback(
    --     function( x, y, width, height )
    --         backgroundImage:draw( 0, 0 )
    --     end
    -- )
end

function FactoryOne:update()
    FactoryOne.super.update(self)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -274) then self.offsetx = -274 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end

-- function FactoryOne:resetDeadbots()
--     print("Resetting dead bots")
--     print(self.sceneObjects)

--     -- for i =1, self.sceneObjects.getn() do
--     --     print(i)
--     -- end
-- end
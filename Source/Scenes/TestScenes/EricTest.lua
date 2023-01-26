import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Player/Player"
import "Player/RhythmInput"
import "Platforms/Platform"
import "Chute/Chute"
import "Deadbot/Deadbot"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('EricTest').extends(Scene)

function EricTest:init()
    EricTest.super.init(self)

    local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )
    local chuteSprite = gfx.image.new( "Chute/Chute.png" )
    self.deadbotSprite = gfx.image.new( "Deadbot/Deadbot.png" )

    self.player = Player(100, 100)

    self.beats = {false, false, false, false}
    for i=1, 4 do
        -- 50% chance to have a dead robot on a certain chute.
        if (math.random() < 0.5) then
            self.beats[i] = true
        end
    end

    self.sceneObjects = {
        Chute(260, 120, chuteSprite),
        Chute(300, 120, chuteSprite),
        Chute(340, 120, chuteSprite),
        Chute(380, 120, chuteSprite),
        Platform(36, 200, platformSprite),
        Platform(100, 200, platformSprite),
        Platform(164, 200, platformSprite),
        Platform(228, 200, platformSprite),
        Platform(250, 200, platformSprite),
        Platform(300, 200, platformSprite),
    }

    for i=1, 4 do
        if (self.beats[i] == true) then
            table.insert(self.sceneObjects, Deadbot(260 + 40*(i-1), self.deadbotSprite))
        end
    end


    table.insert(self.sceneObjects, self.player)
end

function EricTest:load()
    print("Loading the scene")
    EricTest.super.load(self)

    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
    assert( backgroundImage )


    local rhythmSolnString = ""
    for i=1, 4 do
        if self.beats[i] then
            rhythmSolnString = rhythmSolnString..(tostring(i).."=U, ")
        end
    end

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

    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
            backgroundImage:draw( 0, 0 )
        end
    )
end

-- function EricTest:resetDeadbots()
--     print("Resetting dead bots")
--     print(self.sceneObjects)

--     -- for i =1, self.sceneObjects.getn() do
--     --     print(i)
--     -- end
-- end
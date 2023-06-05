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

    local floorSprite = gfx.image.new( "Assets/floor.png")
    local wallSprite = gfx.image.new( "Scenes/FactoryOne/wall.png")
    local coverSprite1 = gfx.image.new( "Scenes/FactoryOne/cover1.png")
    self.deadbotSprite = gfx.image.new( "Scenes/FactoryOne/Deadbot/Deadbot.png" )

    self.player = Player(100, 100)

    self.beats = {false, false, false, false}
    for i=1, 4 do
        --50% chance to have a dead robot on a certain chute.
        if (math.random() < 0.5) then
            self.beats[i] = true
        end
    end

    local sum = 0
    for i=1, 4 do
        if not self.beats[i] then
            sum += 1
        end
    end
    if sum == 4 then
        for i=1, 4 do
            self.beats[i] = true
        end
    end

    self.sceneObjects = {
        Platform(305, 210, floorSprite),
        Platform(470, 23, coverSprite1),
        Platform(470, 234, coverSprite1),
        Platform(665, 170, wallSprite)
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

    self.puzzle = RhythmInput("Test/TunePocket-Metronome-120-Bpm-Loop-Preview", 4, rhythmSolnString, 120)
    self.puzzle.complete:push(function() 
        print("Puzzle Solved")
         self.completed = true
    end)


    function resetDeadbots()
        for _, obj in ipairs(self.sceneObjects) do
            if obj.reset_dead_bot ~= null then
                obj:reset_dead_bot()
            end
        end
    end

    self.puzzle.measureEndCallbacks:push(resetDeadbots)
    self.puzzle:start()

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

    if self.completed == true then
        local bg = gfx.sprite.new(gfx.image.new( "Scenes/FactoryOne/LightsOn.png" ))
        assert( bg )
        bg:setCenter(0, 0)
        bg:moveTo(0, 32)
        self:add(bg)
        bg:setZIndex(-2)
    end
end

-- function FactoryOne:resetDeadbots()
--     print("Resetting dead bots")
--     print(self.sceneObjects)

--     -- for i =1, self.sceneObjects.getn() do
--     --     print(i)
--     -- end
-- end
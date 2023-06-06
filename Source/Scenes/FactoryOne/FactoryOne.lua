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
    local chuteSprite = gfx.image.new( "Scenes/FactoryOne/Chute/Chute.png" )
    local coverSprite1 = gfx.image.new( "Scenes/FactoryOne/cover1.png")
    self.deadbotSprite = gfx.image.new( "Scenes/FactoryOne/Deadbot/Deadbot.png" )

    self.player = Player(100, 200)

    self.beats = {false, false, false, false}
    math.randomseed(playdate.getSecondsSinceEpoch())
    for i=1, 4 do
        --50% chance to have a dead robot on a certain chute.
        if (math.random() < 0.5) then
            self.beats[i] = true
        else 
            self.beats[i] = false
        end
        
    end

    local doorSprite = gfx.image.new( "SceneTransition/door.png" )  
    self.door = SceneTransition(41, 185, doorSprite, self.player, 15, true, 80)

    self.sceneObjects = {
        PlatformNoSprite(0, 207, 640, 7),
        PlatformNoSprite(-7, 0, 7, 240),
        PlatformNoSprite(640, 0, 7, 240),
        self.door,
    }

    for i=1, 4 do
        if (self.beats[i] == true) then
            table.insert(self.sceneObjects, Deadbot(415 + 37*(i-1), self.deadbotSprite))
        end
    end


    table.insert(self.sceneObjects, self.player)
    table.insert(self.sceneObjects, self.player.interactableSprite)
end

function FactoryOne:load()
    print("Loading the scene")
    FactoryOne.super.load(self)

    self.bg = gfx.sprite.new(gfx.image.new( "Scenes/FactoryOne/LightsOff.png" ))
    assert( self.bg )
    self.bg:setCenter(0, 0)
    self.bg:moveTo(0, 32)
    self:add(self.bg)
    self.bg:setZIndex(-2)

    gfx.setBackgroundColor(playdate.graphics.kColorBlack)

    self.completedSFX = pd.sound.sampleplayer.new("Assets/SFX/sparkle")

    local rhythmSolnString = ""
    for i=1, 4 do
        if self.beats[i] then
            rhythmSolnString = rhythmSolnString..(tostring(i).."=U, ")
        end
    end
    print(rhythmSolnString)

    local puzzle = RhythmInput("Test/TunePocket-Metronome-120-Bpm-Loop-Preview", 4, rhythmSolnString, 120)
    puzzle.complete:push(
        function() 
            self.door.locked = false 
            self.completedSFX:play()
            self.bg:setImage(gfx.image.new("Scenes/FactoryOne/LightsOn.png"))
        end
    )


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
    gfx.fillRect(0, 210, 640, 33)
    gfx.fillRect(0, 0, 640, 32)
    self.offsetx = - (self.player.x - 200)
    if(self.offsetx > 0) then self.offsetx = 0 end
    if(self.offsetx < -274) then self.offsetx = -274 end
    playdate.graphics.setDrawOffset(self.offsetx, 0)
end

function FactoryOne:resetDeadbots()
    print("Resetting dead bots")
    print(self.sceneObjects)

    -- for i =1, self.sceneObjects.getn() do
    --     print(i)
    -- end
end
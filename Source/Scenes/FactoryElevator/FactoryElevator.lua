import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "Platforms/PlatformNoSprite"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FactoryElevator').extends(Scene)

function FactoryElevator:init(destinationScene)
    local TIMER_DURATION = 5000
    FactoryElevator.super.init(self)

    self.player = Player(200, 110)
    self.destination = destinationScene

    self.floor = PlatformNoSprite(142, 162, 112, 7)
    self.leftwall = PlatformNoSprite(145, 65, 5, 105)
    self.rightwall = PlatformNoSprite(250, 65, 5, 105)

    self.ambience = pd.sound.fileplayer.new("Assets/SFX/elevatorloop")
    self.ambience:setLoopRange(0, 1.4)

    self.doorOpen = pd.sound.sampleplayer.new("Assets/SFX/elevatoropen")
    self.doorOpen:setFinishCallback(
        function ()
            loadScene(self.destination)
        end
    )

    self.timer = playdate.timer.new(TIMER_DURATION, 
        function ()
            self.ambience:stop()
            self.doorOpen:play(1)
        end
    )
    self.timer:pause()

    self.doorClose = pd.sound.sampleplayer.new("Assets/SFX/elevatorclose")
    self.doorClose:setFinishCallback(
        function ()
            self.timer:start() 
            self.ambience:play(0)
        end
    )

    
    self.sceneObjects = {
        self.player,
        self.floor,
        self.leftwall,
        self.rightwall,
        self.door
    }

    
end

function FactoryElevator:load()
    FactoryElevator.super.load(self)
    self.doorClose:play(1)
    
    local bgImage = gfx.image.new("Scenes/FactoryElevator/elevator.png")
    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
        bgImage:drawCentered( 200, 120 )
        end
    )
end


function FactoryElevator:unload()
    FactoryElevator.super.unload(self)
    self.ambience:stop()
end
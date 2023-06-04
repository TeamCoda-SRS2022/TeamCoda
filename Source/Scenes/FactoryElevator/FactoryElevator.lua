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

    self.sceneObjects = {
        self.player,
        self.floor,
        self.leftwall,
        self.rightwall,
        self.door
    }

    self.timer = playdate.timer.new(TIMER_DURATION)
    self.timer:pause()
end

function FactoryElevator:load()
    FactoryElevator.super.load(self)
    self.timer:start() 
    local bgImage = gfx.image.new("Scenes/FactoryElevator/elevator.png")
    gfx.sprite.setBackgroundDrawingCallback(
        function( x, y, width, height )
        bgImage:drawCentered( 200, 120 )
        end
    )
end

function FactoryElevator:update()
    if self.timer.timeLeft == 0 then
        loadScene(self.destination)
    end
end
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/SceneManagement/Scene"
import "YLib/Interactable/InteractableBody"
import "Player/Player"
import "Platforms/Platform"
import "Player/RhythmInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('YunTest').extends(Scene)

function YunTest:init()
    YunTest.super.init(self)

	local platformSprite = gfx.image.new( "Platforms/PlatedPlatform.png" )

    self.player = Player(100, 100)

    self.interactable = InteractableBody(250, 50, platformSprite, "B", self.player, 50)
    self.interactable.callbacks:push(function() print("Woo") end)

    self.sceneObjects = {
        self.player,
        self.interactable,
        Platform(100, 200, platformSprite),
        Platform(150, 200, platformSprite),
        Platform(200, 200, platformSprite),
        Platform(250, 200, platformSprite),
    }
end

function YunTest:load()
    YunTest.super.load(self)

    local puzzle = RhythmInput("Test/TunePocket-Metronome-120-Bpm-Loop-Preview", 4, "1=U, 2=D, 3=L, 4=R", 120)
    puzzle.complete:push(function() print("Woo") end)
    puzzle:start()
    
    local backgroundImage = gfx.image.new( "Scenes/Backgrounds/black.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( 0, 0 )
		end
	)
end
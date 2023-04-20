import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "YLib/Interactable/InteractableBody"
import "Player/Player"
import "YLib/RhythmInput/BattleInput"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BossBattle').extends(Scene)



function BossBattle:init()
  BossBattle.super.init(self)

  --self.player = Player(110, 200)

  self.sceneObjects = {
    --self.player,
    --Platform(200, 224, gfx.image.new("Scenes/HouseOne/background.png")),
  }


end

function BossBattle:load()
  BossBattle.super.load(self)

  self.battle = BattleInput("Test/BossBattleTest",
  "4=0, 5=1, 6=2, 7=3, 8=2, 9=1, 10=0", 120)
  --self.battle.complete.push()
  self.battle:start()

  local backgroundImage = gfx.image.new( "Scenes/Backgrounds/factoryTemplate2.png" )
	assert( backgroundImage )

	gfx.sprite.setBackgroundDrawingCallback(
		function( x, y, width, height )
			backgroundImage:draw( -100, 0 )
		end
	)

end

function BossBattle:unload()
  BossBattle.super.unload(self)
end

function BossBattle:update()
  self.battle:update()
  BossBattle.super.update(self)
end


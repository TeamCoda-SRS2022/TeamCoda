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

  local buttonSprite = gfx.image.new( "Assets/button.png" )

  self.player = Player(110, 200)
  self.conveyorButton = InteractableBody(150, 200, buttonSprite, self.player, 50)


  self.sceneObjects = {
    self.player,
    Platform(200, 224, gfx.image.new("Scenes/HouseOne/background.png")),
    self.conveyorButton,
  }


end

function BossBattle:load()
  BossBattle.super.load(self)

  local chartString = ""
  local chartPattern = {0, 1, 2, 3, 2, 1, 0, 2, 3, -1, -1, 1, 2, 0, -1, 1, 0, 2, -1, 0, 0, 0}
  for i,v in pairs(chartPattern) do
    if v ~= -1 then
      local pattern = (i + 3) .. "=" .. v .. ","
      chartString = chartString .. pattern
    end
  end

  print(chartString)
  self.battle = BattleInput("Test/BossBattleTest", chartString, 120)
  --self.battle.complete.push()

  self.conveyorButton.callbacks:push(
    function() 
      self.battle:start()
    end
    )
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
  pd.drawFPS(10, 10)
end


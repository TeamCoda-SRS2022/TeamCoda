import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "Player/Player"
import "Player/RhythmInput"
import "LP/LP"


local pd <const> = playdate
local gfx <const> = pd.graphics

class("Framey").extends(gfx.sprite)

function Framey:init(x, y, image) -- each part of the picture frame is its own object
   Frame.super.init(self)
   self:setImage(image)
   self:moveTo(x, y)
   self:setCollideRect(0, 0, self:getSize())
   local on = gfx.image.new("Frame/On.png")
   local off = gfx.image.new("Frame/Off.png")
end

function Framey:load()
    Framey.super.update(self)
end
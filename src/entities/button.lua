local Class  = require('lib/middleclass')
local Slice9 = require('lib/slice9')

local Entity = require('entities/base')

local Button = Class('Button', Entity)

do
  local inactiveImg = love.graphics.newImage("assets/img/button.png")
  local activeImg   = love.graphics.newImage("assets/img/button_hover.png")

  local cut   = 4
  local bleed = 7

  Button.static.active   = Slice9:new(activeImg, cut, cut, cut, cut, bleed)
  Button.static.inactive = Slice9:new(inactiveImg, cut, cut, cut, cut, bleed)
end

Button.static.cut   = 3
Button.static.bleed = 6

function Button:initialize(text, x, y, w, h, callback)
  self.callback = callback or function() end

  self.text  = text
  local font = love.graphics.getFont()

  w = w or font:getWidth(text) + 48
  h = h or font:getHeight() + 48

  Entity.initialize(self, x, y, w, h)
  self.isActive = false
end

function Button:mousemoved(x, y)
  self.isActive = (x >= self.x and x <= self.x+self.width) and
      (y >= self.y and y <= self.y+self.height)
end

function Button:mousereleased()
  if self.isActive then
    self.callback()
  end
end

function Button:draw()
  local slice = Button.inactive
  if self.isActive and not love.mouse.isDown(1) then
    slice = Button.active
  end
  slice:draw(self.x, self.y, self.width, self.height, 2)

  -- center up the text
  local font = love.graphics.getFont()
  local tx = self.x + ((self.width-font:getWidth(self.text))/2)
  local ty = self.y + ((self.height-font:getHeight())/2)

  love.graphics.print(self.text, tx, ty)
end

return Button

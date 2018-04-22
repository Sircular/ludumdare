-- https://youtube.com/watch?v=1Bix44C1EzY

local Stateful = require('lib/states')

local Button = require('entities/button')

local WinScreen = Stateful.newState()

local text = "You've escaped Puzzle Prizon!"
local bgColor = {.271, .157, .235}
local button

function WinScreen.enter()
  button = Button:new("Back to Menu", 0, 0, nil, nil, function()
    Stateful.pop()
  end)
end

function WinScreen.mousemoved(x, y)
  button:mousemoved(x, y)
end

function WinScreen.mousereleased()
  button:mousereleased()
end

function WinScreen.draw()
  local centerX = love.graphics.getWidth()/2
  local centerY = love.graphics.getHeight()/2

  love.graphics.setColor(unpack(bgColor))
  love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
  love.graphics.setColor(1, 1, 1)

  do
    local font = love.graphics.getFont()
    local tw   = font:getWidth(text)
    local th   = font:getHeight()

    love.graphics.print(text, centerX - (tw/2), centerY - th - 20)
  end

  button.x = centerX - (button.width/2)
  button.y = centerY
  button:draw()
end

return WinScreen

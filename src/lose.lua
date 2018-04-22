local SndMgr   = require('lib/sndmgr')
local Stateful = require('lib/states')

local Button = require('entities/button')

local LoseScreen = Stateful.newState()

local bgColor = {.271, .157, .235}
local button

local function printCentered(text, y)
  local font = love.graphics.getFont()
  local centerX = love.graphics.getWidth()/2
  local tw = font:getWidth(text)
  love.graphics.print(text, centerX - (tw/2), y)
end

function LoseScreen.enter()
  button = Button:new("Back to Menu", 0, 0, nil, nil, function()
    Stateful.pop()
  end)
  SndMgr.playSound("alert")
end

function LoseScreen.mousemoved(x, y)
  button:mousemoved(x, y)
end

function LoseScreen.mousereleased()
  button:mousereleased()
end

function LoseScreen.draw()
  local centerX = love.graphics.getWidth()/2
  local centerY = love.graphics.getHeight()/2

  love.graphics.setColor(unpack(bgColor))
  love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
  love.graphics.setColor(1, 1, 1)

  local th = love.graphics.getFont():getHeight()

  printCentered("You have been captured!", centerY - (th+20)*3)
  printCentered("The guards will feast upon your bones!", centerY - (th+20)*2)
  printCentered("(Metaphorically)", centerY - (th+20)*1)

  button.x = centerX - (button.width/2)
  button.y = centerY + 40
  button:draw()
end

return LoseScreen

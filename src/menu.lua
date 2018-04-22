local Stateful = require('lib/states')
local SndMgr   = require('lib/sndmgr')

local Button = require('entities/button')

local MainMenu = Stateful.newState()

local bgColor, titleImg, buttons

local buttonSpacing = 48

function MainMenu.enter()
  bgColor = {.271, .157, .235}
  titleImg = love.graphics.newImage("assets/img/titlepage.png")
  SndMgr.playMusic(nil)

  buttons = {
    Button:new("Play", 0, 0, nil, nil, function()
      Stateful.push(require('level'), "1")
    end),
    Button:new("Exit", 0, 0, nil, nil, love.event.quit)
  }
end

function MainMenu.resume()
  SndMgr.playMusic(nil)
end

function MainMenu.update(dt)
  SndMgr.update(dt)
end

function MainMenu.mousemoved(x, y)
  for _, b in pairs(buttons) do
    b:mousemoved(x, y)
  end
end

function MainMenu.mousereleased()
  for _, b in pairs(buttons) do
    b:mousereleased()
  end
end

function MainMenu.draw()
  local centerX = love.graphics.getWidth()/2
  local centerY = love.graphics.getHeight()/2

  love.graphics.setColor(unpack(bgColor))
  love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
  love.graphics.setColor(1, 1, 1)

  love.graphics.draw(titleImg, centerX-(titleImg:getWidth()),
      centerY-(titleImg:getHeight()*2), 0, 2, 2)

  -- reposition the buttons
  local currentY = centerY + buttonSpacing
  for _, b in ipairs(buttons) do
    b.x = centerX - (b.width/2)
    b.y = currentY

    currentY = currentY + b.height + buttonSpacing

    b:draw()
  end
  -- playButton:draw()
end

return MainMenu

local Stateful = require('lib/states')

love.graphics.setDefaultFilter("nearest", "nearest")

local font = love.graphics.newFont("assets/fonts/PressStart2P.ttf", 20)
love.graphics.setFont(font)

local menu = require('menu')

function love.load()
  Stateful.push(menu)
end

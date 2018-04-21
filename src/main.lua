local Stateful = require('lib/states')

love.graphics.setDefaultFilter("nearest", "nearest")

local level = require('level')

function love.load()
  Stateful.push(level)
end

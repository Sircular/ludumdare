local Bump   = require('lib/bump')
local Gamera = require('lib/gamera')
local Stateful = require('lib/states')

local Map    = require('map')
local Guard  = require('entities/guard')
-- local Player = require('player')

local Level = Stateful.newState()

local world, m, cam, guards, player

function Level.enter()
  world = Bump.newWorld()
  m = Map:new("maps/test.lua", world)
  cam = Gamera.new(0, 0, 20000, 20000)
  cam:setScale(2)
  cam:setPosition(0, 0)

  guards = {
    Guard(32, 32)
  }
end

function Level.update(dt)
  for _, g in ipairs(guards) do
    g:update(dt)
  end

end

function Level.draw()
  cam:draw(function()
    m:draw()
    for _, g in ipairs(guards) do
      g:draw()
    end
  end)
end

function Level.mousemoved(x, y)
  love.event.push("suspicious", {x, y}, true, 1)
end

function Level.handlers.suspicious(pos, directional, suspicion)
  local event = {
    x           = pos[1],
    y           = pos[2],
    directional = directional,
    suspicion   = suspicion
  }

  for _, g in ipairs(guards) do
    g:reactToEvent(event, world)
  end
end

return Level

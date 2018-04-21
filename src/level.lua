local Bump   = require('lib/bump')
local Gamera = require('lib/gamera')
local Stateful = require('lib/states')

local Map    = require('map')
local Guard  = require('entities/guard')
local Player = require('entities/player')

local Level = Stateful.newState()

local world, map, cam, guards, player

function Level.enter()
  world = Bump.newWorld()
  map   = Map:new("maps/test.lua", world)
  cam   = Gamera.new(0, 0, 20000, 20000)
  cam:setScale(2)
  cam:setPosition(0, 0)

  player = Player:new(128, 64, world, "player")

  guards = {
    Guard(32, 32, world, "guard-1")
  }
end

function Level.update(dt)
  player:update(dt)
  cam:setPosition(player:getCenterPos())
  for _, g in ipairs(guards) do
    g:update(dt)
  end
end

function Level.draw()
  cam:draw(function()
    map:draw()
    for _, g in ipairs(guards) do
      g:draw()
    end
    player:draw()
  end)
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

function Level.handlers.guardAlert()
  Stateful.pop()
end

return Level

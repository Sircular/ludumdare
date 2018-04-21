local Bump   = require('lib/bump')
local Gamera = require('lib/gamera')

local Map = require('map')

local Level = {}

local world, m, cam

function Level.enter()
  world = Bump.newWorld()
  m = Map:new("maps/test.lua", world)
  cam = Gamera.new(0, 0, 20000, 20000)
  cam:setScale(2)
  cam:setPosition(0, 0)
end

function Level.update(dt)
  -- TODO
end

function Level.draw()
  cam:draw(function(l, t, w, h)
    m:draw()
  end)
end

return Level

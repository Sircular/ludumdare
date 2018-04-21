local gamera = require('lib/gamera')
local bump   = require('lib/bump')

love.graphics.setDefaultFilter("nearest", "nearest")

local Map = require('map')
-- local Guard = require('entities/guard')

-- local g = Guard:new(10, 10)
local world = bump.newWorld()
local m = Map:new("maps/test.lua", world)
local cam = gamera.new(0, 0, 20000, 20000)
cam:setScale(2)
cam:setPosition(0, 0)


function love.draw()
  cam:draw(function(l, t, w, h)
    m:draw()
  end)
end

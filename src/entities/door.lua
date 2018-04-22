local Class = require('lib/middleclass')

local Entity = require('entities/base')

local Door = Class('Door', Entity)

Door.static.size = 16
Door.static.closedImg = love.graphics.newImage("assets/img/door_closed.png")
Door.static.openImg = love.graphics.newImage("assets/img/door_open.png")

function Door:initialize(x, y, world)
  Entity.initialize(self, x, y, Door.size, Door.size)
  self.isOpen = false
  self.type = "door"

  -- add the collision box
  self.world  = world
  world:add(self, x, y, Door.size, Door.size)
end

function Door:setOpen(val)
  self.isOpen = val
end

function Door:draw()
  local img = self.isOpen and Door.openImg or Door.closedImg
  love.graphics.draw(img, self.x, self.y)
end

return Door

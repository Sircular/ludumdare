local Class = require('lib/middleclass')

local Entity = Class('Entity')

function Entity:initialize(x, y, width, height)
  self.x      = x or 0
  self.y      = y or 0
  self.width  = width or 0
  self.height = height or 0
end

function Entity:getCornerPos()
  return self.x, self.y
end

function Entity:getCenterPos()
  return self.x + (self.width/2), self.y + (self.height/2)
end

return Entity

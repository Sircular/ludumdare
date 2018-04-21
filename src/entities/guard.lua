local Anim8 = require('lib/anim8')
local Class = require('lib/middleclass')
local Utils = require('utils')

local Entity = require('entities/base')

local Guard = Class('Guard', Entity)

local viewFilter = function(other)
  if other.tileId then
    return "slide"
  else
    return nil
  end
end

function Guard:initialize(x, y, world, name)
  self.pxSize    = 16
  Entity.initialize(self, x, y, self.pxSize, self.pxSize)

  self.direction = "right"
  self.world     = world
  self.name      = name

  world:add(self, x, y, self.pxSize, self.pxSize)

  self.suspicion        = 0
  self.instantSuspicion = 0

  self.seeDist  = 16*12
  self.hearDist = 16*8

  self.moveSpeed = 16*2

  self.calmSpeed = 0.2 -- per second

  self.img = love.graphics.newImage("assets/img/guard.png")
  self:_constructAnimations()
end

function Guard:_constructAnimations()
  -- TODO: make this more flexible
  local grid = Anim8.newGrid(self.pxSize, self.pxSize, self.img:getDimensions())

  self.animations = {
    ["up"]    = Anim8.newAnimation(grid(1, 1), 0.25),
    ["right"] = Anim8.newAnimation(grid(2, 1), 0.25),
    ["down"]  = Anim8.newAnimation(grid(1, 2), 0.25),
    ["left"]  = Anim8.newAnimation(grid(2, 2), 0.25)
  }
end

function Guard:_getCurrentViewVectors()
  local rawVecs = {
    {-1, -1}, {1, -1}, {1, 1}, {-1, 1}
  }
  return ({
    ["up"] = {rawVecs[1], rawVecs[2]},
    ["right"] = {rawVecs[2], rawVecs[3]},
    ["down"] = {rawVecs[3], rawVecs[4]},
    ["left"] = {rawVecs[4], rawVecs[1]},
  })[self.direction]
end

function Guard:_getIdealLookDirection(x, y)
  local dx = x - self.x
  local dy = y - self.y

  if (math.abs(dx) > math.abs(dy)) then
    return dx > 0 and "right" or "left"
  else
    return dy > 0 and "down" or "up"
  end
end

function Guard:draw()
  self.animations[self.direction]:draw(self.img, self.x, self.y)
end

function Guard:update(dt)
  self.suspicion        = math.max(0, self.suspicion - (self.calmSpeed * dt))
  self.suspicion        = self.suspicion + self.instantSuspicion * dt
  self.instantSuspicion = 0

  local moveDist = self.moveSpeed * dt
  local xd = self.direction == "right" and moveDist or
      (self.direction == "left" and -moveDist or 0)
  local yd = self.direction == "up" and moveDist or
      (self.direction == "down" and -moveDist or 0)

  local newX, newY, cols = self.world:move(self, self.x + xd, self.y+yd)
  self.x = newX
  self.y = newY

  if #cols > 0 then
    if self.direction == "right" then self.direction = "left"
    elseif self.direction == "left" then self.direction = "right"
    elseif self.direction == "up" then self.direction = "down" 
    elseif self.direction == "down" then self.direction = "up" end
  end
end

function Guard:reactToEvent(event, world)
  local suspFac
  if event.directional then
    -- it needs to be in our field of view
    local _, len = world:querySegment(self.x, self.y, event.x, event.y, viewFilter)
    if len > 0 then return end

    -- determine if it lies in our field of view
    local cx, cy = self:getCenterPos()
    local dx = event.x-cx
    local dy = event.y-cy.y
    if not Utils.vecBetween({dx, dy}, unpack(self:_getCurrentViewVectors())) then
      return
    end

    local dist = Utils.distance(self.x, self.y, event.x, event.y)
    suspFac    = math.max(0, (self.seeDist-dist)/self.seeDist)
  else
    local dist = Utils.distance(self.x, self.y, event.x, event.y)
    suspFac    = math.max(0, (self.hearDist-dist)/self.hearDist)
  end
  self.instantSuspicion = self.instantSuspicion + (suspFac * event.suspicion)
end

return Guard

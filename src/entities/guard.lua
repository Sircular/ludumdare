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

Guard.static.pxSize         = 16
Guard.static.seeDist        = 16*12
Guard.static.hearDist       = 16*8
Guard.static.moveSpeed      = 16*2
Guard.static.calmSpeed      = 0.2
Guard.static.suspThresh     = 0.6
Guard.static.reassureThresh = 0.4
Guard.static.alertThresh    = 1

Guard.static.img = love.graphics.newImage("assets/img/guard.png")

do
  local grid = Anim8.newGrid(Guard.pxSize, Guard.pxSize, Guard.img:getDimensions())
  Guard.static.animations = {
    moving = {
      up    = Anim8.newAnimation(grid(1, 1), 0.25),
      right = Anim8.newAnimation(grid(2, 1), 0.25),
      down  = Anim8.newAnimation(grid(1, 2), 0.25),
      left  = Anim8.newAnimation(grid(2, 2), 0.25)
    },
    still = {
      up    = Anim8.newAnimation(grid(1, 1), 0.25),
      right = Anim8.newAnimation(grid(2, 1), 0.25),
      down  = Anim8.newAnimation(grid(1, 2), 0.25),
      left  = Anim8.newAnimation(grid(2, 2), 0.25)
    }
  }
end

function Guard:initialize(x, y, world, name)
  Entity.initialize(self, x, y, Guard.pxSize, Guard.pxSize)

  self.direction = "right"
  self.world     = world
  self.name      = name

  world:add(self, x, y, Guard.pxSize, Guard.pxSize)

  self.suspicion        = 0
  self.instantSuspicion = 0

  self.animations = Utils.recursiveClone(Guard.animations)
  for k, v in ipairs(self.animations) do
    print(k, v)
  end
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
  self.animations["moving"][self.direction]:draw(Guard.img, self:getCornerPos())
end

function Guard:update(dt)
  self.suspicion        = math.max(0, self.suspicion - (Guard.calmSpeed * dt))
  self.suspicion        = self.suspicion + self.instantSuspicion * dt
  self.instantSuspicion = 0
  if self.suspicion > Guard.alertThresh then
    love.event.push("guardAlert")
  end

  local moveDist = (Guard.moveSpeed * dt) * (1 - self.suspicion)

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
  self.animations["moving"][self.direction]:update(dt)
end

function Guard:reactToEvent(event)
  local suspFac
  if event.directional then
    -- it needs to be in our field of view
    local _, len = self.world:querySegment(self.x, self.y, event.x, event.y, viewFilter)
    if len > 0 then return end

    -- determine if it lies in our field of view
    local cx, cy = self:getCenterPos()
    local dx = event.x-cx
    local dy = event.y-cy
    if not Utils.vecBetween({dx, dy}, unpack(self:_getCurrentViewVectors())) then
      return
    end

    local dist = Utils.distance(self.x, self.y, event.x, event.y)
    suspFac    = math.max(0, (Guard.seeDist-dist)/Guard.seeDist)
  else
    local dist = Utils.distance(self.x, self.y, event.x, event.y)
    suspFac    = math.max(0, (Guard.hearDist-dist)/Guard.hearDist)
  end
  self.instantSuspicion = self.instantSuspicion + (suspFac * event.suspicion)
end

return Guard

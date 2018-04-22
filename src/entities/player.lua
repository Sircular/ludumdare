local Anim8 = require('lib/anim8')
local Class = require('lib/middleclass')
local Utils = require('utils')

local Entity = require('entities/base')

local Player = Class('Player', Entity)

Player.static.pxSize = 16
Player.static.moveSpeed = 16*4

Player.static.animTime = 0.1

Player.static.img = love.graphics.newImage("assets/img/player.png")

do
  local grid = Anim8.newGrid(Player.pxSize, Player.pxSize, Player.img:getDimensions())
  Player.static.animations = {
    ["moving"] = {
      ["up"]    = Anim8.newAnimation(grid('1-4', 1), Player.animTime),
      ["right"] = Anim8.newAnimation(grid('1-4', 2), Player.animTime),
      ["down"]  = Anim8.newAnimation(grid('1-4', 3), Player.animTime),
      ["left"]  = Anim8.newAnimation(grid('1-4', 4), Player.animTime)
    },
    ["still"] = {
      ["up"]    = Anim8.newAnimation(grid(1, 1), Player.animTime),
      ["right"] = Anim8.newAnimation(grid(1, 2), Player.animTime),
      ["down"]  = Anim8.newAnimation(grid(1, 3), Player.animTime),
      ["left"]  = Anim8.newAnimation(grid(1, 4), Player.animTime)
    }
  }
end

function Player:initialize(x, y, world, name)
  Entity.initialize(self, x, y, Player.pxSize, Player.pxSize)

  self.direction = "right"
  self.world     = world
  self.name      = name

  self.moving = false

  self.world:add(self, x, y, Player.pxSize, Player.pxSize)

  self.animations = Utils.recursiveClone(Player.animations)
end

function Player:update(dt)
  local left, right, up, down
  left  = love.keyboard.isDown("left", "a")
  right = love.keyboard.isDown("right", "d")
  up    = love.keyboard.isDown("up", "w")
  down  = love.keyboard.isDown("down", "s")

  self.moving = left or right or up or down

  local dx = 0
  local dy = 0
  if left then
    self.direction = "left"
    dx = -1
  elseif right then
    self.direction = "right"
    dx = 1
  elseif up then
    self.direction = "up"
    dy = -1
  elseif down then
    self.direction = "down"
    dy = 1
  end

  local goalX = self.x + dx*dt*Player.moveSpeed
  local goalY = self.y + dy*dt*Player.moveSpeed

  -- push a piece if there is one nearby
  local items = self.world:queryRect(goalX, goalY, self.width, self.height)
  for _, test in pairs(items) do
    if test.type == "piece" then
      test.requestMove(self.direction)
    end
  end

  self.x, self.y = self.world:move(self, goalX, goalY)

  self:_getCurrentAnimation():update(dt)

  -- hey look at me! I'm conspicuous
  -- push "suspicious" events
  love.event.push("suspicious", {self:getCenterPos()}, true, 3)
  if self.moving then
    love.event.push("suspicious", {self:getCenterPos()}, false, 1)
  end
end

function Player:_getCurrentAnimation()
  local state = self.moving and "moving" or "still"
  return self.animations[state][self.direction]
end

function Player:draw()
  self:_getCurrentAnimation():draw(Player.img, self:getCornerPos())
end

return Player


local Anim8 = require('lib/anim8')
local Class = require('lib/middleclass')
local Utils = require('utils')

local Entity = require('entities/base')

local Player = Class('Player', Entity)

Player.static.pxSize = 16
Player.static.moveSpeed = 16*4

Player.static.img = love.graphics.newImage("assets/img/player.png")

do
  local grid = Anim8.newGrid(Player.pxSize, Player.pxSize, Player.img:getDimensions())
  Player.static.animations = {
    ["moving"] = {
      ["up"]    = Anim8.newAnimation(grid(1, 1), 0.25),
      ["right"] = Anim8.newAnimation(grid(2, 1), 0.25),
      ["down"]  = Anim8.newAnimation(grid(1, 2), 0.25),
      ["left"]  = Anim8.newAnimation(grid(2, 2), 0.25)
    },
    ["still"] = {
      ["up"]    = Anim8.newAnimation(grid(1, 1), 0.25),
      ["right"] = Anim8.newAnimation(grid(2, 1), 0.25),
      ["down"]  = Anim8.newAnimation(grid(1, 2), 0.25),
      ["left"]  = Anim8.newAnimation(grid(2, 2), 0.25)
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

  self.x, self.y = self.world:move(self, self.x + dx*dt*Player.moveSpeed,
        self.y + dy*dt*Player.moveSpeed)

  local state = self.moving and "moving" or "still"

  -- hey look at me! I'm conspicuous
  -- push "suspicious" events
  love.event.push("suspicious", {self:getCenterPos()}, true, 3)
  if self.moving then
    love.event.push("suspicious", {self:getCenterPos()}, false, 1)
  end
end

function Player:draw()
  local state = self.moving and "moving" or "still"
  Player.animations[state][self.direction]:draw(Player.img, self:getCornerPos())
end

return Player


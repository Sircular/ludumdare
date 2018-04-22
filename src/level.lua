local Bump     = require('lib/bump')
local Stateful = require('lib/states')
local SndMgr   = require('lib/sndmgr')

local MapLoader = require('maploader')
local Map       = require('map')
local PS        = require('puzzlesystem')
local Guard     = require('entities/guard')
local Player    = require('entities/player')
local Piece     = require('entities/piece')
local Door      = require('entities/door')

local Level = Stateful.newState()

local maps = {"1", "2", "3", "4", "5"}

local index
local world, map, guards, player, puzzle, pieces, door, canvas

function Level.enter(mapIndex)
  index = mapIndex
  local mapName = maps[mapIndex]
  local mapData = MapLoader.load(mapName)
  world         = Bump.newWorld()
  map           = Map:new(mapData, world)

  puzzle = PS:new(mapData.puzzle.x, mapData.puzzle.y, mapData.puzzle)

  guards = {}
  pieces = {}
  for _, e in pairs(mapData.entities) do
    if e.type == "player" then
      player = Player:new(e.x, e.y, world, "player")
    elseif e.type == "guard" then
      guards[#guards+1] = Guard:new(e.x, e.y, world,
          "guard"..tostring(#guards+1), e.direction)
    elseif e.type == "piece" then
      pieces[#pieces+1] = Piece:new(e.x, e.y, e.id, world)
    elseif e.type == "door" then
      door = Door:new(e.x, e.y, world)
    end
  end

  canvas = love.graphics.newCanvas(map.width * map.tileSize, map.height * map.tileSize)

  SndMgr.playMusic("theme")
end

function Level.update(dt)
  player:update(dt)
  for _, g in ipairs(guards) do
    g:update(dt)
  end

  SndMgr.update(dt)
end

function Level.draw()
  love.graphics.setCanvas(canvas)
  map:draw()
  puzzle:draw()
  door:draw()
  for _, g in ipairs(guards) do
    g:draw()
  end
  for _, p in pairs(pieces) do
    p:draw()
  end
  player:draw()
  love.graphics.setCanvas()

  local centerX = love.graphics.getWidth()/2
  local centerY = love.graphics.getHeight()/2
  love.graphics.draw(canvas, centerX - canvas:getWidth(),
      centerY-canvas:getHeight(), 0, 2, 2)
end

function Level.handlers.suspicious(pos, directional, suspicion)
  local event = {
    x           = pos[1],
    y           = pos[2],
    directional = directional,
    suspicion   = suspicion,
    time        = love.timer.getTime(),
  }

  for _, g in ipairs(guards) do
    g:reactToEvent(event, world)
  end
end

function Level.handlers.pieceMoved()
  if puzzle:isSolved(pieces) then
    door:setOpen(true)
    SndMgr.playSound("door_open")
  end
end

function Level.handlers.guardAlert()
  Stateful.swap(require('lose'))
end

function Level.handlers.levelComplete()
  if (index == #maps) then
    Stateful.swap(require('win'))
  else
    Stateful.reset(index + 1)
  end
end

return Level

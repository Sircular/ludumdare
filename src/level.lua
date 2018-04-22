local Bump     = require('lib/bump')
local Gamera   = require('lib/gamera')
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

local world, map, cam, guards, player, puzzle, pieces, door

function Level.enter(mapName)
  local mapData = MapLoader.load(mapName)
  world         = Bump.newWorld()
  map           = Map:new(mapData, world)
  cam           = Gamera.new(0, 0, 20000, 20000)
  cam:setScale(2)
  cam:setPosition(0, 0)

  puzzle = PS:new(mapData.puzzle.x, mapData.puzzle.y, mapData.puzzle)

  guards = {}
  pieces = {}
  for _, e in pairs(mapData.entities) do
    if e.type == "player" then
      player = Player:new(e.x, e.y, world, "player")
    elseif e.type == "guard" then
      guards[#guards+1] = Guard:new(e.x, e.y, world,
          "guard"..tostring(#guards+1))
    elseif e.type == "piece" then
      pieces[#pieces+1] = Piece:new(e.x, e.y, e.id, world)
    elseif e.type == "door" then
      door = Door:new(e.x, e.y, world)
    end
  end

  SndMgr.playMusic("theme")
end

function Level.update(dt)
  player:update(dt)
  cam:setPosition(player:getCenterPos())
  for _, g in ipairs(guards) do
    g:update(dt)
  end

  SndMgr.update(dt)
end

function Level.draw()
  cam:draw(function()
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
  end)
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
  Stateful.pop()
end

function Level.handlers.levelComplete()
  Stateful.pop()
end

return Level

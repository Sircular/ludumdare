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

local Level = Stateful.newState()

local world, map, cam, guards, player, puzzle, pieces

function Level.enter()
  local mapData = MapLoader.load("test")
  world         = Bump.newWorld()
  map           = Map:new(mapData, world)
  cam           = Gamera.new(0, 0, 20000, 20000)
  cam:setScale(2)
  cam:setPosition(0, 0)

  -- puzzle = PS:new(128, 128, {
  --   width  = 4,
  --   height = 3,
  --   tiles  = {
  --     0, 1, 1, 0,
  --     1, 1, 0, 1,
  --     0, 1, 1, 1,
  --   }
  -- })

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
    end
  end

  SndMgr.loadMusic("theme", "assets/sound/theme.wav")
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
    Stateful.pop()
  end
end

function Level.handlers.guardAlert()
  Stateful.pop()
end

return Level

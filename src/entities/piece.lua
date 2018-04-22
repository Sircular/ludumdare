local Class = require('lib/middleclass')
local Utils = require('utils')

local Entity = require('entities/base')

local Piece = Class('Piece', Entity)

Piece.static.img = love.graphics.newImage("assets/img/pieces.png")
Piece.static.tileSize = 16

do
  local ts = Piece.tileSize
  Piece.static.quads = Utils.makeTileQuads(ts, ts, Piece.img:getDimensions())
end

Piece.static.subTileSize = 8

Piece.static.pieceMaps = {
  {
    {true, true,},
    {true, true,},
  },

  {
    {true, true,},
    {false, false,},
  },

  {
    {true, false,},
    {true, false,},
  },

  {
    {true, false,},
    {true, true,},
  },

  {
    {false, true,},
    {true, true,},
  },

  {
    {true, true,},
    {false, true,},
  },

  {
    {true, true,},
    {true, false},
  },

}


function Piece:initialize(x, y, id, world)
  Entity.initialize(self, x, y, Piece.tileSize, Piece.tileSize)
  self.id    = id
  self.world = world

  -- initialize world boxes
  self.boxes = {}
  for xi = 0, 1 do
    for yi = 0, 1 do
      if Piece.pieceMaps[id][yi+1][xi+1] then
        self.boxes[#self.boxes+1] = {
          type        = "piece",
          xoff        = xi * Piece.subTileSize,
          yoff        = yi * Piece.subTileSize,
          parent      = self,
          requestMove = function(dir)
            return self:tryMove(dir)
          end,
        }
      end
    end
  end

  for _, b in pairs(self.boxes) do
    self.world:add(b, self.x+b.xoff, self.y+b.yoff,
        Piece.subTileSize, Piece.subTileSize)
  end
end

function Piece:tryMove(direction)
  local dirs = {
    up    = {0, -1},
    right = {1, 0},
    down  = {0, 1},
    left  = {-1, 0}
  }
  local xoff, yoff = unpack(dirs[direction])
  xoff = xoff * Piece.subTileSize
  yoff = yoff * Piece.subTileSize
  local success = true

  for _, b in pairs(self.boxes) do
    local goalX = self.x + b.xoff + xoff
    local goalY = self.y + b.yoff + yoff
    -- we want to ignore collisions with ourself, since we will be resolving
    -- those later when everything gets moved around
    local _, _, _, count = self.world:check(b, goalX, goalY,
    function(_, other)
      if other.type == "piece" and other.parent == self then
        return nil
      else
        return "cross"
      end
    end)

    if count > 0 then
      success = false
      break
    end
  end

  if success then
    self.x = self.x + xoff
    self.y = self.y + yoff
    for _, b in pairs(self.boxes) do
      local goalX = self.x + b.xoff
      local goalY = self.y + b.yoff
      self.world:update(b, goalX, goalY)
    end
    love.event.push("pieceMoved")
  end

  return success
end

function Piece:getMap()
  return Piece.pieceMaps[self.id]
end

function Piece:draw()
  love.graphics.draw(Piece.img, Piece.quads[self.id], self.x, self.y)
end

return Piece

local Class = require('lib/middleclass')

local Map = Class('Map')

-- includes a bump world that requires entities
function Map:initialize(path, world)
  local data = dofile(path)

  -- in tiles
  self.width    = data.width
  self.height   = data.height
  self.tileSize = data.tileSize -- in pixels
  self.tiles    = {}


  local tileImg = love.graphics.newImage(data.tileSet)
  -- construct quads
  local quads = {}
  local ts = self.tileSize
  for y = 0, math.floor(tileImg:getHeight()/ts)-1 do
    for x = 0, math.floor(tileImg:getWidth()/ts)-1 do
      quads[#quads+1] = love.graphics.newQuad(x*ts, y*ts, ts, ts, tileImg:getDimensions())
    end
  end

  self.tileBatch = love.graphics.newSpriteBatch(tileImg, 2048)

  -- world borders
  world:add({name="border-left"}, -1, 0, 1, self.height*self.tileSize)
  world:add({name="border-right"}, self.width*self.tileSize, 0, 1, self.height*self.tileSize)
  world:add({name="border-top"}, 0, -1, self.width*self.tileSize, 1)
  world:add({name="border-bottom"}, 0, self.height*self.tileSize, self.width*self.tileSize, 1)

  for i = 1, #data.tiles do
    local x = (i-1)%self.width
    local y = ((i-1)-x)/self.width
    if data.tiles[i] and data.tiles[i] > 0 then
      local t = {tileId = data.tiles[i], x = x, y = y}
      self.tiles[#self.tiles+1] = t
      world:add(t, x*ts, y*ts, ts, ts)
    end
    if quads[data.tiles[i]+1] then
      self.tileBatch:add(quads[data.tiles[i]+1], x*ts, y*ts)
    end
  end

end

function Map:draw()
  love.graphics.draw(self.tileBatch)
end

return Map

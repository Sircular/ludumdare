local Class = require('lib/middleclass')

local PS = Class('PuzzleSystem')

PS.static.img = love.graphics.newImage("assets/img/shadow.png")
PS.static.tileSize = PS.img:getWidth()

function PS:initialize(x, y, data)
  self.x = x
  self.y = y

  self.width  = data.width
  self.height = data.height

  self.map = {}

  local row = {}
  for i = 1, #data.tiles do
    row[#row+1] = data.tiles[i] > 0
    if #row >= self.width then
      self.map[#self.map+1] = row
      row = {}
    end
  end
  if #row > 0 then
    self.map[#self.map+1] = row
  end

  self.drawBatch = love.graphics.newSpriteBatch(PS.img)

  for yi = 1, #self.map do
    for xi = 1, #self.map[yi] do
      if self.map[yi][xi] then
        self.drawBatch:add((xi-1)*PS.tileSize, (yi-1)*PS.tileSize)
      end
    end
  end
end

function PS:isSolved(pieces)
  local testMap = {}
  for y = 1, #self.map do
    local row = {}
    for _ = 1, #self.map[y] do
      row[#row+1] = false
    end
    testMap[#testMap+1] = row
  end

  -- get offsets from the top-left corner and round down
  -- if it's stupid but it works, it ain't stupid
  for _, p in pairs(pieces) do
    local xoff = math.floor((p.x-self.x)/PS.tileSize)
    local yoff = math.floor((p.y-self.y)/PS.tileSize)

    local pmap = p:getMap()
    for y = 1, #pmap do
      local y2 = y + yoff
      for x = 1, #pmap[y] do
        local x2 = x + xoff
        if y2 >= 1 and y2 <= #testMap and
          x2 >= 1 and x2 <= #testMap[y2] then
          -- make sure that we don't overwrite a true value
          testMap[y2][x2] = pmap[y][x] or testMap[y2][x2]
        end
      end
    end
  end

  for y = 1, #testMap do
    for x = 1, #testMap[y] do
      if testMap[y][x] ~= self.map[y][x] then
        return false
      end
    end
  end

  return true
end

function PS:draw()
  love.graphics.draw(self.drawBatch, self.x, self.y)
end

return PS

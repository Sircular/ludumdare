local Utils = {}

function Utils.distance(x1, y1, x2, y2)
  local xd = x2-x1
  local yd = y2-y1
  return math.sqrt((xd*xd) + (yd*yd))
end

function Utils.vecBetween(vec, c1, c2)
  local p1 = Utils.cross2d(c1, vec)
  local p2 = Utils.cross2d(c2, vec)
  return p1 > 0 and p2 < 0
end

function Utils.cross2d(u, v)
  return (u[1]*v[2]) - (u[2]*v[1])
end

function Utils.recursiveClone(t)
  local newT = {}
  for k, v in pairs(t) do
    local newV
    if v.clone then
      newV = v:clone()
    elseif type(v) == "table" then
      newV = Utils.recursiveClone(v)
    end
    newT[k] = newV
  end
  return newT
end

return Utils

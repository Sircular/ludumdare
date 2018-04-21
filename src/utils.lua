local Utils = {}

function Utils.distance(x1, y1, x2, y2)
  local xd = x2-x1
  local yd = y2-y1
  return math.sqrt((xd*xd) + (yd*yd))
end

function Utils.vecBetween(vec, c1, c2)
  local p1 = Utils.cross2d(vec, c1)
  local p2 = Utils.cross2d(vec, c2)
  return Utils.sign(p1) == Utils.sign(p2)
end

function Utils.cross2d(u, v)
  return (u[1]*v[2]) - (u[2]*v[1])
end

function Utils.sign(x)
  return x == 0 and 0 or (x > 0 and 1 or -1)
end

return Utils

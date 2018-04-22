local MapLoader = {}

local formatStr = "maps/%s.lua"

function MapLoader.load(name)
  local path = string.format(formatStr, name)
  return dofile(path)
end

return MapLoader

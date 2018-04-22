local MapLoader = {}

local formatStr = "maps/%s"

function MapLoader.load(name)
  local path = string.format(formatStr, name)
  return require(path)
end

return MapLoader

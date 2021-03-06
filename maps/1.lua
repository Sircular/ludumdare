return {
  width = 11,
  height = 11,
  tileSize = 16,
  tileSet = "assets/img/basic_tiles.png",
  tiles = {
    8, 8, 8, 8, 8, 0, 8, 8, 8, 8, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 8, 8, 8, 8, 0, 8, 8, 8, 8, 8,
  },
  puzzle = {
    x = 80,
    y = 80,
    width = 2,
    height = 2,
    tiles = {
      1, 1,
      1, 1
    }
  },
  entities = {
    {
      type = "player",
      x    = 84,
      y    = 144
    },
    {
      type = "piece",
      x    = 80,
      y    = 112,
      id   = 1
    },
    {
      type = "door",
      x    = 80,
      y    = 0
    }
  }
}

return {
  width = 11,
  height = 11,
  tileSize = 16,
  tileSet = "assets/img/basic_tiles.png",
  tiles = {
    8, 8, 2, 8, 8, 0, 8, 8, 2, 8, 8,
    8, 0, 6, 0, 0, 0, 0, 0, 6, 0, 8,
    8, 0, 6, 0, 0, 0, 0, 0, 6, 0, 8,
    8, 0, 6, 0, 0, 0, 0, 0, 6, 0, 8,
    8, 0, 4, 0, 0, 0, 0, 0, 4, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8,
    8, 0, 2, 0, 0, 0, 0, 0, 2, 0, 8,
    8, 0, 6, 0, 0, 0, 0, 0, 6, 0, 8,
    8, 0, 6, 0, 0, 0, 0, 0, 6, 0, 8,
    8, 8, 4, 8, 8, 0, 8, 8, 4, 8, 8,
  },
  puzzle = {
    x = 80,
    y = 80,
    width = 2,
    height = 1,
    tiles = {
      1, 1,
    }
  },
  entities = {
    {
      type = "player",
      x    = 52,
      y    = 144
    },
    {
      type = "piece",
      x    = 80,
      y    = 112,
      id   = 2
    },
    {
      type = "door",
      x    = 80,
      y    = 0
    },
    {
      type = "guard",
      x = 16,
      y = 16,
      direction = "down"
    },
    {
      type = "guard",
      x = 144,
      y = 144,
      direction = "up"
    }
  }
}

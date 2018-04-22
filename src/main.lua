local Stateful = require('lib/states')
local SndMgr   = require('lib/sndmgr')


function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  local font = love.graphics.newFont("assets/fonts/PressStart2P.ttf", 20)
  love.graphics.setFont(font)

  SndMgr.loadSound("door_open", "assets/sound/door_open.wav")
  SndMgr.loadSound("alert", "assets/sound/alarm.wav")
  SndMgr.loadSound("block_push", "assets/sound/block_push.wav")
  SndMgr.loadMusic("theme",     "assets/sound/theme.wav")

  SndMgr.musicVolume = 0.7

  local menu = require('menu')
  Stateful.push(menu)
end

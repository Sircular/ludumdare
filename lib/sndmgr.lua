local Tweens = require('lib/tweens')

local SoundManager = {
  loadedSounds = {},
  loadedMusic  = {},

  currentTrack = nil,
  nextTrack    = nil,

  fadeDuration = 2, -- in seconds
  fading       = true,

  effectVolume = 1,
  musicVolume  = 1,
  masterVolume = 1,

  tweens = Tweens:new(),
}

function SoundManager.loadSound(name, path)
  local snd = love.audio.newSource(path, "static")
  SoundManager.loadedSounds[name] = snd
end

function SoundManager.loadMusic(name, path)
  local snd = love.audio.newSource(path, "stream")
  snd:setLooping(true)
  SoundManager.loadedMusic[name] = snd
end

function SoundManager.playSound(name, volume, x, y)
  volume = volume or 1
  volume = volume * SoundManager.effectVolume * SoundManager.masterVolume
  -- we won't use x and y for now
  -- that's for positional audio
  if (SoundManager.loadedSounds[name]) then
    local snd = SoundManager.loadedSounds[name]:clone()
    -- TODO: implement positional audio
    snd:setRelative(true)
    snd:setVolume(volume)
    snd:play()
  end
end

function SoundManager.playMusic(name)
  SoundManager.nextTrack = SoundManager.loadedMusic[name]
  SoundManager.fading = true
  -- start the track
  if SoundManager.nextTrack then
    SoundManager.nextTrack:setVolume(0)
    SoundManager.nextTrack:play()
  end
  -- set up a tween callback
  SoundManager.tweens:addTween(0, 1, SoundManager.fadeDuration,
  function(t)
    local volFac = SoundManager.masterVolume * SoundManager.musicVolume
    if SoundManager.nextTrack then
      SoundManager.nextTrack:setVolume(t*volFac)
    end
    if SoundManager.currentTrack then
      SoundManager.currentTrack:setVolume((1-t)*volFac)
    end
  end,
  "linear",
  function()
    SoundManager.currentTrack = SoundManager.nextTrack
    SoundManager.nextTrack    = nil
    SoundManager.fading       = false
  end)

end



return SoundManager

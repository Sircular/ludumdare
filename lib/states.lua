-- Simple state switching library
-- Will probably add the MIT license at some point

local Stateful = {
  _stateStack = {},
  exitOnEmpty = false,
}

Stateful.push = function(state)
  local st = Stateful._stateStack

  if st[#st] then st[#st].pause() end
  st[#st+1] = state
  if st[#st] then st[#st].enter() end
  Stateful._bootstrap(st[#st])
end

Stateful.pop = function()
  local st = Stateful._stateStack

  if st[#st] then st[#st].exit() end
  st[#st] = nil
  if st[#st] then st[#st].resume() end
  Stateful._bootstrap(st[#st])
end

Stateful._bootstrap = function(state)
  -- hacky way of getting these methods into love
  setmetatable(love, {__index = state})
  setmetatable(love, {__index = (state and state.handlers or nil)})
end

return Stateful

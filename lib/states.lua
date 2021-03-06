-- Simple state switching library
-- Will probably add the MIT license at some point

local Stateful = {
  _stateStack = {},
  exitOnEmpty = true,
}

Stateful.push = function(state, ...)
  local st = Stateful._stateStack

  if st[#st] then st[#st].pause(...) end
  st[#st+1] = state
  if st[#st] then st[#st].enter(...) end
  Stateful._bootstrap(st[#st])
end

Stateful.swap = function(state, ...)
  local st = Stateful._stateStack
  if st[#st] then st[#st].exit(...) end
  st[#st] = state
  if state then st[#st].enter(...) end
  Stateful._bootstrap(state)
end

Stateful.pop = function(...)
  local st      = Stateful._stateStack
  local current = st[#st]

  if st[#st] then st[#st].exit(...) end
  st[#st] = nil
  if #st == 0 and Stateful.exitOnEmpty then
    love.event.quit()
  end
  if st[#st] then st[#st].resume(...) end
  Stateful._bootstrap(st[#st])

  return current
end

Stateful.reset = function(...)
  local st = Stateful._stateStack
  if st[#st] then st[#st].enter(...) end
end

-- utility for extra bookkeeping stuff
Stateful.newState = function()
  local empty = function() end
  local state = {
    enter    = empty,
    exit     = empty,
    pause    = empty,
    resume   = empty,
    handlers = {}
  }
  setmetatable(state.handlers, {__index = function() return function() end end})
  return state
end

Stateful._bootstrap = function(state)
  -- hacky way of getting these methods into love
  setmetatable(love, {__index = state})
  setmetatable(love.handlers, {__index = (state and state.handlers or nil)})
end

return Stateful

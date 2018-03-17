buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([%-%d]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
function pathfind_aux (cache, tab, len, pos)
  if pos >= len - 1 then
      return 0
  elseif cache[pos + 1] ~= -1 then
      return cache[pos + 1]
  else 
      cache[pos + 1] = len * 2
      local posval = pathfind_aux(cache, tab, len, tab[pos + 1])
      local oneval = pathfind_aux(cache, tab, len, pos + 1)
      local out0 = 0
      if posval < oneval then
          out0 = 1 + posval
      else 
          out0 = 1 + oneval
      end
      cache[pos + 1] = out0
      return out0
  end
end

function pathfind (tab, len)
  local cache = {}
  for i = 0, len - 1 do
      cache[i + 1] = -1
  end
  return pathfind_aux(cache, tab, len, 0)
end

local len = 0
len = readint()
stdinsep()
local tab = {}
for i = 0, len - 1 do
    local tmp = 0
    tmp = readint()
    stdinsep()
    tab[i + 1] = tmp
end
local result = pathfind(tab, len)
io.write(result)

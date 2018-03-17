buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([%-%d]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end
function readchar()
    if buffer == "" then buffer = io.read("*line") end
    local c = string.byte(buffer)
    buffer = string.sub(buffer, 2, -1)
    return c
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
function pathfind_aux (cache, tab, x, y, posX, posY)
  if posX == x - 1 and posY == y - 1 then
      return 0
  elseif posX < 0 or posY < 0 or posX >= x or posY >= y then
      return x * y * 10
  elseif tab[posY + 1][posX + 1] == 35 then
      return x * y * 10
  elseif cache[posY + 1][posX + 1] ~= -1 then
      return cache[posY + 1][posX + 1]
  else 
      cache[posY + 1][posX + 1] = x * y * 10
      local val1 = pathfind_aux(cache, tab, x, y, posX + 1, posY)
      local val2 = pathfind_aux(cache, tab, x, y, posX - 1, posY)
      local val3 = pathfind_aux(cache, tab, x, y, posX, posY - 1)
      local val4 = pathfind_aux(cache, tab, x, y, posX, posY + 1)
      local out0 = 1 + math.min(val1, val2, val3, val4)
      cache[posY + 1][posX + 1] = out0
      return out0
  end
end

function pathfind (tab, x, y)
  local cache = {}
  for i = 0, y - 1 do
      local tmp = {}
      for j = 0, x - 1 do
          tmp[j + 1] = -1
      end
      cache[i + 1] = tmp
  end
  return pathfind_aux(cache, tab, x, y, 0, 0)
end

local x = readint()
stdinsep()
local y = readint()
stdinsep()
local tab = {}
for i = 0, y - 1 do
    local tab2 = {}
    for j = 0, x - 1 do
        local tmp = 0
        tmp = readchar()
        tab2[j + 1] = tmp
    end
    stdinsep()
    tab[i + 1] = tab2
end
local result = pathfind(tab, x, y)
io.write(result)

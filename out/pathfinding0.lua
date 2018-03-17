
function readcharline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), ".") do
    table.insert(tab, string.byte(a))
  end
  return tab
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
          io.write(string.format("%c", tab[i + 1][j + 1]))
          tmp[j + 1] = -1
      end
      io.write("\n")
      cache[i + 1] = tmp
  end
  return pathfind_aux(cache, tab, x, y, 0, 0)
end

local x = tonumber(io.read('*l'))
local y = tonumber(io.read('*l'))
io.write(string.format("%d %d\n", x, y))
local e = {}
for f = 0, y - 1 do
    e[f + 1] = readcharline()
end
local tab = e
local result = pathfind(tab, x, y)
io.write(result)

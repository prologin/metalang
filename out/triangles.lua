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
--[[ Ce code a été généré par metalang
   Il gère les entrées sorties pour un programme dynamique classique
   dans les épreuves de prologin
on le retrouve ici : http://projecteuler.net/problem=18
--]]

function find0 (len, tab, cache, x, y)
  --[[
	Cette fonction est récursive
	--]]
  if y == len - 1 then
      return tab[y + 1][x + 1]
  elseif x > y then
      return -10000
  elseif cache[y + 1][x + 1] ~= 0 then
      return cache[y + 1][x + 1]
  end
  local result = 0
  local out0 = find0(len, tab, cache, x, y + 1)
  local out1 = find0(len, tab, cache, x + 1, y + 1)
  if out0 > out1 then
      result = out0 + tab[y + 1][x + 1]
  else 
      result = out1 + tab[y + 1][x + 1]
  end
  cache[y + 1][x + 1] = result
  return result
end

function find (len, tab)
  local tab2 = {}
  for i = 0, len - 1 do
      local tab3 = {}
      for j = 0, i do
          tab3[j + 1] = 0
      end
      tab2[i + 1] = tab3
  end
  return find0(len, tab, tab2, 0, 0)
end

local len = readint()
stdinsep()
local tab = {}
for i = 0, len - 1 do
    local tab2 = {}
    for j = 0, i do
        local tmp = readint()
        stdinsep()
        tab2[j + 1] = tmp
    end
    tab[i + 1] = tab2
end
io.write(string.format("%d\n", find(len, tab)))
for k = 0, len - 1 do
    for l = 0, k do
        io.write(string.format("%d ", tab[k + 1][l + 1]))
    end
    io.write("\n")
end

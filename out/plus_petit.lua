
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
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
function go0 (tab, a, b)
  local m = trunc((a + b) / 2)
  if a == m then
      if tab[a + 1] == m then
          return b
      else 
          return a
      end
  end
  local i = a
  local j = b
  while i < j do
      local e = tab[i + 1]
      if e < m then
          i = i + 1
      else 
          j = j - 1
          tab[i + 1] = tab[j + 1]
          tab[j + 1] = e
      end
  end
  if i < m then
      return go0(tab, a, m)
  else 
      return go0(tab, m, b)
  end
end

function plus_petit0 (tab, len)
  return go0(tab, 0, len)
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
io.write(plus_petit0(tab, len))

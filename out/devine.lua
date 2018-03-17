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
function devine0 (nombre, tab, len)
  local min0 = tab[1]
  local max0 = tab[2]
  for i = 2, len - 1 do
      if tab[i + 1] > max0 or tab[i + 1] < min0 then
          return false
      end
      if tab[i + 1] < nombre then
          min0 = tab[i + 1]
      end
      if tab[i + 1] > nombre then
          max0 = tab[i + 1]
      end
      if tab[i + 1] == nombre and len ~= i + 1 then
          return false
      end
  end
  return true
end

local nombre = readint()
stdinsep()
local len = readint()
stdinsep()
local tab = {}
for i = 0, len - 1 do
    local tmp = readint()
    stdinsep()
    tab[i + 1] = tmp
end
if devine0(nombre, tab, len) then
    io.write("True")
else 
    io.write("False")
end

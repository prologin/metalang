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
function nth (tab, tofind, len)
  local out0 = 0
  for i = 0, len - 1 do
      if tab[i + 1] == tofind then
          out0 = out0 + 1
      end
  end
  return out0
end

local len = 0
len = readint()
stdinsep()
local tofind = 0
tofind = readchar()
stdinsep()
local tab = {}
for i = 0, len - 1 do
    local tmp = 0
    tmp = readchar()
    tab[i + 1] = tmp
end
local result = nth(tab, tofind, len)
io.write(result)

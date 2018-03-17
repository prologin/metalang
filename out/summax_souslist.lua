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
function summax (lst, len)
  local current = 0
  local max0 = 0
  for i = 0, len - 1 do
      current = current + lst[i + 1]
      if current < 0 then
          current = 0
      end
      if max0 < current then
          max0 = current
      end
  end
  return max0
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
local result = summax(tab, len)
io.write(result)

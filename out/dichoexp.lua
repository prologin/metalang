
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
function exp0 (a, b)
  if b == 0 then
      return 1
  end
  if math.fmod(b, 2) == 0 then
      local o = exp0(a, trunc(b / 2))
      return o * o
  else 
      return a * exp0(a, b - 1)
  end
end

local a = 0
local b = 0
a = readint()
stdinsep()
b = readint()
io.write(exp0(a, b))

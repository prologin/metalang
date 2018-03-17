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
function score ()
  stdinsep()
  local len = readint()
  stdinsep()
  local sum = 0
  for i = 1, len do
      local c = readchar()
      sum = sum + c - 65 + 1
      --[[		print c print " " print sum print " " --]]
  end
  return sum
end

local sum = 0
local n = readint()
for i = 1, n do
    sum = sum + i * score()
end
io.write(string.format("%d\n", sum))

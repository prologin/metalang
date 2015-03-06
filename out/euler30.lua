

function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end

buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([\-0-9]*)(.*)')
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



--[[
a + b * 10 + c * 100 + d * 1000 + e * 10 000 =
  a ^ 5 +
  b ^ 5 +
  c ^ 5 +
  d ^ 5 +
  e ^ 5
--]]
local p = {}
for i = 0,10 - 1 do
p[i] = i * i * i * i * i;
  end
  local sum = 0
  for a = 0,9 do
  for b = 0,9 do
  for c = 0,9 do
  for d = 0,9 do
  for e = 0,9 do
  for f = 0,9 do
  local s = p[a] + p[b] + p[c] + p[d] + p[e] + p[f]
    local r = a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000
    if s == r and r ~= 1
    then
      io.write(string.format("%d%d%d%d%d%d %d\n", f, e, d, c, b, a, r))
      sum = sum + r;
    end
    end
    end
    end
    end
    end
    end
    io.write(sum)
    
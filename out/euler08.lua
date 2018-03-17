
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
buffer =  ""
function readchar()
    if buffer == "" then buffer = io.read("*line") end
    local c = string.byte(buffer)
    buffer = string.sub(buffer, 2, -1)
    return c
end

local i = 1
local last = {}
for j = 0, 4 do
    local c = readchar()
    local d = c - 48
    i = i * d
    last[j + 1] = d
end
local max0 = i
local index = 0
local nskipdiv = 0
for k = 1, 995 do
    local e = readchar()
    local f = e - 48
    if f == 0 then
        i = 1
        nskipdiv = 4
    else 
        i = i * f
        if nskipdiv < 0 then
            i = trunc(i / last[index + 1])
        end
        nskipdiv = nskipdiv - 1
    end
    last[index + 1] = f
    index = math.fmod(index + 1, 5)
    max0 = math.max(max0, i)
end
io.write(string.format("%d\n", max0))

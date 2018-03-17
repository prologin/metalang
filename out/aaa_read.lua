
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
Ce test permet de vérifier si les différents backends pour les langages implémentent bien
read int, read char et skip
--]]

local len = readint()
stdinsep()
io.write(string.format("%d=len\n", len))
len = len * 2
io.write(string.format("len*2=%d\n", len))
len = trunc(len / 2)
local tab = {}
for i = 0, len - 1 do
    local tmpi1 = readint()
    stdinsep()
    io.write(string.format("%d=>%d ", i, tmpi1))
    tab[i + 1] = tmpi1
end
io.write("\n")
local tab2 = {}
for i_ = 0, len - 1 do
    local tmpi2 = readint()
    stdinsep()
    io.write(string.format("%d==>%d ", i_, tmpi2))
    tab2[i_ + 1] = tmpi2
end
local strlen = readint()
stdinsep()
io.write(string.format("%d=strlen\n", strlen))
local tab4 = {}
for toto = 0, strlen - 1 do
    local tmpc = readchar()
    local c = tmpc
    io.write(string.format("%c:%d ", tmpc, c))
    if tmpc ~= 32 then
        c = math.fmod(c - 97 + 13, 26) + 97
    end
    tab4[toto + 1] = c
end
for j = 0, strlen - 1 do
    io.write(string.format("%c", tab4[j + 1]))
end

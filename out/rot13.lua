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
Ce test effectue un rot13 sur une chaine lue en entrée
--]]

local strlen = readint()
stdinsep()
local tab4 = {}
for toto = 0, strlen - 1 do
    local tmpc = readchar()
    local c = tmpc
    if tmpc ~= 32 then
        c = math.fmod(c - 97 + 13, 26) + 97
    end
    tab4[toto + 1] = c
end
for j = 0, strlen - 1 do
    io.write(string.format("%c", tab4[j + 1]))
end

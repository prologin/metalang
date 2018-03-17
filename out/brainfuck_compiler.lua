--[[
Ce test permet de tester les macros
C'est un compilateur brainfuck qui lit sur l'entrée standard pendant la compilation
et qui produit les macros metalang correspondante
--]]

local input = 32
local current_pos = 500
local mem = {}
for i = 0, 999 do
    mem[i + 1] = 0
end
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
current_pos = current_pos + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
mem[current_pos + 1] = mem[current_pos + 1] + 1
while mem[current_pos + 1] ~= 0 do
    mem[current_pos + 1] = mem[current_pos + 1] - 1
    current_pos = current_pos - 1
    mem[current_pos + 1] = mem[current_pos + 1] + 1
    io.write(string.format("%c", mem[current_pos + 1]))
    current_pos = current_pos + 1
end

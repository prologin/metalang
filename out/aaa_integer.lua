
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end

local i = 0
i = i - 1
io.write(string.format("%d\n", i))
i = i + 55
io.write(string.format("%d\n", i))
i = i * 13
io.write(string.format("%d\n", i))
i = trunc(i / 2)
io.write(string.format("%d\n", i))
i = i + 1
io.write(string.format("%d\n", i))
i = trunc(i / 3)
io.write(string.format("%d\n", i))
i = i - 1
io.write(string.format("%d\n", i))
--[[
http://fr.wikipedia.org/wiki/Modulo_(op%C3%A9ration)#Trois_d.C3.A9finitions_de_la_fonction_modulo
--]]
io.write(string.format("%d\n%d\n%d\n%d\n%d\n%d\n%d\n%d\n", trunc(117 / 17), trunc(117 / -17), trunc(-117 / 17), trunc(-117 / -17), math.fmod(117, 17), math.fmod(117, -17), math.fmod(-117, 17), math.fmod(-117, -17)))

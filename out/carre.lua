
function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end

local x = tonumber(io.read('*l'))
local y = tonumber(io.read('*l'))
local tab = {}
for d = 0, y - 1 do
    tab[d + 1] = readintline()
end
for ix = 1, x - 1 do
    for iy = 1, y - 1 do
        if tab[iy + 1][ix + 1] == 1 then
            tab[iy + 1][ix + 1] = math.min(tab[iy + 1][ix], tab[iy][ix + 1], tab[iy][ix]) + 1
        end
    end
end
for jy = 0, y - 1 do
    for jx = 0, x - 1 do
        io.write(string.format("%d ", tab[jy + 1][jx + 1]))
    end
    io.write("\n")
end

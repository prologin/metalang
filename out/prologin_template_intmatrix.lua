
function readintline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    table.insert(tab, tonumber(a))
  end
  return tab
end
function programme_candidat (tableau, x, y)
  local out0 = 0
  for i = 0, y - 1 do
      for j = 0, x - 1 do
          out0 = out0 + tableau[i + 1][j + 1] * (i * 2 + j)
      end
  end
  return out0
end

local taille_x = tonumber(io.read('*l'))
local taille_y = tonumber(io.read('*l'))
local tableau = {}
for a = 0, taille_y - 1 do
    tableau[a + 1] = readintline()
end
io.write(string.format("%d\n", programme_candidat(tableau, taille_x, taille_y)))

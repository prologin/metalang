
function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end
function programme_candidat (tableau, taille)
  local out0 = 0
  for i = 0, taille - 1 do
      out0 = out0 + tableau[i + 1]
  end
  return out0
end

local taille = tonumber(io.read('*l'))
local tableau = readintline()
io.write(string.format("%d\n", programme_candidat(tableau, taille)))

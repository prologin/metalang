
function readcharline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), ".") do
    tab[index] = string.byte(a)
    index = index + 1
  end
  return tab
end
function programme_candidat (tableau, taille)
  local out0 = 0
  for i = 0, taille - 1 do
      out0 = out0 + tableau[i + 1] * i
      io.write(string.format("%c", tableau[i + 1]))
  end
  io.write("--\n")
  return out0
end

local taille = tonumber(io.read('*l'))
local tableau = readcharline()
io.write(string.format("%d\n", programme_candidat(tableau, taille)))

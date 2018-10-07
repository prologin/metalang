
function readcharline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), ".") do
    tab[index] = string.byte(a)
    index = index + 1
  end
  return tab
end
function programme_candidat (tableau, taille_x, taille_y)
  local out0 = 0
  for i = 0, taille_y - 1 do
      for j = 0, taille_x - 1 do
          out0 = out0 + tableau[i + 1][j + 1] * (i + j * 2)
          io.write(string.format("%c", tableau[i + 1][j + 1]))
      end
      io.write("--\n")
  end
  return out0
end

local taille_x = tonumber(io.read('*l'))
local taille_y = tonumber(io.read('*l'))
local a = {}
for b = 0, taille_y - 1 do
    a[b + 1] = readcharline()
end
local tableau = a
io.write(string.format("%d\n", programme_candidat(tableau, taille_x, taille_y)))

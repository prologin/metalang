
function readcharline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), ".") do
    tab[index] = string.byte(a)
    index = index + 1
  end
  return tab
end

local str = readcharline()
for i = 0, 11 do
    io.write(string.format("%c", str[i + 1]))
end

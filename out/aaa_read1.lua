
function readcharline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), ".") do
    table.insert(tab, string.byte(a))
  end
  return tab
end

local str = readcharline()
for i = 0, 11 do
    io.write(string.format("%c", str[i + 1]))
end

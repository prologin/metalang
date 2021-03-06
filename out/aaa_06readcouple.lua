
function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end

for i = 1, 3 do
    a, b = table.unpack(readintline())
    io.write(string.format("a = %d b = %d\n", a, b))
end
local l = readintline()
for j = 0, 9 do
    io.write(string.format("%d\n", l[j + 1]))
end

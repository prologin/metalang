
function readintline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    table.insert(tab, tonumber(a))
  end
  return tab
end

for i = 1, 3 do
    a, b, c = table.unpack(readintline())
    io.write(string.format("a = %d b = %dc =%d\n", a, b, c))
end
local l = readintline()
for j = 0, 9 do
    io.write(string.format("%d\n", l[j + 1]))
end

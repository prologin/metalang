
function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end

local bar_ = tonumber(io.read('*l'))
local t = {foo=readintline(), bar=bar_}
a, b = table.unpack(t.foo)
io.write(string.format("%d %d %d\n", a, b, t.bar))

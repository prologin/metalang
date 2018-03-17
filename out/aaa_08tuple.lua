
function readintline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    table.insert(tab, tonumber(a))
  end
  return tab
end

local bar_ = tonumber(io.read('*l'))
local t = {foo=readintline(), bar=bar_}
a, b = table.unpack(t.foo)
io.write(string.format("%d %d %d\n", a, b, t.bar))

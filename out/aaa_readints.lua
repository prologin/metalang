
function readintline()
  local tab = {}
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    table.insert(tab, tonumber(a))
  end
  return tab
end

local len = tonumber(io.read('*l'))
io.write(string.format("%d=len\n", len))
local tab1 = readintline()
for i = 0, len - 1 do
    io.write(string.format("%d=>%d\n", i, tab1[i + 1]))
end
len = tonumber(io.read('*l'))
local tab2 = {}
for a = 0, len - 2 do
    tab2[a + 1] = readintline()
end
for i = 0, len - 2 do
    for j = 0, len - 1 do
        io.write(string.format("%d ", tab2[i + 1][j + 1]))
    end
    io.write("\n")
end

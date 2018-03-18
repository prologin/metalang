
local tab = {}
for i = 0, 39 do
    tab[i + 1] = i * i
end
io.write(string.format("%d\n", #tab))

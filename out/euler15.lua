
local n = 10
--[[ normalement on doit mettre 20 mais là on se tape un overflow --]]
n = n + 1
local tab = {}
for i = 0, n - 1 do
    local tab2 = {}
    for j = 0, n - 1 do
        tab2[j + 1] = 0
    end
    tab[i + 1] = tab2
end
for l = 0, n - 1 do
    tab[n][l + 1] = 1
    tab[l + 1][n] = 1
end
for o = 2, n do
    local r = n - o
    for p = 2, n do
        local q = n - p
        tab[r + 1][q + 1] = tab[r + 2][q + 1] + tab[r + 1][q + 2]
    end
end
for m = 0, n - 1 do
    for k = 0, n - 1 do
        io.write(string.format("%d ", tab[m + 1][k + 1]))
    end
    io.write("\n")
end
io.write(string.format("%d\n", tab[1][1]))

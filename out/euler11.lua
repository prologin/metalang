
function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end
function find (n, m, x, y, dx, dy)
  if x < 0 or x == 20 or y < 0 or y == 20 then
      return -1
  elseif n == 0 then
      return 1
  else 
      return m[y + 1][x + 1] * find(n - 1, m, x + dx, y + dy, dx, dy)
  end
end

local directions = {}
for i = 0, 7 do
    if i == 0 then
        directions[i + 1] = table.pack(0, 1)
    elseif i == 1 then
        directions[i + 1] = table.pack(1, 0)
    elseif i == 2 then
        directions[i + 1] = table.pack(0, -1)
    elseif i == 3 then
        directions[i + 1] = table.pack(-1, 0)
    elseif i == 4 then
        directions[i + 1] = table.pack(1, 1)
    elseif i == 5 then
        directions[i + 1] = table.pack(1, -1)
    elseif i == 6 then
        directions[i + 1] = table.pack(-1, 1)
    else 
        directions[i + 1] = table.pack(-1, -1)
    end
end
local max0 = 0
local m = {}
for c = 0, 19 do
    m[c + 1] = readintline()
end
for j = 0, 7 do
    dx, dy = table.unpack(directions[j + 1])
    for x = 0, 19 do
        for y = 0, 19 do
            max0 = math.max(max0, find(4, m, x, y, dx, dy))
        end
    end
end
io.write(string.format("%d\n", max0))


function readintline()
  local tab = {}
  local index = 1
  for a in string.gmatch(io.read("*l"), "-?%d+") do
    tab[index] = tonumber(a)
    index = index + 1
  end
  return tab
end

function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function dichofind (len, tab, tofind, a, b)
  if a >= b - 1 then
      return a
  else 
      local c = trunc((a + b) / 2)
      if tab[c + 1] < tofind then
          return dichofind(len, tab, tofind, c, b)
      else 
          return dichofind(len, tab, tofind, a, c)
      end
  end
end

function process (len, tab)
  local size = {}
  for j = 0, len - 1 do
      if j == 0 then
          size[j + 1] = 0
      else 
          size[j + 1] = len * 2
      end
  end
  for i = 0, len - 1 do
      local k = dichofind(len, size, tab[i + 1], 0, len - 1)
      if size[k + 2] > tab[i + 1] then
          size[k + 2] = tab[i + 1]
      end
  end
  for l = 0, len - 1 do
      io.write(string.format("%d ", size[l + 1]))
  end
  for m = 0, len - 1 do
      local k = len - 1 - m
      if size[k + 1] ~= len * 2 then
          return k
      end
  end
  return 0
end

local n = tonumber(io.read('*l'))
for i = 1, n do
    local len = tonumber(io.read('*l'))
    io.write(string.format("%d\n", process(len, readintline())))
end

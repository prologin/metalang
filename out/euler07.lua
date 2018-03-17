function divisible (n, t, size)
  for i = 0, size - 1 do
      if math.fmod(n, t[i + 1]) == 0 then
          return true
      end
  end
  return false
end

function find (n, t, used, nth)
  while used ~= nth do
      if divisible(n, t, used) then
          n = n + 1
      else 
          t[used + 1] = n
          n = n + 1
          used = used + 1
      end
  end
  return t[used]
end

local n = 10001
local t = {}
for i = 0, n - 1 do
    t[i + 1] = 2
end
io.write(string.format("%d\n", find(3, t, 1, n)))

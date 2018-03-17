function h (i)
  --[[  for j = i - 2 to i + 2 do
    if i % j == 5 then return true end
  end --]]
  local j = i - 2
  while j <= i + 2 do
      if math.fmod(i, j) == 5 then
          return true
      end
      j = j + 1
  end
  return false
end

local j = 0
for k = 0, 10 do
    j = j + k
    io.write(string.format("%d\n", j))
end
local i = 4
while i < 10 do
    io.write(i)
    i = i + 1
    j = j + i
end
io.write(string.format("%d%dFIN TEST\n", j, i))

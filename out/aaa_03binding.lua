function g (i)
  local j = i * 4
  if math.fmod(j, 2) == 1 then
      return 0
  end
  return j
end

function h (i)
  io.write(string.format("%d\n", i))
end

h(14)
local a = 4
local b = 5
io.write(a + b)
--[[ main --]]
h(15)
a = 2
b = 1
io.write(a + b)

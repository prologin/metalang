function id (b)
  return b
end

function g (t, index)
  t[index + 1] = false
end

local j = 0
local a = {}
for i = 0, 4 do
    io.write(i)
    j = j + i
    a[i + 1] = math.fmod(i, 2) == 0
end
io.write(string.format("%d ", j))
if a[1] then
    io.write("True")
else 
    io.write("False")
end
io.write("\n")
g(id(a), 0)
if a[1] then
    io.write("True")
else 
    io.write("False")
end
io.write("\n")

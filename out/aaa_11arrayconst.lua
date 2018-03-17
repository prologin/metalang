function test (tab, len)
  for i = 0, len - 1 do
      io.write(string.format("%d ", tab[i + 1]))
  end
  io.write("\n")
end

local t = {}
for i = 0, 4 do
    t[i + 1] = 1
end
test(t, 5)

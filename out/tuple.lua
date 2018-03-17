function f (tuple0)
  a, b = table.unpack(tuple0)
  return table.pack(a + 1, b + 1)
end

local t = f(table.pack(0, 1))
a, b = table.unpack(t)
io.write(string.format("%d -- %d--\n", a, b))

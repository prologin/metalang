
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function exp0 (a, e)
  local o = 1
  for i = 1, e do
      o = o * a
  end
  return o
end

function e (t, n)
  for i = 1, 8 do
      if n >= t[i + 1] * i then
          n = n - t[i + 1] * i
      else 
          local nombre = exp0(10, i - 1) + trunc(n / i)
          local chiffre = i - 1 - math.fmod(n, i)
          return math.fmod(trunc(nombre / exp0(10, chiffre)), 10)
      end
  end
  return -1
end

local t = {}
for i = 0, 8 do
    t[i + 1] = exp0(10, i) - exp0(10, i - 1)
end
for i2 = 1, 8 do
    io.write(string.format("%d => %d\n", i2, t[i2 + 1]))
end
for j = 0, 80 do
    io.write(e(t, j))
end
io.write("\n")
for k = 1, 50 do
    io.write(k)
end
io.write("\n")
for j2 = 169, 220 do
    io.write(e(t, j2))
end
io.write("\n")
for k2 = 90, 110 do
    io.write(k2)
end
io.write("\n")
local out0 = 1
for l = 0, 6 do
    local puiss = exp0(10, l)
    local v = e(t, puiss - 1)
    out0 = out0 * v
    io.write(string.format("10^%d=%d v=%d\n", l, puiss, v))
end
io.write(string.format("%d\n", out0))

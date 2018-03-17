
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function eratostene (t, max0)
  local sum = 0
  for i = 2, max0 - 1 do
      if t[i + 1] == i then
          sum = sum + i
          if trunc(max0 / i) > i then
              local j = i * i
              while j < max0 and j > 0 do
                  t[j + 1] = 0
                  j = j + i
              end
          end
      end
  end
  return sum
end

local n = 100000
--[[ normalement on met 2000 000 mais là on se tape des int overflow dans plein de langages --]]
local t = {}
for i = 0, n - 1 do
    t[i + 1] = i
end
t[2] = 0
io.write(string.format("%d\n", eratostene(t, n)))


function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function primesfactors (n)
  local tab = {}
  for i = 0, n do
      tab[i + 1] = 0
  end
  local d = 2
  while n ~= 1 and d * d <= n do
      if math.fmod(n, d) == 0 then
          tab[d + 1] = tab[d + 1] + 1
          n = trunc(n / d)
      else 
          d = d + 1
      end
  end
  tab[n + 1] = tab[n + 1] + 1
  return tab
end

local lim = 20
local o = {}
for m = 0, lim do
    o[m + 1] = 0
end
for i = 1, lim do
    local t = primesfactors(i)
    for j = 1, i do
        o[j + 1] = math.max(o[j + 1], t[j + 1])
    end
end
local product = 1
for k = 1, lim do
    for l = 1, o[k + 1] do
        product = product * k
    end
end
io.write(string.format("%d\n", product))

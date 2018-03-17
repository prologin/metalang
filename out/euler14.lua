
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function next0 (n)
  if math.fmod(n, 2) == 0 then
      return trunc(n / 2)
  else 
      return 3 * n + 1
  end
end

function find (n, m)
  if n == 1 then
      return 1
  elseif n >= 1000000 then
      return 1 + find(next0(n), m)
  elseif m[n + 1] ~= 0 then
      return m[n + 1]
  else 
      m[n + 1] = 1 + find(next0(n), m)
      return m[n + 1]
  end
end

local m = {}
for j = 0, 999999 do
    m[j + 1] = 0
end
local max0 = 0
local maxi = 0
for i = 1, 999 do
    --[[ normalement on met 999999 mais ça dépasse les int32... --]]
    local n2 = find(i, m)
    if n2 > max0 then
        max0 = n2
        maxi = i
    end
end
io.write(string.format("%d\n%d\n", max0, maxi))

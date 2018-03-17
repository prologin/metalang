
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function periode (restes, len, a, b)
  while a ~= 0 do
      local chiffre = trunc(a / b)
      local reste = math.fmod(a, b)
      for i = 0, len - 1 do
          if restes[i + 1] == reste then
              return len - i
          end
      end
      restes[len + 1] = reste
      len = len + 1
      a = reste * 10
  end
  return 0
end

local t = {}
for j = 0, 999 do
    t[j + 1] = 0
end
local m = 0
local mi = 0
for i = 1, 1000 do
    local p = periode(t, 0, 1, i)
    if p > m then
        mi = i
        m = p
    end
end
io.write(string.format("%d\n%d\n", mi, m))

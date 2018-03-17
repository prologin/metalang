
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function eratostene (t, max0)
  local n = 0
  for i = 2, max0 - 1 do
      if t[i + 1] == i then
          n = n + 1
          if trunc(max0 / i) > i then
              local j = i * i
              while j < max0 and j > 0 do
                  t[j + 1] = 0
                  j = j + i
              end
          end
      end
  end
  return n
end

local maximumprimes = 6000
local era = {}
for j_ = 0, maximumprimes - 1 do
    era[j_ + 1] = j_
end
local nprimes = eratostene(era, maximumprimes)
local primes = {}
for o = 0, nprimes - 1 do
    primes[o + 1] = 0
end
local l = 0
for k = 2, maximumprimes - 1 do
    if era[k + 1] == k then
        primes[l + 1] = k
        l = l + 1
    end
end
io.write(string.format("%d == %d\n", l, nprimes))
local canbe = {}
for i_ = 0, maximumprimes - 1 do
    canbe[i_ + 1] = false
end
for i = 0, nprimes - 1 do
    for j = 0, maximumprimes - 1 do
        local n = primes[i + 1] + 2 * j * j
        if n < maximumprimes then
            canbe[n + 1] = true
        end
    end
end
for m = 1, maximumprimes do
    local m2 = m * 2 + 1
    if m2 < maximumprimes and not(canbe[m2 + 1]) then
        io.write(string.format("%d\n", m2))
    end
end

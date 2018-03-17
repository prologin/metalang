
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
--[[
We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once;
for example, the 5-digit number, 15234, is 1 through 5 pandigital.

The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier,
and product is 1 through 9 pandigital.

Find the sum of all products whose multiplicand/multiplier/product identity can be written as a
1 through 9 pandigital.

HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.


(a * 10 + b) ( c * 100 + d * 10 + e) =
  a * c * 1000 +
  a * d * 100 +
  a * e * 10 +
  b * c * 100 +
  b * d * 10 +
  b * e
  => b != e != b * e % 10 ET
  a != d != (b * e / 10 + b * d + a * e ) % 10
--]]

function okdigits (ok, n)
  if n == 0 then
      return true
  else 
      local digit = math.fmod(n, 10)
      if ok[digit + 1] then
          ok[digit + 1] = false
          local o = okdigits(ok, trunc(n / 10))
          ok[digit + 1] = true
          return o
      else 
          return false
      end
  end
end

local count = 0
local allowed = {}
for i = 0, 9 do
    allowed[i + 1] = i ~= 0
end
local counted = {}
for j = 0, 99999 do
    counted[j + 1] = false
end
for e = 1, 9 do
    allowed[e + 1] = false
    for b = 1, 9 do
        if allowed[b + 1] then
            allowed[b + 1] = false
            local be = math.fmod(b * e, 10)
            if allowed[be + 1] then
                allowed[be + 1] = false
                for a = 1, 9 do
                    if allowed[a + 1] then
                        allowed[a + 1] = false
                        for c = 1, 9 do
                            if allowed[c + 1] then
                                allowed[c + 1] = false
                                for d = 1, 9 do
                                    if allowed[d + 1] then
                                        allowed[d + 1] = false
                                        --[[ 2 * 3 digits --]]
                                        local product = (a * 10 + b) * (c * 100 + d * 10 + e)
                                        if not(counted[product + 1]) and okdigits(allowed, trunc(product / 10)) then
                                            counted[product + 1] = true
                                            count = count + product
                                            io.write(string.format("%d ", product))
                                        end
                                        --[[ 1  * 4 digits --]]
                                        local product2 = b * (a * 1000 + c * 100 + d * 10 + e)
                                        if not(counted[product2 + 1]) and okdigits(allowed, trunc(product2 / 10)) then
                                            counted[product2 + 1] = true
                                            count = count + product2
                                            io.write(string.format("%d ", product2))
                                        end
                                        allowed[d + 1] = true
                                    end
                                end
                                allowed[c + 1] = true
                            end
                        end
                        allowed[a + 1] = true
                    end
                end
                allowed[be + 1] = true
            end
            allowed[b + 1] = true
        end
    end
    allowed[e + 1] = true
end
io.write(string.format("%d\n", count))

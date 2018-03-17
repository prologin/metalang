
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function fact (n)
  local prod = 1
  for i = 2, n do
      prod = prod * i
  end
  return prod
end

function show (lim, nth)
  local t = {}
  for i = 0, lim - 1 do
      t[i + 1] = i
  end
  local pris = {}
  for j = 0, lim - 1 do
      pris[j + 1] = false
  end
  for k = 1, lim - 1 do
      local n = fact(lim - k)
      local nchiffre = trunc(nth / n)
      nth = math.fmod(nth, n)
      for l = 0, lim - 1 do
          if not(pris[l + 1]) then
              if nchiffre == 0 then
                  io.write(l)
                  pris[l + 1] = true
              end
              nchiffre = nchiffre - 1
          end
      end
  end
  for m = 0, lim - 1 do
      if not(pris[m + 1]) then
          io.write(m)
      end
  end
  io.write("\n")
end

show(10, 999999)

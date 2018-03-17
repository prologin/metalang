
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function chiffre_sort (a)
  if a < 10 then
      return a
  else 
      local b = chiffre_sort(trunc(a / 10))
      local c = math.fmod(a, 10)
      local d = math.fmod(b, 10)
      local e = trunc(b / 10)
      if c < d then
          return c + b * 10
      else 
          return d + chiffre_sort(c + e * 10) * 10
      end
  end
end

function same_numbers (a, b, c, d, e, f)
  local ca = chiffre_sort(a)
  return ca == chiffre_sort(b) and ca == chiffre_sort(c) and ca == chiffre_sort(d) and ca == chiffre_sort(e) and ca == chiffre_sort(f)
end

local num = 142857
if same_numbers(num, num * 2, num * 3, num * 4, num * 6, num * 5) then
    io.write(string.format("%d %d %d %d %d %d\n", num, num * 2, num * 3, num * 4, num * 5, num * 6))
end

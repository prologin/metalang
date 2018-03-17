
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function triangle (n)
  if math.fmod(n, 2) == 0 then
      return trunc(n / 2) * (n + 1)
  else 
      return n * trunc((n + 1) / 2)
  end
end

function penta (n)
  if math.fmod(n, 2) == 0 then
      return trunc(n / 2) * (3 * n - 1)
  else 
      return trunc((3 * n - 1) / 2) * n
  end
end

function hexa (n)
  return n * (2 * n - 1)
end

function findPenta2 (n, a, b)
  if b == a + 1 then
      return penta(a) == n or penta(b) == n
  end
  local c = trunc((a + b) / 2)
  local p = penta(c)
  if p == n then
      return true
  elseif p < n then
      return findPenta2(n, c, b)
  else 
      return findPenta2(n, a, c)
  end
end

function findHexa2 (n, a, b)
  if b == a + 1 then
      return hexa(a) == n or hexa(b) == n
  end
  local c = trunc((a + b) / 2)
  local p = hexa(c)
  if p == n then
      return true
  elseif p < n then
      return findHexa2(n, c, b)
  else 
      return findHexa2(n, a, c)
  end
end

for n = 285, 55385 do
    local t = triangle(n)
    if findPenta2(t, trunc(n / 5), n) and findHexa2(t, trunc(n / 5), trunc(n / 2) + 10) then
        io.write(string.format("%d\n%d\n", n, t))
    end
end

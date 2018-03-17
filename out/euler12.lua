
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function eratostene (t, max0)
  local n = 0
  for i = 2, max0 - 1 do
      if t[i + 1] == i then
          local j = i * i
          n = n + 1
          while j < max0 and j > 0 do
              t[j + 1] = 0
              j = j + i
          end
      end
  end
  return n
end

function fillPrimesFactors (t, n, primes, nprimes)
  for i = 0, nprimes - 1 do
      local d = primes[i + 1]
      while math.fmod(n, d) == 0 do
          t[d + 1] = t[d + 1] + 1
          n = trunc(n / d)
      end
      if n == 1 then
          return primes[i + 1]
      end
  end
  return n
end

function find (ndiv2)
  local maximumprimes = 110
  local era = {}
  for j = 0, maximumprimes - 1 do
      era[j + 1] = j
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
  for n = 1, 10000 do
      local primesFactors = {}
      for m = 0, n + 1 do
          primesFactors[m + 1] = 0
      end
      local max0 = math.max(fillPrimesFactors(primesFactors, n, primes, nprimes), fillPrimesFactors(primesFactors, n + 1, primes, nprimes))
      primesFactors[3] = primesFactors[3] - 1
      local ndivs = 1
      for i = 0, max0 do
          if primesFactors[i + 1] ~= 0 then
              ndivs = ndivs * (1 + primesFactors[i + 1])
          end
      end
      if ndivs > ndiv2 then
          return trunc(n * (n + 1) / 2)
      end
      --[[ print "n=" print n print "\t" print (n * (n + 1) / 2 ) print " " print ndivs print "\n" --]]
  end
  return 0
end

io.write(string.format("%d\n", find(500)))

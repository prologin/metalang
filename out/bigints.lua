
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
buffer =  ""
function readchar()
    if buffer == "" then buffer = io.read("*line") end
    local c = string.byte(buffer)
    buffer = string.sub(buffer, 2, -1)
    return c
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
function read_bigint (len)
  local chiffres = {}
  for j = 0, len - 1 do
      local c = readchar()
      chiffres[j + 1] = c
  end
  for i = 0, trunc((len - 1) / 2) do
      local tmp = chiffres[i + 1]
      chiffres[i + 1] = chiffres[len - 1 - i + 1]
      chiffres[len - 1 - i + 1] = tmp
  end
  return {bigint_sign=true, bigint_len=len, bigint_chiffres=chiffres}
end

function print_bigint (a)
  if not(a.bigint_sign) then
      io.write(string.format("%c", 45))
  end
  for i = 0, a.bigint_len - 1 do
      io.write(a.bigint_chiffres[a.bigint_len - 1 - i + 1])
  end
end

function bigint_eq (a, b)
  --[[ Renvoie vrai si a = b --]]
  if a.bigint_sign ~= b.bigint_sign then
      return false
  elseif a.bigint_len ~= b.bigint_len then
      return false
  else 
      for i = 0, a.bigint_len - 1 do
          if a.bigint_chiffres[i + 1] ~= b.bigint_chiffres[i + 1] then
              return false
          end
      end
      return true
  end
end

function bigint_gt (a, b)
  --[[ Renvoie vrai si a > b --]]
  if a.bigint_sign and not(b.bigint_sign) then
      return true
  elseif not(a.bigint_sign) and b.bigint_sign then
      return false
  else 
      if a.bigint_len > b.bigint_len then
          return a.bigint_sign
      elseif a.bigint_len < b.bigint_len then
          return not(a.bigint_sign)
      else 
          for i = 0, a.bigint_len - 1 do
              local j = a.bigint_len - 1 - i
              if a.bigint_chiffres[j + 1] > b.bigint_chiffres[j + 1] then
                  return a.bigint_sign
              elseif a.bigint_chiffres[j + 1] < b.bigint_chiffres[j + 1] then
                  return not(a.bigint_sign)
              end
          end
      end
      return true
  end
end

function bigint_lt (a, b)
  return not(bigint_gt(a, b))
end

function add_bigint_positif (a, b)
  --[[ Une addition ou on en a rien a faire des signes --]]
  local len = math.max(a.bigint_len, b.bigint_len) + 1
  local retenue = 0
  local chiffres = {}
  for i = 0, len - 1 do
      local tmp = retenue
      if i < a.bigint_len then
          tmp = tmp + a.bigint_chiffres[i + 1]
      end
      if i < b.bigint_len then
          tmp = tmp + b.bigint_chiffres[i + 1]
      end
      retenue = trunc(tmp / 10)
      chiffres[i + 1] = math.fmod(tmp, 10)
  end
  while len > 0 and chiffres[len] == 0 do
      len = len - 1
  end
  return {bigint_sign=true, bigint_len=len, bigint_chiffres=chiffres}
end

function sub_bigint_positif (a, b)
  --[[ Une soustraction ou on en a rien a faire des signes
Pré-requis : a > b
--]]
  local len = a.bigint_len
  local retenue = 0
  local chiffres = {}
  for i = 0, len - 1 do
      local tmp = retenue + a.bigint_chiffres[i + 1]
      if i < b.bigint_len then
          tmp = tmp - b.bigint_chiffres[i + 1]
      end
      if tmp < 0 then
          tmp = tmp + 10
          retenue = -1
      else 
          retenue = 0
      end
      chiffres[i + 1] = tmp
  end
  while len > 0 and chiffres[len] == 0 do
      len = len - 1
  end
  return {bigint_sign=true, bigint_len=len, bigint_chiffres=chiffres}
end

function neg_bigint (a)
  return {bigint_sign=not(a.bigint_sign), bigint_len=a.bigint_len, bigint_chiffres=a.bigint_chiffres}
end

function add_bigint (a, b)
  if a.bigint_sign == b.bigint_sign then
      if a.bigint_sign then
          return add_bigint_positif(a, b)
      else 
          return neg_bigint(add_bigint_positif(a, b))
      end
  elseif a.bigint_sign then
      --[[ a positif, b negatif --]]
      if bigint_gt(a, neg_bigint(b)) then
          return sub_bigint_positif(a, b)
      else 
          return neg_bigint(sub_bigint_positif(b, a))
      end
  else 
      --[[ a negatif, b positif --]]
      if bigint_gt(neg_bigint(a), b) then
          return neg_bigint(sub_bigint_positif(a, b))
      else 
          return sub_bigint_positif(b, a)
      end
  end
end

function sub_bigint (a, b)
  return add_bigint(a, neg_bigint(b))
end

function mul_bigint_cp (a, b)
  --[[ Cet algorithm est quadratique.
C'est le même que celui qu'on enseigne aux enfants en CP.
D'ou le nom de la fonction. --]]
  local len = a.bigint_len + b.bigint_len + 1
  local chiffres = {}
  for k = 0, len - 1 do
      chiffres[k + 1] = 0
  end
  for i = 0, a.bigint_len - 1 do
      local retenue = 0
      for j = 0, b.bigint_len - 1 do
          chiffres[i + j + 1] = chiffres[i + j + 1] + retenue + b.bigint_chiffres[j + 1] * a.bigint_chiffres[i + 1]
          retenue = trunc(chiffres[i + j + 1] / 10)
          chiffres[i + j + 1] = math.fmod(chiffres[i + j + 1], 10)
      end
      chiffres[i + b.bigint_len + 1] = chiffres[i + b.bigint_len + 1] + retenue
  end
  chiffres[a.bigint_len + b.bigint_len + 1] = trunc(chiffres[a.bigint_len + b.bigint_len] / 10)
  chiffres[a.bigint_len + b.bigint_len] = math.fmod(chiffres[a.bigint_len + b.bigint_len], 10)
  for l = 0, 2 do
      if len ~= 0 and chiffres[len] == 0 then
          len = len - 1
      end
  end
  return {bigint_sign=a.bigint_sign == b.bigint_sign, bigint_len=len, bigint_chiffres=chiffres}
end

function bigint_premiers_chiffres (a, i)
  local len = math.min(i, a.bigint_len)
  while len ~= 0 and a.bigint_chiffres[len] == 0 do
      len = len - 1
  end
  return {bigint_sign=a.bigint_sign, bigint_len=len, bigint_chiffres=a.bigint_chiffres}
end

function bigint_shift (a, i)
  local chiffres = {}
  for k = 0, a.bigint_len + i - 1 do
      if k >= i then
          chiffres[k + 1] = a.bigint_chiffres[k - i + 1]
      else 
          chiffres[k + 1] = 0
      end
  end
  return {bigint_sign=a.bigint_sign, bigint_len=a.bigint_len + i, bigint_chiffres=chiffres}
end

function mul_bigint (aa, bb)
  if aa.bigint_len == 0 then
      return aa
  elseif bb.bigint_len == 0 then
      return bb
  elseif aa.bigint_len < 3 or bb.bigint_len < 3 then
      return mul_bigint_cp(aa, bb)
  end
  --[[ Algorithme de Karatsuba --]]
  local split = trunc(math.min(aa.bigint_len, bb.bigint_len) / 2)
  local a = bigint_shift(aa, -split)
  local b = bigint_premiers_chiffres(aa, split)
  local c = bigint_shift(bb, -split)
  local d = bigint_premiers_chiffres(bb, split)
  local amoinsb = sub_bigint(a, b)
  local cmoinsd = sub_bigint(c, d)
  local ac = mul_bigint(a, c)
  local bd = mul_bigint(b, d)
  local amoinsbcmoinsd = mul_bigint(amoinsb, cmoinsd)
  local acdec = bigint_shift(ac, 2 * split)
  return add_bigint(add_bigint(acdec, bd), bigint_shift(sub_bigint(add_bigint(ac, bd), amoinsbcmoinsd), split))
  --[[ ac × 102k + (ac + bd – (a – b)(c – d)) × 10k + bd --]]
end

--[[
Division,
Modulo
--]]

function log10 (a)
  local out0 = 1
  while a >= 10 do
      a = trunc(a / 10)
      out0 = out0 + 1
  end
  return out0
end

function bigint_of_int (i)
  local size = log10(i)
  if i == 0 then
      size = 0
  end
  local t = {}
  for j = 0, size - 1 do
      t[j + 1] = 0
  end
  for k = 0, size - 1 do
      t[k + 1] = math.fmod(i, 10)
      i = trunc(i / 10)
  end
  return {bigint_sign=true, bigint_len=size, bigint_chiffres=t}
end

function fact_bigint (a)
  local one = bigint_of_int(1)
  local out0 = one
  while not(bigint_eq(a, one)) do
      out0 = mul_bigint(a, out0)
      a = sub_bigint(a, one)
  end
  return out0
end

function sum_chiffres_bigint (a)
  local out0 = 0
  for i = 0, a.bigint_len - 1 do
      out0 = out0 + a.bigint_chiffres[i + 1]
  end
  return out0
end

--[[ http://projecteuler.net/problem=20 --]]

function euler20 ()
  local a = bigint_of_int(15)
  --[[ normalement c'est 100 --]]
  a = fact_bigint(a)
  return sum_chiffres_bigint(a)
end

function bigint_exp (a, b)
  if b == 1 then
      return a
  elseif math.fmod(b, 2) == 0 then
      return bigint_exp(mul_bigint(a, a), trunc(b / 2))
  else 
      return mul_bigint(a, bigint_exp(a, b - 1))
  end
end

function bigint_exp_10chiffres (a, b)
  a = bigint_premiers_chiffres(a, 10)
  if b == 1 then
      return a
  elseif math.fmod(b, 2) == 0 then
      return bigint_exp_10chiffres(mul_bigint(a, a), trunc(b / 2))
  else 
      return mul_bigint(a, bigint_exp_10chiffres(a, b - 1))
  end
end

function euler48 ()
  local sum = bigint_of_int(0)
  for i = 1, 100 do
      --[[ 1000 normalement --]]
      local ib = bigint_of_int(i)
      local ibeib = bigint_exp_10chiffres(ib, i)
      sum = add_bigint(sum, ibeib)
      sum = bigint_premiers_chiffres(sum, 10)
  end
  io.write("euler 48 = ")
  print_bigint(sum)
  io.write("\n")
end

function euler16 ()
  local a = bigint_of_int(2)
  a = bigint_exp(a, 100)
  --[[ 1000 normalement --]]
  return sum_chiffres_bigint(a)
end

function euler25 ()
  local i = 2
  local a = bigint_of_int(1)
  local b = bigint_of_int(1)
  while b.bigint_len < 100 do
      --[[ 1000 normalement --]]
      local c = add_bigint(a, b)
      a = b
      b = c
      i = i + 1
  end
  return i
end

function euler29 ()
  local maxA = 5
  local maxB = 5
  local a_bigint = {}
  for j = 0, maxA do
      a_bigint[j + 1] = bigint_of_int(j * j)
  end
  local a0_bigint = {}
  for j2 = 0, maxA do
      a0_bigint[j2 + 1] = bigint_of_int(j2)
  end
  local b = {}
  for k = 0, maxA do
      b[k + 1] = 2
  end
  local n = 0
  local found = true
  while found do
      local min0 = a0_bigint[1]
      found = false
      for i = 2, maxA do
          if b[i + 1] <= maxB then
              if found then
                  if bigint_lt(a_bigint[i + 1], min0) then
                      min0 = a_bigint[i + 1]
                  end
              else 
                  min0 = a_bigint[i + 1]
                  found = true
              end
          end
      end
      if found then
          n = n + 1
          for l = 2, maxA do
              if bigint_eq(a_bigint[l + 1], min0) and b[l + 1] <= maxB then
                  b[l + 1] = b[l + 1] + 1
                  a_bigint[l + 1] = mul_bigint(a_bigint[l + 1], a0_bigint[l + 1])
              end
          end
      end
  end
  return n
end

io.write(string.format("%d\n", euler29()))
local sum = read_bigint(50)
for i = 2, 100 do
    stdinsep()
    local tmp = read_bigint(50)
    sum = add_bigint(sum, tmp)
end
io.write("euler13 = ")
print_bigint(sum)
io.write(string.format("\neuler25 = %d\neuler16 = %d\n", euler25(), euler16()))
euler48()
io.write(string.format("euler20 = %d\n", euler20()))
local a = bigint_of_int(999999)
local b = bigint_of_int(9951263)
print_bigint(a)
io.write(">>1=")
print_bigint(bigint_shift(a, -1))
io.write("\n")
print_bigint(a)
io.write("*")
print_bigint(b)
io.write("=")
print_bigint(mul_bigint(a, b))
io.write("\n")
print_bigint(a)
io.write("*")
print_bigint(b)
io.write("=")
print_bigint(mul_bigint_cp(a, b))
io.write("\n")
print_bigint(a)
io.write("+")
print_bigint(b)
io.write("=")
print_bigint(add_bigint(a, b))
io.write("\n")
print_bigint(b)
io.write("-")
print_bigint(a)
io.write("=")
print_bigint(sub_bigint(b, a))
io.write("\n")
print_bigint(a)
io.write("-")
print_bigint(b)
io.write("=")
print_bigint(sub_bigint(a, b))
io.write("\n")
print_bigint(a)
io.write(">")
print_bigint(b)
io.write("=")
if bigint_gt(a, b) then
    io.write("True")
else 
    io.write("False")
end
io.write("\n")

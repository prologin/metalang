
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
function palindrome2 (pow2, n)
  local t = {}
  for i = 0, 19 do
      t[i + 1] = math.fmod(trunc(n / pow2[i + 1]), 2) == 1
  end
  local nnum = 0
  for j = 1, 19 do
      if t[j + 1] then
          nnum = j
      end
  end
  for k = 0, trunc(nnum / 2) do
      if t[k + 1] ~= t[nnum - k + 1] then
          return false
      end
  end
  return true
end

local p = 1
local pow2 = {}
for i = 0, 19 do
    p = p * 2
    pow2[i + 1] = trunc(p / 2)
end
local sum = 0
for d = 1, 9 do
    if palindrome2(pow2, d) then
        io.write(string.format("%d\n", d))
        sum = sum + d
    end
    if palindrome2(pow2, d * 10 + d) then
        io.write(string.format("%d\n", d * 10 + d))
        sum = sum + d * 10 + d
    end
end
for a0 = 0, 4 do
    local a = a0 * 2 + 1
    for b = 0, 9 do
        for c = 0, 9 do
            local num0 = a * 100000 + b * 10000 + c * 1000 + c * 100 + b * 10 + a
            if palindrome2(pow2, num0) then
                io.write(string.format("%d\n", num0))
                sum = sum + num0
            end
            local num1 = a * 10000 + b * 1000 + c * 100 + b * 10 + a
            if palindrome2(pow2, num1) then
                io.write(string.format("%d\n", num1))
                sum = sum + num1
            end
        end
        local num2 = a * 100 + b * 10 + a
        if palindrome2(pow2, num2) then
            io.write(string.format("%d\n", num2))
            sum = sum + num2
        end
        local num3 = a * 1000 + b * 100 + b * 10 + a
        if palindrome2(pow2, num3) then
            io.write(string.format("%d\n", num3))
            sum = sum + num3
        end
    end
end
io.write(string.format("sum=%d\n", sum))

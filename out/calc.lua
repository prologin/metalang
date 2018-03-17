--[[
La suite de fibonaci
--]]

function fibo (a, b, i)
  local out_ = 0
  local a2 = a
  local b2 = b
  for j = 0, i + 1 do
      io.write(j)
      out_ = out_ + a2
      local tmp = b2
      b2 = b2 + a2
      a2 = tmp
  end
  return out_
end

io.write(fibo(1, 2, 4))

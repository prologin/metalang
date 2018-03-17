
--[[
a + b * 10 + c * 100 + d * 1000 + e * 10 000 =
  a ^ 5 +
  b ^ 5 +
  c ^ 5 +
  d ^ 5 +
  e ^ 5
--]]
local p = {}
for i = 0, 9 do
    p[i + 1] = i * i * i * i * i
end
local sum = 0
for a = 0, 9 do
    for b = 0, 9 do
        for c = 0, 9 do
            for d = 0, 9 do
                for e = 0, 9 do
                    for f = 0, 9 do
                        local s = p[a + 1] + p[b + 1] + p[c + 1] + p[d + 1] + p[e + 1] + p[f + 1]
                        local r = a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000
                        if s == r and r ~= 1 then
                            io.write(string.format("%d%d%d%d%d%d %d\n", f, e, d, c, b, a, r))
                            sum = sum + r
                        end
                    end
                end
            end
        end
    end
end
io.write(sum)

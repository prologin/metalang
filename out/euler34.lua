
local f = {}
for j = 0, 9 do
    f[j + 1] = 1
end
for i = 1, 9 do
    f[i + 1] = f[i + 1] * i * f[i]
    io.write(string.format("%d ", f[i + 1]))
end
local out0 = 0
io.write("\n")
for a = 0, 9 do
    for b = 0, 9 do
        for c = 0, 9 do
            for d = 0, 9 do
                for e = 0, 9 do
                    for g = 0, 9 do
                        local sum = f[a + 1] + f[b + 1] + f[c + 1] + f[d + 1] + f[e + 1] + f[g + 1]
                        local num = ((((a * 10 + b) * 10 + c) * 10 + d) * 10 + e) * 10 + g
                        if a == 0 then
                            sum = sum - 1
                            if b == 0 then
                                sum = sum - 1
                                if c == 0 then
                                    sum = sum - 1
                                    if d == 0 then
                                        sum = sum - 1
                                    end
                                end
                            end
                        end
                        if sum == num and sum ~= 1 and sum ~= 2 then
                            out0 = out0 + num
                            io.write(string.format("%d ", num))
                        end
                    end
                end
            end
        end
    end
end
io.write(string.format("\n%d\n", out0))

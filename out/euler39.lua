
local t = {}
for i = 0, 1000 do
    t[i + 1] = 0
end
for a = 1, 1000 do
    for b = 1, 1000 do
        local c2 = a * a + b * b
        local c = math.floor(math.sqrt(c2))
        if c * c == c2 then
            local p = a + b + c
            if p < 1001 then
                t[p + 1] = t[p + 1] + 1
            end
        end
    end
end
local j = 0
for k = 1, 1000 do
    if t[k + 1] > t[j + 1] then
        j = k
    end
end
io.write(j)

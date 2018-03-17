
--[[
	a + b + c = 1000 && a * a + b * b = c * c
	--]]
for a = 1, 1000 do
    for b = a + 1, 1000 do
        local c = 1000 - a - b
        local a2b2 = a * a + b * b
        local cc = c * c
        if cc == a2b2 and c > a then
            io.write(string.format("%d\n%d\n%d\n%d\n", a, b, c, a * b * c))
        end
    end
end

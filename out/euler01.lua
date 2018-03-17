
local sum = 0
for i = 0, 999 do
    if math.fmod(i, 3) == 0 or math.fmod(i, 5) == 0 then
        sum = sum + i
    end
end
io.write(string.format("%d\n", sum))

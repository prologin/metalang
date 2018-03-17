
local a = 1
local b = 2
local sum = 0
while a < 4000000 do
    if math.fmod(a, 2) == 0 then
        sum = sum + a
    end
    local c = a
    a = b
    b = b + c
end
io.write(string.format("%d\n", sum))

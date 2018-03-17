
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end

local maximum = 1
local b0 = 2
local a = 408464633
local sqrtia = math.floor(math.sqrt(a))
while a ~= 1 do
    local b = b0
    local found = false
    while b <= sqrtia do
        if math.fmod(a, b) == 0 then
            a = trunc(a / b)
            b0 = b
            b = a
            sqrtia = math.floor(math.sqrt(a))
            found = true
        end
        b = b + 1
    end
    if not(found) then
        io.write(string.format("%d\n", a))
        a = 1
    end
end

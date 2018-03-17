
--[[
The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.

Let d1 be the 1st digit, d2 be the 2nd digit, and so on. In this way, we note the following:

d2d3d4=406 is divisible by 2
d3d4d5=063 is divisible by 3
d4d5d6=635 is divisible by 5
d5d6d7=357 is divisible by 7
d6d7d8=572 is divisible by 11
d7d8d9=728 is divisible by 13
d8d9d10=289 is divisible by 17
Find the sum of all 0 to 9 pandigital numbers with this property.

d4 % 2 == 0
(d3 + d4 + d5) % 3 == 0
d6 = 5 ou d6 = 0
(d5 * 100 + d6 * 10 + d7  ) % 7 == 0
(d6 * 100 + d7 * 10 + d8  ) % 11 == 0
(d7 * 100 + d8 * 10 + d9  ) % 13 == 0
(d8 * 100 + d9 * 10 + d10 ) % 17 == 0


d4 % 2 == 0
d6 = 5 ou d6 = 0

(d3 + d4 + d5) % 3 == 0
(d5 * 2 + d6 * 3 + d7) % 7 == 0
--]]
local allowed = {}
for i = 0, 9 do
    allowed[i + 1] = true
end
for i6 = 0, 1 do
    local d6 = i6 * 5
    if allowed[d6 + 1] then
        allowed[d6 + 1] = false
        for d7 = 0, 9 do
            if allowed[d7 + 1] then
                allowed[d7 + 1] = false
                for d8 = 0, 9 do
                    if allowed[d8 + 1] then
                        allowed[d8 + 1] = false
                        for d9 = 0, 9 do
                            if allowed[d9 + 1] then
                                allowed[d9 + 1] = false
                                for d10 = 1, 9 do
                                    if allowed[d10 + 1] and math.fmod(d6 * 100 + d7 * 10 + d8, 11) == 0 and math.fmod(d7 * 100 + d8 * 10 + d9, 13) == 0 and math.fmod(d8 * 100 + d9 * 10 + d10, 17) == 0 then
                                        allowed[d10 + 1] = false
                                        for d5 = 0, 9 do
                                            if allowed[d5 + 1] then
                                                allowed[d5 + 1] = false
                                                if math.fmod(d5 * 100 + d6 * 10 + d7, 7) == 0 then
                                                    for i4 = 0, 4 do
                                                        local d4 = i4 * 2
                                                        if allowed[d4 + 1] then
                                                            allowed[d4 + 1] = false
                                                            for d3 = 0, 9 do
                                                                if allowed[d3 + 1] then
                                                                    allowed[d3 + 1] = false
                                                                    if math.fmod(d3 + d4 + d5, 3) == 0 then
                                                                        for d2 = 0, 9 do
                                                                            if allowed[d2 + 1] then
                                                                                allowed[d2 + 1] = false
                                                                                for d1 = 0, 9 do
                                                                                if allowed[d1 + 1] then
                                                                                allowed[d1 + 1] = false
                                                                                io.write(string.format("%d%d%d%d%d%d%d%d%d%d + ", d1, d2, d3, d4, d5, d6, d7, d8, d9, d10))
                                                                                allowed[d1 + 1] = true
                                                                                end
                                                                                end
                                                                                allowed[d2 + 1] = true
                                                                            end
                                                                        end
                                                                    end
                                                                    allowed[d3 + 1] = true
                                                                end
                                                            end
                                                            allowed[d4 + 1] = true
                                                        end
                                                    end
                                                end
                                                allowed[d5 + 1] = true
                                            end
                                        end
                                        allowed[d10 + 1] = true
                                    end
                                end
                                allowed[d9 + 1] = true
                            end
                        end
                        allowed[d8 + 1] = true
                    end
                end
                allowed[d7 + 1] = true
            end
        end
        allowed[d6 + 1] = true
    end
end
io.write(string.format("%d\n", 0))

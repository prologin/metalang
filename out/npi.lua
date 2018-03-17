buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([%-%d]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end
function readchar()
    if buffer == "" then buffer = io.read("*line") end
    local c = string.byte(buffer)
    buffer = string.sub(buffer, 2, -1)
    return c
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
function is_number (c)
  return c <= 57 and c >= 48
end

--[[
Notation polonaise inversée, ce test permet d'évaluer une expression écrite en NPI
--]]

function npi0 (str, len)
  local stack = {}
  for i = 0, len - 1 do
      stack[i + 1] = 0
  end
  local ptrStack = 0
  local ptrStr = 0
  while ptrStr < len do
      if str[ptrStr + 1] == 32 then
          ptrStr = ptrStr + 1
      elseif is_number(str[ptrStr + 1]) then
          local num = 0
          while str[ptrStr + 1] ~= 32 do
              num = num * 10 + str[ptrStr + 1] - 48
              ptrStr = ptrStr + 1
          end
          stack[ptrStack + 1] = num
          ptrStack = ptrStack + 1
      elseif str[ptrStr + 1] == 43 then
          stack[ptrStack - 1] = stack[ptrStack - 1] + stack[ptrStack]
          ptrStack = ptrStack - 1
          ptrStr = ptrStr + 1
      end
  end
  return stack[1]
end

local len = 0
len = readint()
stdinsep()
local tab = {}
for i = 0, len - 1 do
    local tmp = 0
    tmp = readchar()
    tab[i + 1] = tmp
end
local result = npi0(tab, len)
io.write(result)

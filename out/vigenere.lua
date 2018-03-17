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
function position_alphabet (c)
  local i = c
  if i <= 90 and i >= 65 then
      return i - 65
  elseif i <= 122 and i >= 97 then
      return i - 97
  else 
      return -1
  end
end

function of_position_alphabet (c)
  return c + 97
end

function crypte (taille_cle, cle, taille, message)
  for i = 0, taille - 1 do
      local lettre = position_alphabet(message[i + 1])
      if lettre ~= -1 then
          local addon = position_alphabet(cle[math.fmod(i, taille_cle) + 1])
          local new0 = math.fmod(addon + lettre, 26)
          message[i + 1] = of_position_alphabet(new0)
      end
  end
end

local taille_cle = readint()
stdinsep()
local cle = {}
for index = 0, taille_cle - 1 do
    local out0 = readchar()
    cle[index + 1] = out0
end
stdinsep()
local taille = readint()
stdinsep()
local message = {}
for index2 = 0, taille - 1 do
    local out2 = readchar()
    message[index2 + 1] = out2
end
crypte(taille_cle, cle, taille, message)
for i = 0, taille - 1 do
    io.write(string.format("%c", message[i + 1]))
end
io.write("\n")

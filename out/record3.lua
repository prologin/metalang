buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([%-%d]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end

function stdinsep()
    if buffer == "" then buffer = io.read("*line") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%s*', "") end
end
function mktoto (v1)
  local t = {foo=v1, bar=0, blah=0}
  return t
end

function result (t, len)
  local out0 = 0
  for j = 0, len - 1 do
      t[j + 1].blah = t[j + 1].blah + 1
      out0 = out0 + t[j + 1].foo + t[j + 1].blah * t[j + 1].bar + t[j + 1].bar * t[j + 1].foo
  end
  return out0
end

local t = {}
for i = 0, 3 do
    t[i + 1] = mktoto(i)
end
t[1].bar = readint()
stdinsep()
t[2].blah = readint()
local titi = result(t, 4)
io.write(string.format("%d%d", titi, t[3].blah))

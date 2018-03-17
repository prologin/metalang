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
--[[
Ce test permet de vérifier que l'implémentation de l'affectation fonctionne correctement
--]]

function mktoto (v1)
  local t = {foo=v1, bar=v1, blah=v1}
  return t
end

function mktoto2 (v1)
  local t = {foo=v1 + 3, bar=v1 + 2, blah=v1 + 1}
  return t
end

function result (t_, t2_)
  local t = t_
  local t2 = t2_
  local t3 = {foo=0, bar=0, blah=0}
  t3 = t2
  t = t2
  t2 = t3
  t.blah = t.blah + 1
  local len = 1
  local cache0 = {}
  for i = 0, len - 1 do
      cache0[i + 1] = -i
  end
  local cache1 = {}
  for j = 0, len - 1 do
      cache1[j + 1] = j
  end
  local cache2 = cache0
  cache0 = cache1
  cache2 = cache0
  return t.foo + t.blah * t.bar + t.bar * t.foo
end

local t = mktoto(4)
local t2 = mktoto(5)
t.bar = readint()
stdinsep()
t.blah = readint()
stdinsep()
t2.bar = readint()
stdinsep()
t2.blah = readint()
io.write(string.format("%d%d", result(t, t2), t.blah))

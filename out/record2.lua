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

function result (t)
  t.blah = t.blah + 1
  return t.foo + t.blah * t.bar + t.bar * t.foo
end

local t = mktoto(4)
t.bar = readint()
stdinsep()
t.blah = readint()
io.write(result(t))

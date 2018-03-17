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
function nbPassePartout (n, passepartout, m, serrures)
  local max_ancient = 0
  local max_recent = 0
  for i = 0, m - 1 do
      if serrures[i + 1][1] == -1 and serrures[i + 1][2] > max_ancient then
          max_ancient = serrures[i + 1][2]
      end
      if serrures[i + 1][1] == 1 and serrures[i + 1][2] > max_recent then
          max_recent = serrures[i + 1][2]
      end
  end
  local max_ancient_pp = 0
  local max_recent_pp = 0
  for i = 0, n - 1 do
      local pp = passepartout[i + 1]
      if pp[1] >= max_ancient and pp[2] >= max_recent then
          return 1
      end
      max_ancient_pp = math.max(max_ancient_pp, pp[1])
      max_recent_pp = math.max(max_recent_pp, pp[2])
  end
  if max_ancient_pp >= max_ancient and max_recent_pp >= max_recent then
      return 2
  else 
      return 0
  end
end

local n = readint()
stdinsep()
local passepartout = {}
for i = 0, n - 1 do
    local out0 = {}
    for j = 0, 1 do
        local out01 = readint()
        stdinsep()
        out0[j + 1] = out01
    end
    passepartout[i + 1] = out0
end
local m = readint()
stdinsep()
local serrures = {}
for k = 0, m - 1 do
    local out1 = {}
    for l = 0, 1 do
        local out_ = readint()
        stdinsep()
        out1[l + 1] = out_
    end
    serrures[k + 1] = out1
end
io.write(nbPassePartout(n, passepartout, m, serrures))

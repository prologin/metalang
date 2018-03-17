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
function copytab (tab, len)
  local o = {}
  for i = 0, len - 1 do
      o[i + 1] = tab[i + 1]
  end
  return o
end

function bubblesort (tab, len)
  for i = 0, len - 1 do
      for j = i + 1, len - 1 do
          if tab[i + 1] > tab[j + 1] then
              local tmp = tab[i + 1]
              tab[i + 1] = tab[j + 1]
              tab[j + 1] = tmp
          end
      end
  end
end

function qsort0 (tab, len, i, j)
  if i < j then
      local i0 = i
      local j0 = j
      --[[ pivot : tab[0] --]]
      while i ~= j do
          if tab[i + 1] > tab[j + 1] then
              if i == j - 1 then
                  --[[ on inverse simplement--]]
                  local tmp = tab[i + 1]
                  tab[i + 1] = tab[j + 1]
                  tab[j + 1] = tmp
                  i = i + 1
              else 
                  --[[ on place tab[i+1] à la place de tab[j], tab[j] à la place de tab[i] et tab[i] à la place de tab[i+1] --]]
                  local tmp = tab[i + 1]
                  tab[i + 1] = tab[j + 1]
                  tab[j + 1] = tab[i + 2]
                  tab[i + 2] = tmp
                  i = i + 1
              end
          else 
              j = j - 1
          end
      end
      qsort0(tab, len, i0, i - 1)
      qsort0(tab, len, i + 1, j0)
  end
end

local len = 2
len = readint()
stdinsep()
local tab = {}
for i_ = 0, len - 1 do
    local tmp = 0
    tmp = readint()
    stdinsep()
    tab[i_ + 1] = tmp
end
local tab2 = copytab(tab, len)
bubblesort(tab2, len)
for i = 0, len - 1 do
    io.write(string.format("%d ", tab2[i + 1]))
end
io.write("\n")
local tab3 = copytab(tab, len)
qsort0(tab3, len, 0, len - 1)
for i = 0, len - 1 do
    io.write(string.format("%d ", tab3[i + 1]))
end
io.write("\n")

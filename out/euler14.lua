

function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end

buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([\-0-9]*)(.*)')
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



function next0( n )
  if (math.mod(n, 2)) == 0
  then
    return trunc(n / 2)
  else
    return 3 * n + 1
  end
end

function find( n, m )
  if n == 1 then
    return 1
  elseif n >= 1000000 then
    return 1 + find(next0(n), m)
  elseif m[n] ~= 0
  then
    return m[n]
  else
    m[n] = 1 + find(next0(n), m);
    return m[n]
  end
end


local m = {}
for j = 0,1000000 - 1 do
m[j] = 0;
  end
  local max0 = 0
  local maxi = 0
  for i = 1,999 do
  --[[ normalement on met 999999 mais ça dépasse les int32... --]]
    local n2 = find(i, m)
    if n2 > max0
    then
      max0 = n2;
      maxi = i;
    end
    end
    io.write(string.format("%d\n%d\n", max0, maxi))
    
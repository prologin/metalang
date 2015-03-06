

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



function periode( restes, len, a, b )
  while a ~= 0
  do
  local chiffre = trunc(a / b)
  local reste = math.mod(a, b)
  for i = 0,len - 1 do
  if restes[i] == reste
    then
      return len - i
    end
    end
    restes[len] = reste;
    len = len + 1;
    a = reste * 10;
  end
  return 0
  end
  
  
  local t = {}
  for j = 0,1000 - 1 do
  t[j] = 0;
    end
    local m = 0
    local mi = 0
    for i = 1,1000 do
    local p = periode(t, 0, 1, i)
      if p > m
      then
        mi = i;
        m = p;
      end
      end
      io.write(string.format("%d\n%d\n", mi, m))
      
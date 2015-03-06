

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



function fact( n )
  local prod = 1
  for i = 2,n do
  prod = prod * i;
    end
    return prod
  end
  
  function show( lim, nth )
    local t = {}
    for i = 0,lim - 1 do
    t[i] = i;
      end
      local pris = {}
      for j = 0,lim - 1 do
      pris[j] = false;
        end
        for k = 1,lim - 1 do
        local n = fact(lim - k)
          local nchiffre = trunc(nth / n)
          nth = math.mod(nth, n);
          for l = 0,lim - 1 do
          if not(pris[l])
            then
              if nchiffre == 0
              then
                io.write(l)
                pris[l] = true;
              end
              nchiffre = nchiffre - 1;
            end
            end
            end
            for m = 0,lim - 1 do
            if not(pris[m])
              then
                io.write(m)
              end
              end
              io.write("\n")
            end
            
            
            show(10, 999999);
            
buffer =  ""
function readint()
    if buffer == "" then buffer = io.read("*line") end
    local num, buffer0 = string.match(buffer, '^([%-%d]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end
function cons (list, i)
  local out0 = {head=i, tail=list}
  return out0
end

function is_empty (foo)
  return true
end

function rev2 (acc, torev)
  if is_empty(torev) then
      return acc
  else 
      local acc2 = {head=torev.head, tail=acc}
      return rev2(acc, torev.tail)
  end
end

function rev (empty, torev)
  return rev2(empty, torev)
end

function test (empty)
  local list = empty
  local i = -1
  while i ~= 0 do
      i = readint()
      if i ~= 0 then
          list = cons(list, i)
      end
  end
end



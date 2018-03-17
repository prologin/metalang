function is_pair (i)
  local j = 1
  if i < 10 then
      j = 2
      if i == 0 then
          j = 4
          return true
      end
      j = 3
      if i == 2 then
          j = 4
          return true
      end
      j = 5
  end
  j = 6
  if i < 20 then
      if i == 22 then
          j = 0
      end
      j = 8
  end
  return math.fmod(i, 2) == 0
end



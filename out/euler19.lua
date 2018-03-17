function is_leap (year)
  return math.fmod(year, 400) == 0 or math.fmod(year, 100) ~= 0 and math.fmod(year, 4) == 0
end

function ndayinmonth (month, year)
  if month == 0 then
      return 31
  elseif month == 1 then
      if is_leap(year) then
          return 29
      else 
          return 28
      end
  elseif month == 2 then
      return 31
  elseif month == 3 then
      return 30
  elseif month == 4 then
      return 31
  elseif month == 5 then
      return 30
  elseif month == 6 then
      return 31
  elseif month == 7 then
      return 31
  elseif month == 8 then
      return 30
  elseif month == 9 then
      return 31
  elseif month == 10 then
      return 30
  elseif month == 11 then
      return 31
  end
  return 0
end

local month = 0
local year = 1901
local dayofweek = 1
--[[ 01-01-1901 : mardi --]]
local count = 0
while year ~= 2001 do
    local ndays = ndayinmonth(month, year)
    dayofweek = math.fmod(dayofweek + ndays, 7)
    month = month + 1
    if month == 12 then
        month = 0
        year = year + 1
    end
    if math.fmod(dayofweek, 7) == 6 then
        count = count + 1
    end
end
io.write(string.format("%d\n", count))

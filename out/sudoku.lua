
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end
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
--[[ lit un sudoku sur l'entrée standard --]]

function read_sudoku ()
  local out0 = {}
  for i = 0, 9 * 9 - 1 do
      local k = readint()
      stdinsep()
      out0[i + 1] = k
  end
  return out0
end

--[[ affiche un sudoku --]]

function print_sudoku (sudoku0)
  for y = 0, 8 do
      for x = 0, 8 do
          io.write(string.format("%d ", sudoku0[x + y * 9 + 1]))
          if math.fmod(x, 3) == 2 then
              io.write(" ")
          end
      end
      io.write("\n")
      if math.fmod(y, 3) == 2 then
          io.write("\n")
      end
  end
  io.write("\n")
end

--[[ dit si les variables sont toutes différentes --]]

--[[ dit si les variables sont toutes différentes --]]

--[[ dit si le sudoku est terminé de remplir --]]

function sudoku_done (s)
  for i = 0, 80 do
      if s[i + 1] == 0 then
          return false
      end
  end
  return true
end

--[[ dit si il y a une erreur dans le sudoku --]]

function sudoku_error (s)
  local out1 = false
  for x = 0, 8 do
      out1 = out1 or s[x + 1] ~= 0 and s[x + 1] == s[x + 10] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 2 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 2 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 3 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 3 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 3 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 4 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 4 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 4 + 1] or s[x + 9 * 3 + 1] ~= 0 and s[x + 9 * 3 + 1] == s[x + 9 * 4 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 5 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 5 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 5 + 1] or s[x + 9 * 3 + 1] ~= 0 and s[x + 9 * 3 + 1] == s[x + 9 * 5 + 1] or s[x + 9 * 4 + 1] ~= 0 and s[x + 9 * 4 + 1] == s[x + 9 * 5 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 6 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 6 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 6 + 1] or s[x + 9 * 3 + 1] ~= 0 and s[x + 9 * 3 + 1] == s[x + 9 * 6 + 1] or s[x + 9 * 4 + 1] ~= 0 and s[x + 9 * 4 + 1] == s[x + 9 * 6 + 1] or s[x + 9 * 5 + 1] ~= 0 and s[x + 9 * 5 + 1] == s[x + 9 * 6 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 7 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 7 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 7 + 1] or s[x + 9 * 3 + 1] ~= 0 and s[x + 9 * 3 + 1] == s[x + 9 * 7 + 1] or s[x + 9 * 4 + 1] ~= 0 and s[x + 9 * 4 + 1] == s[x + 9 * 7 + 1] or s[x + 9 * 5 + 1] ~= 0 and s[x + 9 * 5 + 1] == s[x + 9 * 7 + 1] or s[x + 9 * 6 + 1] ~= 0 and s[x + 9 * 6 + 1] == s[x + 9 * 7 + 1] or s[x + 1] ~= 0 and s[x + 1] == s[x + 9 * 8 + 1] or s[x + 10] ~= 0 and s[x + 10] == s[x + 9 * 8 + 1] or s[x + 9 * 2 + 1] ~= 0 and s[x + 9 * 2 + 1] == s[x + 9 * 8 + 1] or s[x + 9 * 3 + 1] ~= 0 and s[x + 9 * 3 + 1] == s[x + 9 * 8 + 1] or s[x + 9 * 4 + 1] ~= 0 and s[x + 9 * 4 + 1] == s[x + 9 * 8 + 1] or s[x + 9 * 5 + 1] ~= 0 and s[x + 9 * 5 + 1] == s[x + 9 * 8 + 1] or s[x + 9 * 6 + 1] ~= 0 and s[x + 9 * 6 + 1] == s[x + 9 * 8 + 1] or s[x + 9 * 7 + 1] ~= 0 and s[x + 9 * 7 + 1] == s[x + 9 * 8 + 1]
  end
  local out2 = false
  for x = 0, 8 do
      out2 = out2 or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 2] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 3] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 3] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 4] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 4] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 4] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 5] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 5] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 5] or s[x * 9 + 4] ~= 0 and s[x * 9 + 4] == s[x * 9 + 5] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 6] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 6] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 6] or s[x * 9 + 4] ~= 0 and s[x * 9 + 4] == s[x * 9 + 6] or s[x * 9 + 5] ~= 0 and s[x * 9 + 5] == s[x * 9 + 6] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 7] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 7] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 7] or s[x * 9 + 4] ~= 0 and s[x * 9 + 4] == s[x * 9 + 7] or s[x * 9 + 5] ~= 0 and s[x * 9 + 5] == s[x * 9 + 7] or s[x * 9 + 6] ~= 0 and s[x * 9 + 6] == s[x * 9 + 7] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 8] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 8] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 8] or s[x * 9 + 4] ~= 0 and s[x * 9 + 4] == s[x * 9 + 8] or s[x * 9 + 5] ~= 0 and s[x * 9 + 5] == s[x * 9 + 8] or s[x * 9 + 6] ~= 0 and s[x * 9 + 6] == s[x * 9 + 8] or s[x * 9 + 7] ~= 0 and s[x * 9 + 7] == s[x * 9 + 8] or s[x * 9 + 1] ~= 0 and s[x * 9 + 1] == s[x * 9 + 9] or s[x * 9 + 2] ~= 0 and s[x * 9 + 2] == s[x * 9 + 9] or s[x * 9 + 3] ~= 0 and s[x * 9 + 3] == s[x * 9 + 9] or s[x * 9 + 4] ~= 0 and s[x * 9 + 4] == s[x * 9 + 9] or s[x * 9 + 5] ~= 0 and s[x * 9 + 5] == s[x * 9 + 9] or s[x * 9 + 6] ~= 0 and s[x * 9 + 6] == s[x * 9 + 9] or s[x * 9 + 7] ~= 0 and s[x * 9 + 7] == s[x * 9 + 9] or s[x * 9 + 8] ~= 0 and s[x * 9 + 8] == s[x * 9 + 9]
  end
  local out3 = false
  for x = 0, 8 do
      out3 = out3 or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[math.fmod(x, 3) * 3 * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] ~= 0 and s[(math.fmod(x, 3) * 3 + 1) * 9 + trunc(x / 3) * 3 + 3] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] ~= 0 and s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 1] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3] or s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] ~= 0 and s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 2] == s[(math.fmod(x, 3) * 3 + 2) * 9 + trunc(x / 3) * 3 + 3]
  end
  return out1 or out2 or out3
end

--[[ résout le sudoku--]]

function solve (sudoku0)
  if sudoku_error(sudoku0) then
      return false
  end
  if sudoku_done(sudoku0) then
      return true
  end
  for i = 0, 80 do
      if sudoku0[i + 1] == 0 then
          for p = 1, 9 do
              sudoku0[i + 1] = p
              if solve(sudoku0) then
                  return true
              end
          end
          sudoku0[i + 1] = 0
          return false
      end
  end
  return false
end

local sudoku0 = read_sudoku()
print_sudoku(sudoku0)
if solve(sudoku0) then
    print_sudoku(sudoku0)
else 
    io.write("no solution\n")
end

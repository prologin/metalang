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
--[[
Tictactoe : un tictactoe avec une IA
--]]

--[[ La structure de donnée --]]

--[[ Un Mouvement --]]

--[[ On affiche l'état --]]

function print_state (g)
  io.write("\n|")
  for y = 0, 2 do
      for x = 0, 2 do
          if g.cases[x + 1][y + 1] == 0 then
              io.write(" ")
          elseif g.cases[x + 1][y + 1] == 1 then
              io.write("O")
          else 
              io.write("X")
          end
          io.write("|")
      end
      if y ~= 2 then
          io.write("\n|-|-|-|\n|")
      end
  end
  io.write("\n")
end

--[[ On dit qui gagne (info stoquées dans g.ended et g.note ) --]]

function eval0 (g)
  local win = 0
  local freecase = 0
  for y = 0, 2 do
      local col = -1
      local lin = -1
      for x = 0, 2 do
          if g.cases[x + 1][y + 1] == 0 then
              freecase = freecase + 1
          end
          local colv = g.cases[x + 1][y + 1]
          local linv = g.cases[y + 1][x + 1]
          if col == -1 and colv ~= 0 then
              col = colv
          elseif colv ~= col then
              col = -2
          end
          if lin == -1 and linv ~= 0 then
              lin = linv
          elseif linv ~= lin then
              lin = -2
          end
      end
      if col >= 0 then
          win = col
      elseif lin >= 0 then
          win = lin
      end
  end
  for x = 1, 2 do
      if g.cases[1][1] == x and g.cases[2][2] == x and g.cases[3][3] == x then
          win = x
      end
      if g.cases[1][3] == x and g.cases[2][2] == x and g.cases[3][1] == x then
          win = x
      end
  end
  g.ended = win ~= 0 or freecase == 0
  if win == 1 then
      g.note = 1000
  elseif win == 2 then
      g.note = -1000
  else 
      g.note = 0
  end
end

--[[ On applique un mouvement --]]

function apply_move_xy (x, y, g)
  local player = 2
  if g.firstToPlay then
      player = 1
  end
  g.cases[x + 1][y + 1] = player
  g.firstToPlay = not(g.firstToPlay)
end

function apply_move (m, g)
  apply_move_xy(m.x, m.y, g)
end

function cancel_move_xy (x, y, g)
  g.cases[x + 1][y + 1] = 0
  g.firstToPlay = not(g.firstToPlay)
  g.ended = false
end

function cancel_move (m, g)
  cancel_move_xy(m.x, m.y, g)
end

function can_move_xy (x, y, g)
  return g.cases[x + 1][y + 1] == 0
end

function can_move (m, g)
  return can_move_xy(m.x, m.y, g)
end

--[[
Un minimax classique, renvoie la note du plateau
--]]

function minmax (g)
  eval0(g)
  if g.ended then
      return g.note
  end
  local maxNote = -10000
  if not(g.firstToPlay) then
      maxNote = 10000
  end
  for x = 0, 2 do
      for y = 0, 2 do
          if can_move_xy(x, y, g) then
              apply_move_xy(x, y, g)
              local currentNote = minmax(g)
              cancel_move_xy(x, y, g)
              --[[ Minimum ou Maximum selon le coté ou l'on joue--]]
              if currentNote > maxNote == g.firstToPlay then
                  maxNote = currentNote
              end
          end
      end
  end
  return maxNote
end

--[[
Renvoie le coup de l'IA
--]]

function play (g)
  local minMove = {x=0, y=0}
  local minNote = 10000
  for x = 0, 2 do
      for y = 0, 2 do
          if can_move_xy(x, y, g) then
              apply_move_xy(x, y, g)
              local currentNote = minmax(g)
              io.write(string.format("%d, %d, %d\n", x, y, currentNote))
              cancel_move_xy(x, y, g)
              if currentNote < minNote then
                  minNote = currentNote
                  minMove.x = x
                  minMove.y = y
              end
          end
      end
  end
  io.write(string.format("%d%d\n", minMove.x, minMove.y))
  return minMove
end

function init0 ()
  local cases = {}
  for i = 0, 2 do
      local tab = {}
      for j = 0, 2 do
          tab[j + 1] = 0
      end
      cases[i + 1] = tab
  end
  return {cases=cases, firstToPlay=true, note=0, ended=false}
end

function read_move ()
  local x = readint()
  stdinsep()
  local y = readint()
  stdinsep()
  return {x=x, y=y}
end

for i = 0, 1 do
    local state = init0()
    apply_move({x=1, y=1}, state)
    apply_move({x=0, y=0}, state)
    while not(state.ended) do
        print_state(state)
        apply_move(play(state), state)
        eval0(state)
        print_state(state)
        if not(state.ended) then
            apply_move(play(state), state)
            eval0(state)
        end
    end
    print_state(state)
    io.write(string.format("%d\n", state.note))
end

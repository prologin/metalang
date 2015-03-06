

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


--[[ lit un sudoku sur l'entrée standard --]]
function read_sudoku(  )
  local out0 = {}
  for i = 0,9 * 9 - 1 do
  local k = readint()
    stdinsep()
    out0[i] = k;
    end
    return out0
  end
  
  --[[ affiche un sudoku --]]
  function print_sudoku( sudoku0 )
    for y = 0,8 do
    for x = 0,8 do
    io.write(string.format("%d ", sudoku0[x + y * 9]))
      if (math.mod(x, 3)) == 2
      then
        io.write(" ")
      end
      end
      io.write("\n")
      if (math.mod(y, 3)) == 2
      then
        io.write("\n")
      end
      end
      io.write("\n")
      end
      
      --[[ dit si les variables sont toutes différentes --]]
      --[[ dit si les variables sont toutes différentes --]]
      --[[ dit si le sudoku est terminé de remplir --]]
      function sudoku_done( s )
        for i = 0,80 do
        if s[i] == 0
          then
            return false
          end
          end
          return true
        end
        
        --[[ dit si il y a une erreur dans le sudoku --]]
        --[[ résout le sudoku--]]
        function solve( sudoku0 )
          if false or (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[9]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[18]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[18]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[27]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[27]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[27]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[36]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[36]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[36]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[36]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[45]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[45]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[45]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[45]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[45]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[54]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[54]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[54]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[54]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[54]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[54]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[63]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[63]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[63]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[63]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[63]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[63]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[63]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[72]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[72]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[72]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[72]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[72]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[72]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[72]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[72]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[10]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[19]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[19]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[28]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[28]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[28]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[37]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[37]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[37]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[37]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[46]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[46]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[46]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[46]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[46]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[55]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[55]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[55]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[55]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[55]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[55]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[64]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[64]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[64]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[64]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[64]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[64]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[64]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[73]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[73]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[73]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[73]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[73]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[73]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[73]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[73]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[11]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[20]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[20]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[29]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[29]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[29]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[38]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[38]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[38]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[38]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[47]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[47]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[47]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[47]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[47]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[56]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[56]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[56]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[56]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[56]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[56]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[65]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[65]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[65]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[65]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[65]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[65]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[65]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[74]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[74]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[74]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[74]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[74]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[74]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[74]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[74]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[12]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[21]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[21]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[30]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[30]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[30]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[39]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[39]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[39]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[39]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[48]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[48]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[48]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[48]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[48]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[57]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[57]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[57]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[57]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[57]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[57]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[66]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[66]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[66]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[66]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[66]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[66]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[66]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[75]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[75]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[75]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[75]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[75]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[75]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[75]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[75]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[13]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[22]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[22]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[31]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[31]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[31]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[40]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[40]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[40]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[40]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[49]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[49]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[49]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[49]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[49]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[58]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[58]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[58]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[58]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[58]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[58]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[67]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[67]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[67]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[67]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[67]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[67]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[67]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[76]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[76]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[76]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[76]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[76]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[76]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[76]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[76]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[14]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[23]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[23]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[32]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[32]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[32]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[41]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[41]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[41]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[41]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[50]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[50]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[50]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[50]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[50]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[59]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[59]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[59]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[59]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[59]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[59]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[68]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[68]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[68]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[68]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[68]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[68]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[68]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[77]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[77]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[77]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[77]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[77]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[77]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[77]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[77]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[15]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[24]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[24]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[33]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[33]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[33]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[42]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[42]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[42]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[42]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[51]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[51]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[51]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[51]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[51]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[60]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[60]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[60]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[60]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[60]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[60]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[69]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[69]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[69]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[69]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[69]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[69]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[69]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[78]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[78]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[78]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[78]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[78]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[78]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[78]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[78]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[16]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[25]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[25]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[34]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[34]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[34]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[43]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[43]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[43]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[43]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[52]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[52]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[52]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[52]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[52]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[61]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[61]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[61]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[61]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[61]) or
          (sudoku0[52] ~= 0 and sudoku0[52] == sudoku0[61]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[70]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[70]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[70]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[70]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[70]) or
          (sudoku0[52] ~= 0 and sudoku0[52] == sudoku0[70]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[70]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[79]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[79]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[79]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[79]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[79]) or
          (sudoku0[52] ~= 0 and sudoku0[52] == sudoku0[79]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[79]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[79]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[17]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[26]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[26]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[35]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[35]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[35]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[44]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[44]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[44]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[44]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[53]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[53]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[53]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[53]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[53]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[62]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[62]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[62]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[62]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[62]) or
          (sudoku0[53] ~= 0 and sudoku0[53] == sudoku0[62]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[71]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[71]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[71]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[71]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[71]) or
          (sudoku0[53] ~= 0 and sudoku0[53] == sudoku0[71]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[71]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[80]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[80]) or
          (sudoku0[26] ~= 0 and sudoku0[26] == sudoku0[80]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[80]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[80]) or
          (sudoku0[53] ~= 0 and sudoku0[53] == sudoku0[80]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[80]) or
          (sudoku0[71] ~= 0 and sudoku0[71] == sudoku0[80]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[1]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[2]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[2]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[3]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[3]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[3]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[4]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[4]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[4]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[4]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[5]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[5]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[5]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[5]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[5]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[6]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[6]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[6]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[6]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[6]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[6]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[7]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[7]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[7]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[7]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[7]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[7]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[7]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[8]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[8]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[8]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[8]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[8]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[8]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[8]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[8]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[10]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[11]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[11]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[12]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[12]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[12]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[13]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[13]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[13]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[13]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[14]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[14]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[14]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[14]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[14]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[15]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[15]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[15]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[15]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[15]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[15]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[16]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[16]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[16]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[16]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[16]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[16]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[16]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[17]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[17]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[17]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[17]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[17]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[17]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[17]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[17]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[19]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[20]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[20]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[21]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[21]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[21]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[22]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[22]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[22]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[22]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[23]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[23]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[23]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[23]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[23]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[24]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[24]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[24]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[24]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[24]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[24]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[25]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[25]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[25]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[25]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[25]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[25]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[25]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[26]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[26]) or
          (sudoku0[20] ~= 0 and sudoku0[20] == sudoku0[26]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[26]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[26]) or
          (sudoku0[23] ~= 0 and sudoku0[23] == sudoku0[26]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[26]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[26]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[28]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[29]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[29]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[30]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[30]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[30]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[31]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[31]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[31]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[31]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[32]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[32]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[32]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[32]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[32]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[33]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[33]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[33]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[33]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[33]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[33]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[34]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[34]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[34]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[34]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[34]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[34]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[34]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[35]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[35]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[35]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[35]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[35]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[35]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[35]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[35]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[37]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[38]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[38]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[39]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[39]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[39]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[40]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[40]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[40]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[40]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[41]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[41]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[41]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[41]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[41]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[42]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[42]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[42]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[42]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[42]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[42]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[43]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[43]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[43]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[43]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[43]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[43]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[43]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[44]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[44]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[44]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[44]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[44]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[44]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[44]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[44]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[46]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[47]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[47]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[48]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[48]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[48]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[49]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[49]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[49]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[49]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[50]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[50]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[50]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[50]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[50]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[51]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[51]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[51]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[51]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[51]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[51]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[52]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[52]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[52]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[52]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[52]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[52]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[52]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[53]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[53]) or
          (sudoku0[47] ~= 0 and sudoku0[47] == sudoku0[53]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[53]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[53]) or
          (sudoku0[50] ~= 0 and sudoku0[50] == sudoku0[53]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[53]) or
          (sudoku0[52] ~= 0 and sudoku0[52] == sudoku0[53]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[55]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[56]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[56]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[57]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[57]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[57]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[58]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[58]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[58]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[58]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[59]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[59]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[59]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[59]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[59]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[60]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[60]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[60]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[60]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[60]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[60]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[61]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[61]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[61]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[61]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[61]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[61]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[61]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[62]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[62]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[62]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[62]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[62]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[62]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[62]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[62]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[64]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[65]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[65]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[66]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[66]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[66]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[67]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[67]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[67]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[67]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[68]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[68]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[68]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[68]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[68]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[69]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[69]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[69]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[69]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[69]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[69]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[70]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[70]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[70]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[70]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[70]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[70]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[70]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[71]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[71]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[71]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[71]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[71]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[71]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[71]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[71]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[73]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[74]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[74]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[75]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[75]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[75]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[76]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[76]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[76]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[76]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[77]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[77]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[77]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[77]) or
          (sudoku0[76] ~= 0 and sudoku0[76] == sudoku0[77]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[78]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[78]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[78]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[78]) or
          (sudoku0[76] ~= 0 and sudoku0[76] == sudoku0[78]) or
          (sudoku0[77] ~= 0 and sudoku0[77] == sudoku0[78]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[79]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[79]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[79]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[79]) or
          (sudoku0[76] ~= 0 and sudoku0[76] == sudoku0[79]) or
          (sudoku0[77] ~= 0 and sudoku0[77] == sudoku0[79]) or
          (sudoku0[78] ~= 0 and sudoku0[78] == sudoku0[79]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[80]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[80]) or
          (sudoku0[74] ~= 0 and sudoku0[74] == sudoku0[80]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[80]) or
          (sudoku0[76] ~= 0 and sudoku0[76] == sudoku0[80]) or
          (sudoku0[77] ~= 0 and sudoku0[77] == sudoku0[80]) or
          (sudoku0[78] ~= 0 and sudoku0[78] == sudoku0[80]) or
          (sudoku0[79] ~= 0 and sudoku0[79] == sudoku0[80]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[1]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[2]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[2]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[9]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[9]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[9]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[10]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[10]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[10]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[10]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[11]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[11]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[11]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[11]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[11]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[18]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[18]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[18]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[18]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[18]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[18]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[19]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[19]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[19]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[19]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[19]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[19]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[19]) or
          (sudoku0[0] ~= 0 and sudoku0[0] == sudoku0[20]) or
          (sudoku0[1] ~= 0 and sudoku0[1] == sudoku0[20]) or
          (sudoku0[2] ~= 0 and sudoku0[2] == sudoku0[20]) or
          (sudoku0[9] ~= 0 and sudoku0[9] == sudoku0[20]) or
          (sudoku0[10] ~= 0 and sudoku0[10] == sudoku0[20]) or
          (sudoku0[11] ~= 0 and sudoku0[11] == sudoku0[20]) or
          (sudoku0[18] ~= 0 and sudoku0[18] == sudoku0[20]) or
          (sudoku0[19] ~= 0 and sudoku0[19] == sudoku0[20]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[28]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[29]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[29]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[36]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[36]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[36]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[37]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[37]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[37]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[37]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[38]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[38]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[38]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[38]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[38]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[45]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[45]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[45]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[45]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[45]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[45]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[46]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[46]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[46]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[46]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[46]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[46]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[46]) or
          (sudoku0[27] ~= 0 and sudoku0[27] == sudoku0[47]) or
          (sudoku0[28] ~= 0 and sudoku0[28] == sudoku0[47]) or
          (sudoku0[29] ~= 0 and sudoku0[29] == sudoku0[47]) or
          (sudoku0[36] ~= 0 and sudoku0[36] == sudoku0[47]) or
          (sudoku0[37] ~= 0 and sudoku0[37] == sudoku0[47]) or
          (sudoku0[38] ~= 0 and sudoku0[38] == sudoku0[47]) or
          (sudoku0[45] ~= 0 and sudoku0[45] == sudoku0[47]) or
          (sudoku0[46] ~= 0 and sudoku0[46] == sudoku0[47]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[55]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[56]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[56]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[63]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[63]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[63]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[64]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[64]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[64]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[64]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[65]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[65]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[65]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[65]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[65]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[72]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[72]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[72]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[72]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[72]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[72]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[73]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[73]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[73]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[73]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[73]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[73]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[73]) or
          (sudoku0[54] ~= 0 and sudoku0[54] == sudoku0[74]) or
          (sudoku0[55] ~= 0 and sudoku0[55] == sudoku0[74]) or
          (sudoku0[56] ~= 0 and sudoku0[56] == sudoku0[74]) or
          (sudoku0[63] ~= 0 and sudoku0[63] == sudoku0[74]) or
          (sudoku0[64] ~= 0 and sudoku0[64] == sudoku0[74]) or
          (sudoku0[65] ~= 0 and sudoku0[65] == sudoku0[74]) or
          (sudoku0[72] ~= 0 and sudoku0[72] == sudoku0[74]) or
          (sudoku0[73] ~= 0 and sudoku0[73] == sudoku0[74]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[4]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[5]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[5]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[12]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[12]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[12]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[13]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[13]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[13]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[13]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[14]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[14]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[14]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[14]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[14]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[21]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[21]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[21]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[21]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[21]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[21]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[22]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[22]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[22]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[22]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[22]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[22]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[22]) or
          (sudoku0[3] ~= 0 and sudoku0[3] == sudoku0[23]) or
          (sudoku0[4] ~= 0 and sudoku0[4] == sudoku0[23]) or
          (sudoku0[5] ~= 0 and sudoku0[5] == sudoku0[23]) or
          (sudoku0[12] ~= 0 and sudoku0[12] == sudoku0[23]) or
          (sudoku0[13] ~= 0 and sudoku0[13] == sudoku0[23]) or
          (sudoku0[14] ~= 0 and sudoku0[14] == sudoku0[23]) or
          (sudoku0[21] ~= 0 and sudoku0[21] == sudoku0[23]) or
          (sudoku0[22] ~= 0 and sudoku0[22] == sudoku0[23]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[31]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[32]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[32]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[39]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[39]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[39]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[40]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[40]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[40]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[40]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[41]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[41]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[41]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[41]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[41]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[48]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[48]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[48]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[48]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[48]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[48]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[49]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[49]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[49]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[49]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[49]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[49]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[49]) or
          (sudoku0[30] ~= 0 and sudoku0[30] == sudoku0[50]) or
          (sudoku0[31] ~= 0 and sudoku0[31] == sudoku0[50]) or
          (sudoku0[32] ~= 0 and sudoku0[32] == sudoku0[50]) or
          (sudoku0[39] ~= 0 and sudoku0[39] == sudoku0[50]) or
          (sudoku0[40] ~= 0 and sudoku0[40] == sudoku0[50]) or
          (sudoku0[41] ~= 0 and sudoku0[41] == sudoku0[50]) or
          (sudoku0[48] ~= 0 and sudoku0[48] == sudoku0[50]) or
          (sudoku0[49] ~= 0 and sudoku0[49] == sudoku0[50]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[58]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[59]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[59]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[66]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[66]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[66]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[67]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[67]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[67]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[67]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[68]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[68]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[68]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[68]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[68]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[75]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[75]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[75]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[75]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[75]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[75]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[76]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[76]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[76]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[76]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[76]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[76]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[76]) or
          (sudoku0[57] ~= 0 and sudoku0[57] == sudoku0[77]) or
          (sudoku0[58] ~= 0 and sudoku0[58] == sudoku0[77]) or
          (sudoku0[59] ~= 0 and sudoku0[59] == sudoku0[77]) or
          (sudoku0[66] ~= 0 and sudoku0[66] == sudoku0[77]) or
          (sudoku0[67] ~= 0 and sudoku0[67] == sudoku0[77]) or
          (sudoku0[68] ~= 0 and sudoku0[68] == sudoku0[77]) or
          (sudoku0[75] ~= 0 and sudoku0[75] == sudoku0[77]) or
          (sudoku0[76] ~= 0 and sudoku0[76] == sudoku0[77]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[7]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[8]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[8]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[15]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[15]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[15]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[16]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[16]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[16]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[16]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[17]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[17]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[17]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[17]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[17]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[24]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[24]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[24]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[24]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[24]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[24]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[25]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[25]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[25]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[25]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[25]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[25]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[25]) or
          (sudoku0[6] ~= 0 and sudoku0[6] == sudoku0[26]) or
          (sudoku0[7] ~= 0 and sudoku0[7] == sudoku0[26]) or
          (sudoku0[8] ~= 0 and sudoku0[8] == sudoku0[26]) or
          (sudoku0[15] ~= 0 and sudoku0[15] == sudoku0[26]) or
          (sudoku0[16] ~= 0 and sudoku0[16] == sudoku0[26]) or
          (sudoku0[17] ~= 0 and sudoku0[17] == sudoku0[26]) or
          (sudoku0[24] ~= 0 and sudoku0[24] == sudoku0[26]) or
          (sudoku0[25] ~= 0 and sudoku0[25] == sudoku0[26]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[34]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[35]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[35]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[42]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[42]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[42]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[43]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[43]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[43]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[43]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[44]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[44]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[44]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[44]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[44]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[51]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[51]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[51]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[51]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[51]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[51]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[52]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[52]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[52]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[52]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[52]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[52]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[52]) or
          (sudoku0[33] ~= 0 and sudoku0[33] == sudoku0[53]) or
          (sudoku0[34] ~= 0 and sudoku0[34] == sudoku0[53]) or
          (sudoku0[35] ~= 0 and sudoku0[35] == sudoku0[53]) or
          (sudoku0[42] ~= 0 and sudoku0[42] == sudoku0[53]) or
          (sudoku0[43] ~= 0 and sudoku0[43] == sudoku0[53]) or
          (sudoku0[44] ~= 0 and sudoku0[44] == sudoku0[53]) or
          (sudoku0[51] ~= 0 and sudoku0[51] == sudoku0[53]) or
          (sudoku0[52] ~= 0 and sudoku0[52] == sudoku0[53]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[61]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[62]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[62]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[69]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[69]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[69]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[70]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[70]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[70]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[70]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[71]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[71]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[71]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[71]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[71]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[78]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[78]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[78]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[78]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[78]) or
          (sudoku0[71] ~= 0 and sudoku0[71] == sudoku0[78]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[79]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[79]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[79]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[79]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[79]) or
          (sudoku0[71] ~= 0 and sudoku0[71] == sudoku0[79]) or
          (sudoku0[78] ~= 0 and sudoku0[78] == sudoku0[79]) or
          (sudoku0[60] ~= 0 and sudoku0[60] == sudoku0[80]) or
          (sudoku0[61] ~= 0 and sudoku0[61] == sudoku0[80]) or
          (sudoku0[62] ~= 0 and sudoku0[62] == sudoku0[80]) or
          (sudoku0[69] ~= 0 and sudoku0[69] == sudoku0[80]) or
          (sudoku0[70] ~= 0 and sudoku0[70] == sudoku0[80]) or
          (sudoku0[71] ~= 0 and sudoku0[71] == sudoku0[80]) or
          (sudoku0[78] ~= 0 and sudoku0[78] == sudoku0[80]) or
          (sudoku0[79] ~= 0 and sudoku0[79] == sudoku0[80])
          then
            return false
          end
          if sudoku_done(sudoku0)
          then
            return true
          end
          for i = 0,80 do
          if sudoku0[i] == 0
            then
              for p = 1,9 do
              sudoku0[i] = p;
                if solve(sudoku0)
                then
                  return true
                end
                end
                sudoku0[i] = 0;
                return false
              end
              end
              return false
            end
            
            
            local sudoku0 = read_sudoku()
            print_sudoku(sudoku0);
            if solve(sudoku0)
            then
              print_sudoku(sudoku0);
            else
              io.write("no solution\n")
            end
            
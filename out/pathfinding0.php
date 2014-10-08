<?php
function pathfind_aux(&$cache, &$tab, $x, $y, $posX, $posY){
  if ($posX == $x - 1 && $posY == $y - 1)
    return 0;
  else if ($posX < 0 || $posY < 0 || $posX >= $x || $posY >= $y)
    return $x * $y * 10;
  else if ($tab[$posY][$posX] == "#")
    return $x * $y * 10;
  else if ($cache[$posY][$posX] != -1)
    return $cache[$posY][$posX];
  else
  {
    $cache[$posY][$posX] = $x * $y * 10;
    $val1 = pathfind_aux($cache, $tab, $x, $y, $posX + 1, $posY);
    $val2 = pathfind_aux($cache, $tab, $x, $y, $posX - 1, $posY);
    $val3 = pathfind_aux($cache, $tab, $x, $y, $posX, $posY - 1);
    $val4 = pathfind_aux($cache, $tab, $x, $y, $posX, $posY + 1);
    $f = min($val1, $val2, $val3, $val4);
    $out0 = 1 + $f;
    $cache[$posY][$posX] = $out0;
    return $out0;
  }
}

function pathfind(&$tab, $x, $y){
  $cache = array();
  for ($i = 0 ; $i < $y; $i++)
  {
    $tmp = array();
    for ($j = 0 ; $j < $x; $j++)
    {
      echo $tab[$i][$j];
      $tmp[$j] = -1;
    }
    echo "\n";
    $cache[$i] = $tmp;
  }
  return pathfind_aux($cache, $tab, $x, $y, 0, 0);
}

$x = intval(trim(fgets(STDIN)));
$y = intval(trim(fgets(STDIN)));
echo $x, " ", $y, "\n";
$l = array();
for ($m = 0 ; $m < $y; $m++)
  $l[$m] = fgets(STDIN);
$tab = $l;
$result = pathfind($tab, $x, $y);
echo $result;
?>

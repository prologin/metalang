<?php
function min2($a, $b){
  if ($a < $b)
  {
    return $a;
  }
  return $b;
}

function min3($a, $b, $c){
  return min2(min2($a, $b), $c);
}

function min4($a, $b, $c, $d){
  return min3(min2($a, $b), $c, $d);
}

function pathfind_aux(&$cache, &$tab, $x, $y, $posX, $posY){
  if (($posX == ($x - 1)) && ($posY == ($y - 1)))
  {
    return 0;
  }
  else if (((($posX < 0) || ($posY < 0)) || ($posX >= $x)) || ($posY >= $y))
  {
    return ($x * $y) * 10;
  }
  else if ($tab[$posY][$posX] == '#')
  {
    return ($x * $y) * 10;
  }
  else if ($cache[$posY][$posX] != (-1))
  {
    return $cache[$posY][$posX];
  }
  else
  {
    $cache[$posY][$posX] = ($x * $y) * 10;
    $val1 = pathfind_aux($cache, $tab, $x, $y, $posX + 1, $posY);
    $val2 = pathfind_aux($cache, $tab, $x, $y, $posX - 1, $posY);
    $val3 = pathfind_aux($cache, $tab, $x, $y, $posX, $posY - 1);
    $val4 = pathfind_aux($cache, $tab, $x, $y, $posX, $posY + 1);
    $out_ = 1 + min4($val1, $val2, $val3, $val4);
    $cache[$posY][$posX] = $out_;
    return $out_;
  }
}

function pathfind(&$tab, $x, $y){
  $cache = array();
  for ($i = 0 ; $i <= $y - 1; $i++)
  {
    $tmp = array();
    for ($j = 0 ; $j <= $x - 1; $j++)
    {
      $tmp[$j] = -1;
    }
    $cache[$i] = $tmp;
  }
  return pathfind_aux($cache, $tab, $x, $y, 0, 0);
}


$stdin='';
while (!feof(STDIN)) $stdin.=fgets(STDIN);
function scan($format){
  global $stdin;
  $out = sscanf($stdin, $format);
  $stdin = substr($stdin, strlen($out[0]));
  return $out;
}
function scantrim(){
  global $stdin;
  $stdin = trim($stdin);
}
function nextChar(){
  global $stdin;
  $out = $stdin[0];
  $stdin = substr($stdin, 1);
  return $out;
}

$x = 0;
$y = 0;
list($x) = scan("%d");
scantrim();
list($y) = scan("%d");
scantrim();
$tab = array();
for ($i = 0 ; $i <= $y - 1; $i++)
{
  $tab2 = array();
  for ($j = 0 ; $j <= $x - 1; $j++)
  {
    $tmp = '\000';
    $tmp = nextChar();
    $tab2[$j] = $tmp;
  }
  scantrim();
  $tab[$i] = $tab2;
}
$result = pathfind($tab, $x, $y);
printf("%d", $result);
?>
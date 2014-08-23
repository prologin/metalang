<?php
function max2($a, $b){
  return max($a, $b);
}

function &primesfactors($n){
  $tab = array();
  for ($i = 0 ; $i < $n + 1; $i++)
    $tab[$i] = 0;
  $d = 2;
  while ($n != 1 && $d * $d <= $n)
    if (($n % $d) == 0)
  {
    $tab[$d] = $tab[$d] + 1;
    $n = intval($n / $d);
  }
  else
    $d ++;
  $tab[$n] = $tab[$n] + 1;
  return $tab;
}

$lim = 20;
$o = array();
for ($m = 0 ; $m < $lim + 1; $m++)
  $o[$m] = 0;
for ($i = 1 ; $i <= $lim; $i++)
{
  $t = primesfactors($i);
  for ($j = 1 ; $j <= $i; $j++)
    $o[$j] = max2($o[$j], $t[$j]);
}
$product = 1;
for ($k = 1 ; $k <= $lim; $k++)
  for ($l = 1 ; $l <= $o[$k]; $l++)
    $product *= $k;
echo $product, "\n";
?>

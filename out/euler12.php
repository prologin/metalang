<?php
function eratostene(&$t, $max0){
  $n = 0;
  for ($i = 2 ; $i < $max0; $i++)
    if ($t[$i] == $i)
  {
    $j = $i * $i;
    $n ++;
    while ($j < $max0 && $j > 0)
    {
      $t[$j] = 0;
      $j += $i;
    }
  }
  return $n;
}

function fillPrimesFactors(&$t, $n, &$primes, $nprimes){
  for ($i = 0 ; $i < $nprimes; $i++)
  {
    $d = $primes[$i];
    while (($n % $d) == 0)
    {
      $t[$d] = $t[$d] + 1;
      $n = intval($n / $d);
    }
    if ($n == 1)
      return $primes[$i];
  }
  return $n;
}

function find($ndiv2){
  $maximumprimes = 110;
  $era = array();
  for ($j = 0 ; $j < $maximumprimes; $j++)
    $era[$j] = $j;
  $nprimes = eratostene($era, $maximumprimes);
  $primes = array();
  for ($o = 0 ; $o < $nprimes; $o++)
    $primes[$o] = 0;
  $l = 0;
  for ($k = 2 ; $k < $maximumprimes; $k++)
    if ($era[$k] == $k)
  {
    $primes[$l] = $k;
    $l ++;
  }
  for ($n = 1 ; $n <= 10000; $n++)
  {
    $primesFactors = array();
    for ($m = 0 ; $m < $n + 2; $m++)
      $primesFactors[$m] = 0;
    $max0 = max(fillPrimesFactors($primesFactors, $n, $primes, $nprimes), fillPrimesFactors($primesFactors, $n + 1, $primes, $nprimes));
    $primesFactors[2] --;
    $ndivs = 1;
    for ($i = 0 ; $i <= $max0; $i++)
      if ($primesFactors[$i] != 0)
      $ndivs *= 1 + $primesFactors[$i];
    if ($ndivs > $ndiv2)
      return intval(($n * ($n + 1)) / 2);
    /* print "n=" print n print "\t" print (n * (n + 1) / 2 ) print " " print ndivs print "\n" */
  }
  return 0;
}

echo find(500), "\n";
?>

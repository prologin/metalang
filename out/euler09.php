<?php

/*
	a + b + c = 1000 && a * a + b * b = c * c
	*/
for ($a = 1 ; $a <= 1000; $a++)
  for ($b = $a + 1 ; $b <= 1000; $b++)
  {
    $c = 1000 - $a - $b;
    $a2b2 = $a * $a + $b * $b;
    $cc = $c * $c;
    if ($cc == $a2b2 && $c > $a)
    {
      echo $a, "\n", $b, "\n", $c, "\n";
      $d = $a * $b * $c;
      echo $d, "\n";
    }
}
?>
<?php
$f = array_fill(0, 10, 1);
for ($i = 1; $i < 10; $i++)
{
    $f[$i] *= $i * $f[$i - 1];
    echo $f[$i], " ";
}
$out0 = 0;
echo "\n";
for ($a = 0; $a < 10; $a++)
    for ($b = 0; $b < 10; $b++)
        for ($c = 0; $c < 10; $c++)
            for ($d = 0; $d < 10; $d++)
                for ($e = 0; $e < 10; $e++)
                    for ($g = 0; $g < 10; $g++)
                    {
                        $sum = $f[$a] + $f[$b] + $f[$c] + $f[$d] + $f[$e] + $f[$g];
                        $num = (((($a * 10 + $b) * 10 + $c) * 10 + $d) * 10 + $e) * 10 + $g;
                        if ($a == 0)
                        {
                            $sum--;
                            if ($b == 0)
                            {
                                $sum--;
                                if ($c == 0)
                                {
                                    $sum--;
                                    if ($d == 0)
                                        $sum--;
                                }
                            }
                        }
                        if ($sum == $num && $sum != 1 && $sum != 2)
                        {
                            $out0 += $num;
                            echo $num, " ";
                        }
                    }
echo "\n", $out0, "\n";


<?php
for ($i = 1; $i < 4; $i++)
{
    list($a, $b, $c) = array_map("intval", explode(" ", fgets(STDIN)));
    echo "a = ", $a, " b = ", $b, "c =", $c, "\n";
}
$l = array_map("intval", explode(" ", fgets(STDIN)));
for ($j = 0; $j < 10; $j++)
    echo $l[$j], "\n";


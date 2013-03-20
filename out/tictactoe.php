<?php
/*
Tictactoe : un tictactoe avec une IA
*/
/* La structure de donnée */

/* Un Mouvement */

/* On affiche l'état */
function print_state(&$g){
  printf("%s", "\n|");
  for ($y = 0 ; $y <= 2; $y++)
  {
    for ($x = 0 ; $x <= 2; $x++)
    {
      if ($g["cases"][$x][$y] == 0)
      {
        printf("%s", " ");
      }
      else if ($g["cases"][$x][$y] == 1)
      {
        printf("%s", "O");
      }
      else
      {
        printf("%s", "X");
      }
      printf("%s", "|");
    }
    if ($y != 2)
    {
      printf("%s", "\n|-|-|-|\n|");
    }
  }
  printf("%s", "\n");
}

/* On dit qui gagne (info stoquées dans g.ended et g.note ) */
function eval_(&$g){
  $win = 0;
  $freecase = 0;
  for ($y = 0 ; $y <= 2; $y++)
  {
    $col = -1;
    $lin = -1;
    for ($x = 0 ; $x <= 2; $x++)
    {
      if ($g["cases"][$x][$y] == 0)
      {
        $freecase = $freecase + 1;
      }
      $colv = $g["cases"][$x][$y];
      $linv = $g["cases"][$y][$x];
      if (($col == (-1)) && ($colv != 0))
      {
        $col = $colv;
      }
      else if ($colv != $col)
      {
        $col = -2;
      }
      if (($lin == (-1)) && ($linv != 0))
      {
        $lin = $linv;
      }
      else if ($linv != $lin)
      {
        $lin = -2;
      }
    }
    if ($col >= 0)
    {
      $win = $col;
    }
    else if ($lin >= 0)
    {
      $win = $lin;
    }
  }
  for ($x = 1 ; $x <= 2; $x++)
  {
    if ((($g["cases"][0][0] == $x) && ($g["cases"][1][1] == $x)) && ($g["cases"][2][2] == $x))
    {
      $win = $x;
    }
    if ((($g["cases"][0][2] == $x) && ($g["cases"][1][1] == $x)) && ($g["cases"][2][0] == $x))
    {
      $win = $x;
    }
  }
  $g["ended"] = ($win != 0) || ($freecase == 0);
  if ($win == 1)
  {
    $g["note"] = 1000;
  }
  else if ($win == 2)
  {
    $g["note"] = -1000;
  }
  else
  {
    $g["note"] = 0;
  }
}

/* On applique un mouvement */
function apply_move_xy($x, $y, &$g){
  $player = 2;
  if ($g["firstToPlay"])
  {
    $player = 1;
  }
  $g["cases"][$x][$y] = $player;
  $g["firstToPlay"] = !$g["firstToPlay"];
}

function apply_move(&$m, &$g){
  apply_move_xy($m["x"], $m["y"], $g);
}

function cancel_move_xy($x, $y, &$g){
  $g["cases"][$x][$y] = 0;
  $g["firstToPlay"] = !$g["firstToPlay"];
  $g["ended"] = false;
}

function can_move_xy($x, $y, &$g){
  return $g["cases"][$x][$y] == 0;
}

function minmax(&$g){
  eval_($g);
  if ($g["ended"])
  {
    return $g["note"];
  }
  $maxNote = -10000;
  if (!$g["firstToPlay"])
  {
    $maxNote = 10000;
  }
  for ($x = 0 ; $x <= 2; $x++)
  {
    for ($y = 0 ; $y <= 2; $y++)
    {
      if (can_move_xy($x, $y, $g))
      {
        apply_move_xy($x, $y, $g);
        $currentNote = minmax($g);
        cancel_move_xy($x, $y, $g);
        if (($currentNote > $maxNote) == $g["firstToPlay"])
        {
          $maxNote = $currentNote;
        }
      }
    }
  }
  return $maxNote;
}

function play(&$g){
  $minMove = array(
    "x"=>0,
    "y"=>0
  );
  
  $minNote = 10000;
  for ($x = 0 ; $x <= 2; $x++)
  {
    for ($y = 0 ; $y <= 2; $y++)
    {
      if (can_move_xy($x, $y, $g))
      {
        apply_move_xy($x, $y, $g);
        $currentNote = minmax($g);
        printf("%d", $x);
        printf("%s", ", ");
        printf("%d", $y);
        printf("%s", ", ");
        printf("%d", $currentNote);
        printf("%s", "\n");
        cancel_move_xy($x, $y, $g);
        if ($currentNote < $minNote)
        {
          $minNote = $currentNote;
          $minMove["x"] = $x;
          $minMove["y"] = $y;
        }
      }
    }
  }
  $bq = $minMove["x"];
  printf("%d", $bq);
  $br = $minMove["y"];
  printf("%d", $br);
  printf("%s", "\n");
  return $minMove;
}

function init(){
  $bt = 3;
  $cases = array();
  for ($i = 0 ; $i <= $bt - 1; $i++)
  {
    $bs = 3;
    $tab = array();
    for ($j = 0 ; $j <= $bs - 1; $j++)
    {
      $tab[$j] = 0;
    }
    $cases[$i] = $tab;
  }
  $out_ = array(
    "cases"=>$cases,
    "firstToPlay"=>true,
    "note"=>0,
    "ended"=>false
  );
  
  return $out_;
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

for ($i = 0 ; $i <= 1; $i++)
{
  $state = init();
  while (!$state["ended"])
  {
    print_state($state);
    apply_move(play($state), $state);
    eval_($state);
    print_state($state);
    if (!$state["ended"])
    {
      apply_move(play($state), $state);
      eval_($state);
    }
  }
  print_state($state);
  $bu = $state["note"];
  printf("%d", $bu);
  printf("%s", "\n");
}
?>
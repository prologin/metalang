: abs_ { n }
  n 0 >
  IF
    n exit
  ELSE
    n NEGATE exit
  THEN
;

: main
  5 2 + abs_ 3 * s>d 0 d.r
  3 5 2 + abs_ * s>d 0 d.r
  ;
main
BYE


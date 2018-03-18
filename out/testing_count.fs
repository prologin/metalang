: cnt { a } a 1 cells - @ ;
: main
  40 dup HERE SWAP 1 + cells allot dup -rot ! 1 cells + { tab }
  39 0 BEGIN 2dup >= WHILE DUP { i }
    i i * tab  i cells +  !
   1 + REPEAT 2DROP
  tab cnt s>d 0 d.r
  S\" \n" TYPE
  ;
main
BYE


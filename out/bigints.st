Object subclass: bigint [
  | bigint_sign bigint_len bigint_chiffres |
  bigint_sign [ ^bigint_sign ]
  bigint_len [ ^bigint_len ]
  bigint_chiffres [ ^bigint_chiffres ]
  bigint_sign: s [ bigint_sign := s. ] 
  bigint_len: s [ bigint_len := s. ] 
  bigint_chiffres: s [ bigint_chiffres := s. ] 
]
Object subclass: bigints [
  |buffer|
  skip [
     ((buffer isNil) | ((buffer size) = 0)) ifTrue: [ buffer := FileStream stdin nextLine. ].
    (buffer isNil) ifFalse:[
    (buffer =~ '^(\s+)') ifMatched: [:match | buffer := buffer allButFirst:((match at: 1) size).].
    ]
  ]
  read_char [|o|
     ((buffer isNil) | ((buffer size) = 0)) ifTrue: [ buffer := FileStream stdin nextLine. ].
    (buffer isNil) ifFalse:[
    o := buffer at: 1.
    buffer := buffer allButFirst:1.
    ^o.
    ]
  ]
   max2_: a b: b [
    (a > b)
      ifTrue:[^ a]
      ifFalse:[^ b].
  ]
  
   min2_: a b: b [
    (a < b)
      ifTrue:[^ a]
      ifFalse:[^ b].
  ]
  
  
   read_bigint: len  [|tmp e chiffres c|
    chiffres := Array new: len.
    (0 to: (len - 1)) do: [:j|
      c := self read_char.
      chiffres at: (j + 1) put:  ((c) asciiValue).
    ].
    (0 to: ((len - 1) quo: 2)) do: [:i|
      tmp := (chiffres at: (i + 1)).
      chiffres at: (i + 1) put:  (chiffres at: (((len - 1) - i) + 1)).
      chiffres at: (((len - 1) - i) + 1) put:  tmp.
    ].
    e := bigint new.
    e bigint_sign: true.
    e bigint_len: len.
    e bigint_chiffres: chiffres.
    ^ e
  ]
  
   print_bigint: a  [
    (((a bigint_sign)) not)
      ifTrue:[$- display.].
    (0 to: ((a bigint_len) - 1)) do: [:i|
      (((a bigint_chiffres) at: ((((a bigint_len) - 1) - i) + 1))) display.
    ].
  ]
  
   bigint_eq: a b: b [
    " Renvoie vrai si a = b "
    ((a bigint_sign) ~= (b bigint_sign))
      ifTrue:[^ false]
      ifFalse:[((a bigint_len) ~= (b bigint_len))
                ifTrue:[^ false]
                ifFalse:[
                        (0 to: ((a bigint_len) - 1)) do: [:i|
                          (((a bigint_chiffres) at: (i + 1)) ~= ((b bigint_chiffres) at: (i + 1)))
                            ifTrue:[^ false].
                        ].
                        ^ true
                ].].
  ]
  
   bigint_gt: a b: b [|j|
    " Renvoie vrai si a > b "
    (((a bigint_sign)) ifTrue:[(((b bigint_sign)) not)] ifFalse: [false])
      ifTrue:[^ true]
      ifFalse:[(((((a bigint_sign)) not)) ifTrue:[(b bigint_sign)] ifFalse: [false])
                ifTrue:[^ false]
                ifFalse:[
                        ((a bigint_len) > (b bigint_len))
                          ifTrue:[^ (a bigint_sign)]
                          ifFalse:[((a bigint_len) < (b bigint_len))
                                    ifTrue:[^ (((a bigint_sign)) not)]
                                    ifFalse:[(0 to: ((a bigint_len) - 1)) do: [:i|
                                               j := (((a bigint_len) - 1) - i).
                                               (((a bigint_chiffres) at: (j + 1)) > ((b bigint_chiffres) at: (j + 1)))
                                                 ifTrue:[^ (a bigint_sign)]
                                                 ifFalse:[(((a bigint_chiffres) at: (j + 1)) < ((b bigint_chiffres) at: (j + 1)))
                                                           ifTrue:[^ (((a bigint_sign)) not)].].
                                            ].].].
                        ^ true
                ].].
  ]
  
   bigint_lt: a b: b [
    ^ (((self bigint_gt: a b: b)) not)
  ]
  
   add_bigint_positif: a b: b [|tmp retenue len f chiffres|
    " Une addition ou on en a rien a faire des signes "
    len := ((self max2_: (a bigint_len) b: (b bigint_len)) + 1).
    retenue := 0.
    chiffres := Array new: len.
    (0 to: (len - 1)) do: [:i|
      tmp := retenue.
      (i < (a bigint_len))
        ifTrue:[tmp :=  (tmp + ((a bigint_chiffres) at: (i + 1))).].
      (i < (b bigint_len))
        ifTrue:[tmp :=  (tmp + ((b bigint_chiffres) at: (i + 1))).].
      retenue :=  (tmp quo: 10).
      chiffres at: (i + 1) put:  (tmp rem: 10).
    ].
    [(((len > 0)) ifTrue:[((chiffres at: ((len - 1) + 1)) = 0)] ifFalse: [false])] whileTrue:
    [len :=  (len - 1).].
    f := bigint new.
    f bigint_sign: true.
    f bigint_len: len.
    f bigint_chiffres: chiffres.
    ^ f
  ]
  
   sub_bigint_positif: a b: b [|tmp retenue len g chiffres|
    " Une soustraction ou on en a rien a faire des signes
Pré-requis : a > b
"
    len := (a bigint_len).
    retenue := 0.
    chiffres := Array new: len.
    (0 to: (len - 1)) do: [:i|
      tmp := (retenue + ((a bigint_chiffres) at: (i + 1))).
      (i < (b bigint_len))
        ifTrue:[tmp :=  (tmp - ((b bigint_chiffres) at: (i + 1))).].
      (tmp < 0)
        ifTrue:[
               tmp :=  (tmp + 10).
               retenue :=  (0-(1)).
        ]
        ifFalse:[retenue :=  0.].
      chiffres at: (i + 1) put:  tmp.
    ].
    [(((len > 0)) ifTrue:[((chiffres at: ((len - 1) + 1)) = 0)] ifFalse: [false])] whileTrue:
    [len :=  (len - 1).].
    g := bigint new.
    g bigint_sign: true.
    g bigint_len: len.
    g bigint_chiffres: chiffres.
    ^ g
  ]
  
   neg_bigint: a  [|h|
    h := bigint new.
    h bigint_sign: (((a bigint_sign)) not).
    h bigint_len: (a bigint_len).
    h bigint_chiffres: (a bigint_chiffres).
    ^ h
  ]
  
   add_bigint: a b: b [
    ((a bigint_sign) = (b bigint_sign))
      ifTrue:[(a bigint_sign)
               ifTrue:[^ (self add_bigint_positif: a b: b)]
               ifFalse:[^ (self neg_bigint: (self add_bigint_positif: a b: b))].]
      ifFalse:[(a bigint_sign)
                ifTrue:[
                       " a positif, b negatif "
                       (self bigint_gt: a b: (self neg_bigint: b))
                         ifTrue:[^ (self sub_bigint_positif: a b: b)]
                         ifFalse:[^ (self neg_bigint: (self sub_bigint_positif: b b: a))].
                ]
                ifFalse:[
                        " a negatif, b positif "
                        (self bigint_gt: (self neg_bigint: a) b: b)
                          ifTrue:[^ (self neg_bigint: (self sub_bigint_positif: a b: b))]
                          ifFalse:[^ (self sub_bigint_positif: b b: a)].
                ].].
  ]
  
   sub_bigint: a b: b [
    ^ (self add_bigint: a b: (self neg_bigint: b))
  ]
  
   mul_bigint_cp: a b: b [|retenue m len chiffres|
    " Cet algorithm est quadratique.
C'est le même que celui qu'on enseigne aux enfants en CP.
D'ou le nom de la fonction. "
    len := (((a bigint_len) + (b bigint_len)) + 1).
    chiffres := Array new: len.
    (0 to: (len - 1)) do: [:k|
      chiffres at: (k + 1) put:  0.
    ].
    (0 to: ((a bigint_len) - 1)) do: [:i|
      retenue := 0.
      (0 to: ((b bigint_len) - 1)) do: [:j|
        chiffres at: ((i + j) + 1) put:  ((chiffres at: ((i + j) + 1)) + (retenue + (((b bigint_chiffres) at: (j + 1)) * ((a bigint_chiffres) at: (i + 1))))).
        retenue :=  ((chiffres at: ((i + j) + 1)) quo: 10).
        chiffres at: ((i + j) + 1) put:  ((chiffres at: ((i + j) + 1)) rem: 10).
      ].
      chiffres at: ((i + (b bigint_len)) + 1) put:  ((chiffres at: ((i + (b bigint_len)) + 1)) + retenue).
    ].
    chiffres at: (((a bigint_len) + (b bigint_len)) + 1) put:  ((chiffres at: ((((a bigint_len) + (b bigint_len)) - 1) + 1)) quo: 10).
    chiffres at: ((((a bigint_len) + (b bigint_len)) - 1) + 1) put:  ((chiffres at: ((((a bigint_len) + (b bigint_len)) - 1) + 1)) rem: 10).
    (0 to: 2) do: [:l|
      (((len ~= 0)) ifTrue:[((chiffres at: ((len - 1) + 1)) = 0)] ifFalse: [false])
        ifTrue:[len :=  (len - 1).].
    ].
    m := bigint new.
    m bigint_sign: ((a bigint_sign) = (b bigint_sign)).
    m bigint_len: len.
    m bigint_chiffres: chiffres.
    ^ m
  ]
  
   bigint_premiers_chiffres: a i: i [|o len|
    len := (self min2_: i b: (a bigint_len)).
    [(((len ~= 0)) ifTrue:[(((a bigint_chiffres) at: ((len - 1) + 1)) = 0)] ifFalse: [false])] whileTrue:
    [len :=  (len - 1).].
    o := bigint new.
    o bigint_sign: (a bigint_sign).
    o bigint_len: len.
    o bigint_chiffres: (a bigint_chiffres).
    ^ o
  ]
  
   bigint_shift: a i: i [|p chiffres|
    chiffres := Array new: ((a bigint_len) + i).
    (0 to: (((a bigint_len) + i) - 1)) do: [:k|
      (k >= i)
        ifTrue:[chiffres at: (k + 1) put:  ((a bigint_chiffres) at: ((k - i) + 1)).]
        ifFalse:[chiffres at: (k + 1) put:  0.].
    ].
    p := bigint new.
    p bigint_sign: (a bigint_sign).
    p bigint_len: ((a bigint_len) + i).
    p bigint_chiffres: chiffres.
    ^ p
  ]
  
   mul_bigint: aa bb: bb [|split d cmoinsd c bd b amoinsbcmoinsd amoinsb acdec ac a|
    ((aa bigint_len) = 0)
      ifTrue:[^ aa]
      ifFalse:[((bb bigint_len) = 0)
                ifTrue:[^ bb]
                ifFalse:[((((aa bigint_len) < 3)) ifTrue:[true] ifFalse: [((bb bigint_len) < 3)])
                          ifTrue:[^ (self mul_bigint_cp: aa b: bb)].].].
    " Algorithme de Karatsuba "
    split := ((self min2_: (aa bigint_len) b: (bb bigint_len)) quo: 2).
    a := (self bigint_shift: aa i: (0-(split))).
    b := (self bigint_premiers_chiffres: aa i: split).
    c := (self bigint_shift: bb i: (0-(split))).
    d := (self bigint_premiers_chiffres: bb i: split).
    amoinsb := (self sub_bigint: a b: b).
    cmoinsd := (self sub_bigint: c b: d).
    ac := (self mul_bigint: a bb: c).
    bd := (self mul_bigint: b bb: d).
    amoinsbcmoinsd := (self mul_bigint: amoinsb bb: cmoinsd).
    acdec := (self bigint_shift: ac i: (2 * split)).
    ^ (self add_bigint: (self add_bigint: acdec b: bd) b: (self bigint_shift: (self sub_bigint: (self add_bigint: ac b: bd) b: amoinsbcmoinsd) i: split))
    " ac × 102k + (ac + bd – (a – b)(c – d)) × 10k + bd "
  ]
  
  "
Division,
Modulo
"
   log10: u  [|out0 a|
    a := u.
    out0 := 1.
    [(a >= 10)] whileTrue:
    [
    a :=  (a quo: 10).
    out0 :=  (out0 + 1).
    ].
    ^ out0
  ]
  
   bigint_of_int: v  [|t size q i|
    i := v.
    size := (self log10: i).
    (i = 0)
      ifTrue:[size :=  0.].
    t := Array new: size.
    (0 to: (size - 1)) do: [:j|
      t at: (j + 1) put:  0.
    ].
    (0 to: (size - 1)) do: [:k|
      t at: (k + 1) put:  (i rem: 10).
      i :=  (i quo: 10).
    ].
    q := bigint new.
    q bigint_sign: true.
    q bigint_len: size.
    q bigint_chiffres: t.
    ^ q
  ]
  
   fact_bigint: w  [|out0 one a|
    a := w.
    one := (self bigint_of_int: 1).
    out0 := one.
    [(((self bigint_eq: a b: one)) not)] whileTrue:
    [
    out0 :=  (self mul_bigint: a bb: out0).
    a :=  (self sub_bigint: a b: one).
    ].
    ^ out0
  ]
  
   sum_chiffres_bigint: a  [|out0|
    out0 := 0.
    (0 to: ((a bigint_len) - 1)) do: [:i|
      out0 :=  (out0 + ((a bigint_chiffres) at: (i + 1))).
    ].
    ^ out0
  ]
  
  " http://projecteuler.net/problem=20 "
  euler20 [|a|
    a := (self bigint_of_int: 15).
    " normalement c'est 100 "
    a :=  (self fact_bigint: a).
    ^ (self sum_chiffres_bigint: a)
  ]
  
   bigint_exp: a b: b [
    (b = 1)
      ifTrue:[^ a]
      ifFalse:[((b rem: 2) = 0)
                ifTrue:[^ (self bigint_exp: (self mul_bigint: a bb: a) b: (b quo: 2))]
                ifFalse:[^ (self mul_bigint: a bb: (self bigint_exp: a b: (b - 1)))].].
  ]
  
   bigint_exp_10chiffres: x b: b [|a|
    a := x.
    a :=  (self bigint_premiers_chiffres: a i: 10).
    (b = 1)
      ifTrue:[^ a]
      ifFalse:[((b rem: 2) = 0)
                ifTrue:[^ (self bigint_exp_10chiffres: (self mul_bigint: a bb: a) b: (b quo: 2))]
                ifFalse:[^ (self mul_bigint: a bb: (self bigint_exp_10chiffres: a b: (b - 1)))].].
  ]
  
  euler48 [|sum ibeib ib|
    sum := (self bigint_of_int: 0).
    (1 to: 100) do: [:i|
      " 1000 normalement "
      ib := (self bigint_of_int: i).
      ibeib := (self bigint_exp_10chiffres: ib b: i).
      sum :=  (self add_bigint: sum b: ibeib).
      sum :=  (self bigint_premiers_chiffres: sum i: 10).
    ].
    'euler 48 = ' display.
    (self print_bigint: sum).
    '
' display.
  ]
  
  euler16 [|a|
    a := (self bigint_of_int: 2).
    a :=  (self bigint_exp: a b: 100).
    " 1000 normalement "
    ^ (self sum_chiffres_bigint: a)
  ]
  
  euler25 [|i c b a|
    i := 2.
    a := (self bigint_of_int: 1).
    b := (self bigint_of_int: 1).
    [((b bigint_len) < 100)] whileTrue:
    [
    " 1000 normalement "
    c := (self add_bigint: a b: b).
    a :=  b.
    b :=  c.
    i :=  (i + 1).
    ].
    ^ i
  ]
  
  euler29 [|n min0 maxB maxA found b a_bigint a0_bigint|
    maxA := 5.
    maxB := 5.
    a_bigint := Array new: (maxA + 1).
    (0 to: ((maxA + 1) - 1)) do: [:j|
      a_bigint at: (j + 1) put:  (self bigint_of_int: (j * j)).
    ].
    a0_bigint := Array new: (maxA + 1).
    (0 to: ((maxA + 1) - 1)) do: [:j2|
      a0_bigint at: (j2 + 1) put:  (self bigint_of_int: j2).
    ].
    b := Array new: (maxA + 1).
    (0 to: ((maxA + 1) - 1)) do: [:k|
      b at: (k + 1) put:  2.
    ].
    n := 0.
    found := true.
    [found] whileTrue:
    [
    min0 := (a0_bigint at: (0 + 1)).
    found :=  false.
    (2 to: maxA) do: [:i|
      ((b at: (i + 1)) <= maxB)
        ifTrue:[found
                 ifTrue:[(self bigint_lt: (a_bigint at: (i + 1)) b: min0)
                          ifTrue:[min0 :=  (a_bigint at: (i + 1)).].]
                 ifFalse:[
                         min0 :=  (a_bigint at: (i + 1)).
                         found :=  true.
                 ].].
    ].
    found
      ifTrue:[
             n :=  (n + 1).
             (2 to: maxA) do: [:l|
               (((self bigint_eq: (a_bigint at: (l + 1)) b: min0)) ifTrue:[((b at: (l + 1)) <= maxB)] ifFalse: [false])
                 ifTrue:[
                        b at: (l + 1) put:  ((b at: (l + 1)) + 1).
                        a_bigint at: (l + 1) put:  (self mul_bigint: (a_bigint at: (l + 1)) bb: (a0_bigint at: (l + 1))).
                 ].
             ].
      ].
    ].
    ^ n
  ]
  
  main [
    |tmp sum r b a|((self euler29)) display.
                   '
' display.
    sum := (self read_bigint: 50).
    (2 to: 100) do: [:i|
      self skip.
      tmp := (self read_bigint: 50).
      sum :=  (self add_bigint: sum b: tmp).
    ].
    'euler13 = ' display.
    (self print_bigint: sum).
    '
' display.
    'euler25 = ' display.
    ((self euler25)) display.
    '
' display.
    'euler16 = ' display.
    ((self euler16)) display.
    '
' display.
    (self euler48).
    'euler20 = ' display.
    ((self euler20)) display.
    '
' display.
    a := (self bigint_of_int: 999999).
    b := (self bigint_of_int: 9951263).
    (self print_bigint: a).
    '>>1=' display.
    (self print_bigint: (self bigint_shift: a
    i: (0-(1)))).
    '
' display.
    (self print_bigint: a).
    '*' display.
    (self print_bigint: b).
    '=' display.
    (self print_bigint: (self mul_bigint: a
    bb: b)).
    '
' display.
    (self print_bigint: a).
    '*' display.
    (self print_bigint: b).
    '=' display.
    (self print_bigint: (self mul_bigint_cp: a
    b: b)).
    '
' display.
    (self print_bigint: a).
    '+' display.
    (self print_bigint: b).
    '=' display.
    (self print_bigint: (self add_bigint: a
    b: b)).
    '
' display.
    (self print_bigint: b).
    '-' display.
    (self print_bigint: a).
    '=' display.
    (self print_bigint: (self sub_bigint: b
    b: a)).
    '
' display.
    (self print_bigint: a).
    '-' display.
    (self print_bigint: b).
    '=' display.
    (self print_bigint: (self sub_bigint: a
    b: b)).
    '
' display.
    (self print_bigint: a).
    '>' display.
    (self print_bigint: b).
    '=' display.
    r := (self bigint_gt: a b: b).
    r
      ifTrue:['True' display.]
      ifFalse:['False' display.].
    '
' display.
    ]
]
Eval [ (bigints new) main. ]

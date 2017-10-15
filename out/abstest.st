Object subclass: abstest [
   abs_: n  [
    (n > 0)
    ifTrue:[^ n]
    ifFalse:[^ 0 - n].
  ]
  main [
    ((self abs_: (5 + 2)) * 3) display.
    (3 * (self abs_: (5 + 2))) display.
    ]
]
Eval [ (abstest new) main. ]


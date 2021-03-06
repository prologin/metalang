Object subclass: euler07 [
   divisible: n t: t size: size [
    (0 to: (size - 1)) do: [:i| ((n rem: (t at: (i + 1))) = 0)
      ifTrue:[^ true].].
    ^ false
  ]
  
   find: a t: t b: b nth: nth [|used n|
    n := a.
    used := b.
    [used ~= nth] whileTrue:[(self divisible: n t: t size: used)
      ifTrue:[n := n + 1.]
      ifFalse:[
        t at: (used + 1) put: n.
        n := n + 1.
        used := used + 1.
      ].].
    ^ t at: used
  ]
  main [
    |t n|n := 10001.
    t := Array new: n.
    (0 to: (n - 1)) do: [:i| t at: (i + 1) put: 2.].
    (self find: 3 t: t b: 1 nth: n) display.
    '
' display.
    ]
]
Eval [ (euler07 new) main. ]


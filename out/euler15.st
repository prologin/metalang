Object subclass: euler15 [
  main [
    |tab2 tab r q n|n := 10.
    " normalement on doit mettre 20 mais là on se tape un overflow "
    n := n + 1.
    tab := Array new: n.
    (0 to: (n - 1)) do: [:i|
      tab2 := Array new: n.
      (0 to: (n - 1)) do: [:j| tab2 at: (j + 1) put: 0.].
      tab at: (i + 1) put: tab2.
    ].
    (0 to: (n - 1)) do: [:l|
      (tab at: n) at: (l + 1) put: 1.
      (tab at: (l + 1)) at: n put: 1.
    ].
    (2 to: n) do: [:o|
      r := n - o.
      (2 to: n) do: [:p|
        q := n - p.
        (tab at: (r + 1)) at: (q + 1) put: (((tab at: (r + 2)) at: (q + 1)) + ((tab at: (r + 1)) at: (q + 2))).
      ].
    ].
    (0 to: (n - 1)) do: [:m|
      (0 to: (n - 1)) do: [:k| ((tab at: (m + 1)) at: (k + 1)) display.
        ' ' display.].
      '
' display.
    ].
    ((tab at: 1) at: 1) display.
    '
' display.
    ]
]
Eval [ (euler15 new) main. ]


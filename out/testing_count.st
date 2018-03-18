Object subclass: testing_count [
  main [
    |tab|tab := Array new: 40.
    (0 to: 39) do: [:i| tab at: (i + 1) put: (i * i).].
    tab size display.
    '
' display.
    ]
]
Eval [ (testing_count new) main. ]


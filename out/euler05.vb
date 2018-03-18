Imports System

Module euler05

  Function primesfactors(ByVal n as Integer) As Integer()
    Dim tab(n) As Integer
    For i As Integer = 0 To n
        tab(i) = 0
    Next
    Dim d As Integer = 2
    Do While n <> 1 AndAlso d * d <= n
        If n Mod d = 0 Then
            tab(d) = tab(d) + 1
            n = n \ d
        Else 
            d = d + 1
        End If
    Loop
    tab(n) = tab(n) + 1
    Return tab
    End Function
    Sub Main()
      Dim lim As Integer = 20
      Dim o(lim) As Integer
      For m As Integer = 0 To lim
          o(m) = 0
      Next
      For i As Integer = 1 To lim
          Dim t As Integer() = primesfactors(i)
          For j As Integer = 1 To i
              o(j) = Math.Max(o(j), t(j))
          Next
      Next
      Dim product As Integer = 1
      For k As Integer = 1 To lim
          For l As Integer = 1 To o(k)
              product = product * k
          Next
      Next
      Console.Write(product & Chr(10))
      End Sub
      
    End Module
    
    
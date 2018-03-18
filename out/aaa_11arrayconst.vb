Imports System

Module aaa_11arrayconst

  Sub test(ByRef tab as Integer(), ByVal len as Integer)
    For i As Integer = 0 To len - 1
        Console.Write(tab(i) & " ")
    Next
    Console.Write(Chr(10))
  End Sub
  Sub Main()
    Dim t(4) As Integer
    For i As Integer = 0 To 4
        t(i) = 1
    Next
    test(t, 5)
    End Sub
    
  End Module
  
  
Imports System

Module testing_count

  
  Sub Main()
    Dim tab(39) As Integer
    For i As Integer = 0 To 39
        tab(i) = i * i
    Next
    Console.Write((tab).Length & Chr(10))
    End Sub
    
  End Module
  
  
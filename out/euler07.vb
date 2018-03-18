Imports System

Module euler07

  Function divisible(ByVal n as Integer, ByRef t as Integer(), ByVal size as Integer) As Boolean
    For i As Integer = 0 To size - 1
        If n Mod t(i) = 0 Then
            Return true
        End If
    Next
    Return false
  End Function
  Function find(ByVal n as Integer, ByRef t as Integer(), ByVal used as Integer, ByVal nth as Integer) As Integer
    Do While used <> nth
        If divisible(n, t, used) Then
            n = n + 1
        Else 
            t(used) = n
            n = n + 1
            used = used + 1
        End If
    Loop
    Return t(used - 1)
  End Function
  Sub Main()
    Dim n As Integer = 10001
    Dim t(n - 1) As Integer
    For i As Integer = 0 To n - 1
        t(i) = 2
    Next
    Console.Write(find(3, t, 1, n) & Chr(10))
    End Sub
    
  End Module
  
  
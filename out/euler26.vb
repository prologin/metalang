Imports System

Module euler26

  Function periode(ByRef restes as Integer(), ByVal len as Integer, ByVal a as Integer, ByVal b as Integer) As Integer
    Do While a <> 0
        Dim chiffre As Integer = a \ b
        Dim reste As Integer = a Mod b
        For i As Integer = 0 To len - 1
            If restes(i) = reste Then
                Return len - i
            End If
        Next
        restes(len) = reste
        len = len + 1
        a = reste * 10
    Loop
    Return 0
  End Function
  Sub Main()
    Dim t(999) As Integer
    For j As Integer = 0 To 999
        t(j) = 0
    Next
    Dim m As Integer = 0
    Dim mi As Integer = 0
    For i As Integer = 1 To 1000
        Dim p As Integer = periode(t, 0, 1, i)
        If p > m Then
            mi = i
            m = p
        End If
    Next
    Console.Write(mi & Chr(10) & m & Chr(10))
    End Sub
    
  End Module
  
  
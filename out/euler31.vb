Imports System

Module euler31

  Function result(ByVal sum as Integer, ByRef t as Integer(), ByVal maxIndex as Integer, ByRef cache as Integer()()) As Integer
    If cache(sum)(maxIndex) <> 0 Then
        Return cache(sum)(maxIndex)
    ElseIf sum = 0 OrElse maxIndex = 0 Then
        Return 1
    Else 
        Dim out0 As Integer = 0
        Dim div As Integer = sum \ t(maxIndex)
        For i As Integer = 0 To div
            out0 = out0 + result(sum - i * t(maxIndex), t, maxIndex - 1, cache)
        Next
        cache(sum)(maxIndex) = out0
        Return out0
    End If
  End Function
  Sub Main()
    Dim t(7) As Integer
    For i As Integer = 0 To 7
        t(i) = 0
    Next
    t(0) = 1
    t(1) = 2
    t(2) = 5
    t(3) = 10
    t(4) = 20
    t(5) = 50
    t(6) = 100
    t(7) = 200
    Dim cache(200)() As Integer
    For j As Integer = 0 To 200
        Dim o(7) As Integer
        For k As Integer = 0 To 7
            o(k) = 0
        Next
        cache(j) = o
        Next
        Console.Write(result(200, t, 7, cache))
    End Sub
    
    End Module
     
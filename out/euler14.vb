Imports System

Module euler14

  Function next0(ByVal n as Integer) As Integer
    If n Mod 2 = 0 Then
        Return n \ 2
    Else 
        Return 3 * n + 1
    End If
  End Function
  Function find(ByVal n as Integer, ByRef m as Integer()) As Integer
    If n = 1 Then
        Return 1
    ElseIf n >= 1000000 Then
        Return 1 + find(next0(n), m)
    ElseIf m(n) <> 0 Then
        Return m(n)
    Else 
        m(n) = 1 + find(next0(n), m)
        Return m(n)
    End If
  End Function
  Sub Main()
    Dim m(999999) As Integer
    For j As Integer = 0 To 999999
        m(j) = 0
    Next
    Dim max0 As Integer = 0
    Dim maxi As Integer = 0
    For i As Integer = 1 To 999
        ' normalement on met 999999 mais ça dépasse les int32... 
        
        Dim n2 As Integer = find(i, m)
        If n2 > max0 Then
            max0 = n2
            maxi = i
        End If
    Next
    Console.Write(max0 & Chr(10) & maxi & Chr(10))
    End Sub
    
  End Module
  
  
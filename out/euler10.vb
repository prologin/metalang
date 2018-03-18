Imports System

Module euler10

  Function eratostene(ByRef t as Integer(), ByVal max0 as Integer) As Integer
    Dim sum As Integer = 0
    For i As Integer = 2 To max0 - 1
        If t(i) = i Then
            sum = sum + i
            If max0 \ i > i Then
                Dim j As Integer = i * i
                Do While j < max0 AndAlso j > 0
                    t(j) = 0
                    j = j + i
                Loop
            End If
        End If
    Next
    Return sum
  End Function
  Sub Main()
    Dim n As Integer = 100000
    ' normalement on met 2000 000 mais là on se tape des int overflow dans plein de langages 
    
    Dim t(n - 1) As Integer
    For i As Integer = 0 To n - 1
        t(i) = i
    Next
    t(1) = 0
    Console.Write(eratostene(t, n) & Chr(10))
    End Sub
    
  End Module
  
  
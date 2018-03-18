Imports System

Module euler15

  
  Sub Main()
    Dim n As Integer = 10
    ' normalement on doit mettre 20 mais là on se tape un overflow 
    
    n = n + 1
    Dim tab(n - 1)() As Integer
    For i As Integer = 0 To n - 1
        Dim tab2(n - 1) As Integer
        For j As Integer = 0 To n - 1
            tab2(j) = 0
        Next
        tab(i) = tab2
        Next
        For l As Integer = 0 To n - 1
            tab(n - 1)(l) = 1
            tab(l)(n - 1) = 1
        Next
        For o As Integer = 2 To n
            Dim r As Integer = n - o
            For p As Integer = 2 To n
                Dim q As Integer = n - p
                tab(r)(q) = tab(r + 1)(q) + tab(r)(q + 1)
            Next
        Next
        For m As Integer = 0 To n - 1
            For k As Integer = 0 To n - 1
                Console.Write(tab(m)(k) & " ")
            Next
            Console.Write(Chr(10))
        Next
        Console.Write(tab(0)(0) & Chr(10))
    End Sub
    
    End Module
    
    
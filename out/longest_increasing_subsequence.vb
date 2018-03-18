Imports System
Imports System.Collections.Generic

Module longest_increasing_subsequence

  Function dichofind(ByVal len as Integer, ByRef tab as Integer(), ByVal tofind as Integer, ByVal a as Integer, ByVal b as Integer) As Integer
    If a >= b - 1 Then
        Return a
    Else 
        Dim c As Integer = (a + b) \ 2
        If tab(c) < tofind Then
            Return dichofind(len, tab, tofind, c, b)
        Else 
            Return dichofind(len, tab, tofind, a, c)
        End If
    End If
  End Function
  Function process(ByVal len as Integer, ByRef tab as Integer()) As Integer
    Dim size(len - 1) As Integer
    For j As Integer = 0 To len - 1
        If j = 0 Then
            size(j) = 0
        Else 
            size(j) = len * 2
        End If
    Next
    For i As Integer = 0 To len - 1
        Dim k As Integer = dichofind(len, size, tab(i), 0, len - 1)
        If size(k + 1) > tab(i) Then
            size(k + 1) = tab(i)
        End If
    Next
    For l As Integer = 0 To len - 1
        Console.Write(size(l) & " ")
    Next
    For m As Integer = 0 To len - 1
        Dim k As Integer = len - 1 - m
        If size(k) <> len * 2 Then
            Return k
        End If
    Next
    Return 0
    End Function
    Sub Main()
      Dim n As Integer = Integer.Parse(Console.ReadLine())
      For i As Integer = 1 To n
          Dim len As Integer = Integer.Parse(Console.ReadLine())
          Console.Write(process(len, Array(Of String).ConvertAll(Of String, Integer)(Console.ReadLine().Split(" ".ToCharArray()), New Converter(Of String, Integer)(AddressOf Integer.Parse))) & Chr(10))
      Next
    End Sub
    
  End Module
  
  
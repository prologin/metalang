Imports System
Imports System.Collections.Generic

Module aaa_missing

  '
  '  Ce test a été généré par Metalang.
  '
  
  Function result(ByVal len as Integer, ByRef tab as Integer()) As Integer
    Dim tab2(len - 1) As Boolean
    For i As Integer = 0 To len - 1
        tab2(i) = false
    Next
    For i1 As Integer = 0 To len - 1
        Console.Write(tab(i1) & " ")
        tab2(tab(i1)) = true
    Next
    Console.Write(Chr(10))
    For i2 As Integer = 0 To len - 1
        If Not tab2(i2) Then
            Return i2
        End If
    Next
    Return -1
    End Function
    Sub Main()
      Dim len As Integer = Integer.Parse(Console.ReadLine())
      Console.Write(len & Chr(10))
      Dim tab As Integer() = Array(Of String).ConvertAll(Of String, Integer)(Console.ReadLine().Split(" ".ToCharArray()), New Converter(Of String, Integer)(AddressOf Integer.Parse))
      Console.Write(result(len, tab) & Chr(10))
    End Sub
    
  End Module
  
  
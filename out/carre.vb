Imports System
Imports System.Collections.Generic

Module carre

  
  Sub Main()
    Dim x As Integer = Integer.Parse(Console.ReadLine())
    Dim y As Integer = Integer.Parse(Console.ReadLine())
    Dim tab(y - 1)() As Integer
    For d As Integer = 0 To y - 1
        tab(d) = Array(Of String).ConvertAll(Of String, Integer)(Console.ReadLine().Split(" ".ToCharArray()), New Converter(Of String, Integer)(AddressOf Integer.Parse))
    Next
    For ix As Integer = 1 To x - 1
        For iy As Integer = 1 To y - 1
            If tab(iy)(ix) = 1 Then
                tab(iy)(ix) = Math.Min(Math.Min(tab(iy)(ix - 1), tab(iy - 1)(ix)), tab(iy - 1)(ix - 1)) + 1
            End If
        Next
    Next
    For jy As Integer = 0 To y - 1
        For jx As Integer = 0 To x - 1
            Console.Write(tab(jy)(jx) & " ")
        Next
        Console.Write(Chr(10))
    Next
    End Sub
    
  End Module
  
  
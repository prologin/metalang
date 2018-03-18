Imports System
Imports System.Collections.Generic

Module prologin_template_intmatrix

  Function programme_candidat(ByRef tableau as Integer()(), ByVal x as Integer, ByVal y as Integer) As Integer
    Dim out0 As Integer = 0
    For i As Integer = 0 To y - 1
        For j As Integer = 0 To x - 1
            out0 = out0 + tableau(i)(j) * (i * 2 + j)
        Next
    Next
    Return out0
  End Function
  Sub Main()
    Dim taille_x As Integer = Integer.Parse(Console.ReadLine())
    Dim taille_y As Integer = Integer.Parse(Console.ReadLine())
    Dim tableau(taille_y - 1)() As Integer
    For a As Integer = 0 To taille_y - 1
        tableau(a) = Array(Of String).ConvertAll(Of String, Integer)(Console.ReadLine().Split(" ".ToCharArray()), New Converter(Of String, Integer)(AddressOf Integer.Parse))
    Next
    Console.Write(programme_candidat(tableau, taille_x, taille_y) & Chr(10))
    End Sub
    
  End Module
  
  
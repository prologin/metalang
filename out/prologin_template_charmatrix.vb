Imports System
Imports System.Collections.Generic

Module prologin_template_charmatrix

  Function programme_candidat(ByRef tableau as Char()(), ByVal taille_x as Integer, ByVal taille_y as Integer) As Integer
    Dim out0 As Integer = 0
    For i As Integer = 0 To taille_y - 1
        For j As Integer = 0 To taille_x - 1
            out0 = out0 + Asc(tableau(i)(j)) * (i + j * 2)
            Console.Write(tableau(i)(j))
        Next
        Console.Write("--" & Chr(10))
    Next
    Return out0
  End Function
  Sub Main()
    Dim taille_x As Integer = Integer.Parse(Console.ReadLine())
    Dim taille_y As Integer = Integer.Parse(Console.ReadLine())
    Dim a(taille_y - 1)() As Char
    For b As Integer = 0 To taille_y - 1
        a(b) = Console.ReadLine().ToCharArray()
    Next
    Dim tableau As Char()() = a
    Console.Write(programme_candidat(tableau, taille_x, taille_y) & Chr(10))
    End Sub
    
  End Module
  
  
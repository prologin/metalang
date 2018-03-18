Imports System

Module aaa_10stringsarray

  Public Class toto
    Public s As String
    Public v As Integer
  End Class
  Function idstring(ByRef s as String) As String
    Return s
  End Function
  Sub printstring(ByRef s as String)
    Console.Write(idstring(s) & Chr(10))
  End Sub
  Sub print_toto(ByRef t as toto)
    Console.Write(t.s & " = " & t.v & Chr(10))
  End Sub
  Sub Main()
    Dim tab(1) As String
    For i As Integer = 0 To 1
        tab(i) = idstring("chaine de test")
    Next
    For j As Integer = 0 To 1
        printstring(idstring(tab(j)))
    Next
    Dim a As toto = new toto()
    a.s = "one"
    a.v = 1
    print_toto(a)
    End Sub
    
  End Module
  
  
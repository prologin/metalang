Imports System

Module affect

Dim eof As Boolean
Dim buffer As String
Function readChar_() As Char
  If buffer Is Nothing OrElse buffer.Length = 0 Then
    Dim tmp As String = Console.ReadLine()
    eof = (tmp Is Nothing)
    buffer = tmp + Chr(10)
  End If
  Return buffer(0)
End Function

Sub consommeChar()
  readChar_()
  buffer = buffer.Substring(1)
End Sub

Sub stdin_sep()
  Do
    If eof Then
      Return
    End If
    Dim c As Char = readChar_()
    If c = " "C Or c = Chr(13) Or c = Chr(9) Or c = Chr(10) Then
      consommeChar()
    Else
      Return
    End If
  Loop
End Sub

Function readInt() As Integer
  Dim i As Integer = 0
  Dim s as Char = readChar_()
  Dim sign As Integer = 1
  If s = "-"C Then
    sign = -1
    consommeChar()
  End If
  Do
    Dim c as Char = readChar_()
    If c <= "9"C And c >= "0"C Then
      i = i * 10 + Asc(c) - Asc("0"C)
      consommeChar()
    Else
      return i * sign
    End If
  Loop
End Function
  '
  'Ce test permet de vérifier que l'implémentation de l'affectation fonctionne correctement
  '
  
  Public Class toto
    Public foo As Integer
    Public bar As Integer
    Public blah As Integer
  End Class
  Function mktoto(ByVal v1 as Integer) As toto
    Dim t As toto = new toto()
    t.foo = v1
    t.bar = v1
    t.blah = v1
    Return t
  End Function
  Function mktoto2(ByVal v1 as Integer) As toto
    Dim t As toto = new toto()
    t.foo = v1 + 3
    t.bar = v1 + 2
    t.blah = v1 + 1
    Return t
  End Function
  Function result(ByRef t_ as toto, ByRef t2_ as toto) As Integer
    Dim t As toto = t_
    Dim t2 As toto = t2_
    Dim t3 As toto = new toto()
    t3.foo = 0
    t3.bar = 0
    t3.blah = 0
    t3 = t2
    t = t2
    t2 = t3
    t.blah = t.blah + 1
    Dim len As Integer = 1
    Dim cache0(len - 1) As Integer
    For i As Integer = 0 To len - 1
        cache0(i) = -i
    Next
    Dim cache1(len - 1) As Integer
    For j As Integer = 0 To len - 1
        cache1(j) = j
    Next
    Dim cache2 As Integer() = cache0
    cache0 = cache1
    cache2 = cache0
    Return t.foo + t.blah * t.bar + t.bar * t.foo
    End Function
    Sub Main()
      Dim t As toto = mktoto(4)
      Dim t2 As toto = mktoto(5)
      t.bar = readInt
      stdin_sep
      t.blah = readInt
      stdin_sep
      t2.bar = readInt
      stdin_sep
      t2.blah = readInt
      Console.Write(result(t, t2) & t.blah)
    End Sub
    
    End Module
    
    
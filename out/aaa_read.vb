Imports System

Module aaa_read

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
Function readChar() As Char
  Dim out_ as Char = readChar_()
  consommeChar()
  Return out_
End Function

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
  'Ce test permet de vérifier si les différents backends pour les langages implémentent bien
  'read int, read char et skip
  '
  
  Sub Main()
    Dim len As Integer = readInt
    stdin_sep
    Console.Write(len & "=len" & Chr(10))
    len = len * 2
    Console.Write("len*2=" & len & Chr(10))
    len = len \ 2
    Dim tab(len - 1) As Integer
    For i As Integer = 0 To len - 1
        Dim tmpi1 As Integer = readInt
        stdin_sep
        Console.Write(i & "=>" & tmpi1 & " ")
        tab(i) = tmpi1
    Next
    Console.Write(Chr(10))
    Dim tab2(len - 1) As Integer
    For i_ As Integer = 0 To len - 1
        Dim tmpi2 As Integer = readInt
        stdin_sep
        Console.Write(i_ & "==>" & tmpi2 & " ")
        tab2(i_) = tmpi2
    Next
    Dim strlen As Integer = readInt
    stdin_sep
    Console.Write(strlen & "=strlen" & Chr(10))
    Dim tab4(strlen - 1) As Char
    For toto As Integer = 0 To strlen - 1
        Dim tmpc As Char = readChar
        Dim c As Integer = Asc(tmpc)
        Console.Write(tmpc & ":" & c & " ")
        If tmpc <> Chr(32) Then
            c = (c - Asc("a"C) + 13) Mod 26 + Asc("a"C)
        End If
        tab4(toto) = Chr(c)
    Next
    For j As Integer = 0 To strlen - 1
        Console.Write(tab4(j))
    Next
    End Sub
    
    End Module
     
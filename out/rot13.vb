Imports System

Module rot13

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
  'Ce test effectue un rot13 sur une chaine lue en entrée
  '
  
  Sub Main()
    Dim strlen As Integer = readInt
    stdin_sep
    Dim tab4(strlen - 1) As Char
    For toto As Integer = 0 To strlen - 1
        Dim tmpc As Char = readChar
        Dim c As Integer = Asc(tmpc)
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
  
  
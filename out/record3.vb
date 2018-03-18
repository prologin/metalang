Imports System

Module record3

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
  Public Class toto
    Public foo As Integer
    Public bar As Integer
    Public blah As Integer
  End Class
  Function mktoto(ByVal v1 as Integer) As toto
    Dim t As toto = new toto()
    t.foo = v1
    t.bar = 0
    t.blah = 0
    Return t
  End Function
  Function result(ByRef t as toto(), ByVal len as Integer) As Integer
    Dim out0 As Integer = 0
    For j As Integer = 0 To len - 1
        t(j).blah = t(j).blah + 1
        out0 = out0 + t(j).foo + t(j).blah * t(j).bar + t(j).bar * t(j).foo
    Next
    Return out0
  End Function
  Sub Main()
    Dim t(3) As toto
    For i As Integer = 0 To 3
        t(i) = mktoto(i)
    Next
    t(0).bar = readInt
    stdin_sep
    t(1).blah = readInt
    Dim titi As Integer = result(t, 4)
    Console.Write(titi & t(2).blah)
    End Sub
    
  End Module
  
  
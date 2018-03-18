Imports System

Module countchar

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
  Function nth(ByRef tab as Char(), ByVal tofind as Char, ByVal len as Integer) As Integer
    Dim out0 As Integer = 0
    For i As Integer = 0 To len - 1
        If tab(i) = tofind Then
            out0 = out0 + 1
        End If
    Next
    Return out0
  End Function
  Sub Main()
    Dim len As Integer = 0
    len = readInt
    stdin_sep
    Dim tofind As Char = Chr(0)
    tofind = readChar
    stdin_sep
    Dim tab(len - 1) As Char
    For i As Integer = 0 To len - 1
        Dim tmp As Char = Chr(0)
        tmp = readChar
        tab(i) = tmp
    Next
    Dim result As Integer = nth(tab, tofind, len)
    Console.Write(result)
    End Sub
    
  End Module
  
  
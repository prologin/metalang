Imports System

Module summax_souslist

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
  Function summax(ByRef lst as Integer(), ByVal len as Integer) As Integer
    Dim current As Integer = 0
    Dim max0 As Integer = 0
    For i As Integer = 0 To len - 1
        current = current + lst(i)
        If current < 0 Then
            current = 0
        End If
        If max0 < current Then
            max0 = current
        End If
    Next
    Return max0
  End Function
  Sub Main()
    Dim len As Integer = 0
    len = readInt
    stdin_sep
    Dim tab(len - 1) As Integer
    For i As Integer = 0 To len - 1
        Dim tmp As Integer = 0
        tmp = readInt
        stdin_sep
        tab(i) = tmp
    Next
    Dim result As Integer = summax(tab, len)
    Console.Write(result)
    End Sub
    
  End Module
  
  
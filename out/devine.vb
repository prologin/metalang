Imports System

Module devine

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
  Function devine0(ByVal nombre as Integer, ByRef tab as Integer(), ByVal len as Integer) As Boolean
    Dim min0 As Integer = tab(0)
    Dim max0 As Integer = tab(1)
    For i As Integer = 2 To len - 1
        If tab(i) > max0 OrElse tab(i) < min0 Then
            Return false
        End If
        If tab(i) < nombre Then
            min0 = tab(i)
        End If
        If tab(i) > nombre Then
            max0 = tab(i)
        End If
        If tab(i) = nombre AndAlso len <> i + 1 Then
            Return false
        End If
    Next
    Return true
  End Function
  Sub Main()
    Dim nombre As Integer = readInt
    stdin_sep
    Dim len As Integer = readInt
    stdin_sep
    Dim tab(len - 1) As Integer
    For i As Integer = 0 To len - 1
        Dim tmp As Integer = readInt
        stdin_sep
        tab(i) = tmp
    Next
    If devine0(nombre, tab, len) Then
        Console.Write("True")
    Else 
        Console.Write("False")
    End If
    End Sub
    
  End Module
  
  
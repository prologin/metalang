Imports System

Module plus_petit

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
  Function go0(ByRef tab as Integer(), ByVal a as Integer, ByVal b as Integer) As Integer
    Dim m As Integer = (a + b) \ 2
    If a = m Then
        If tab(a) = m Then
            Return b
        Else 
            Return a
        End If
    End If
    Dim i As Integer = a
    Dim j As Integer = b
    Do While i < j
        Dim e As Integer = tab(i)
        If e < m Then
            i = i + 1
        Else 
            j = j - 1
            tab(i) = tab(j)
            tab(j) = e
        End If
    Loop
    If i < m Then
        Return go0(tab, a, m)
    Else 
        Return go0(tab, m, b)
    End If
  End Function
  Function plus_petit0(ByRef tab as Integer(), ByVal len as Integer) As Integer
    Return go0(tab, 0, len)
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
    Console.Write(plus_petit0(tab, len))
    End Sub
    
  End Module
  
  
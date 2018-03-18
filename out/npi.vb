Imports System

Module npi

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
  Function is_number(ByVal c as Char) As Boolean
    Return Asc(c) <= Asc("9"C) AndAlso Asc(c) >= Asc("0"C)
  End Function
  '
  'Notation polonaise inversée, ce test permet d'évaluer une expression écrite en NPI
  '
  
  Function npi0(ByRef str as Char(), ByVal len as Integer) As Integer
    Dim stack(len - 1) As Integer
    For i As Integer = 0 To len - 1
        stack(i) = 0
    Next
    Dim ptrStack As Integer = 0
    Dim ptrStr As Integer = 0
    Do While ptrStr < len
        If str(ptrStr) = Chr(32) Then
            ptrStr = ptrStr + 1
        ElseIf is_number(str(ptrStr)) Then
            Dim num As Integer = 0
            Do While str(ptrStr) <> Chr(32)
                num = num * 10 + Asc(str(ptrStr)) - Asc("0"C)
                ptrStr = ptrStr + 1
            Loop
            stack(ptrStack) = num
            ptrStack = ptrStack + 1
        ElseIf str(ptrStr) = Chr(43) Then
            stack(ptrStack - 2) = stack(ptrStack - 2) + stack(ptrStack - 1)
            ptrStack = ptrStack - 1
            ptrStr = ptrStr + 1
        End If
    Loop
    Return stack(0)
    End Function
    Sub Main()
      Dim len As Integer = 0
      len = readInt
      stdin_sep
      Dim tab(len - 1) As Char
      For i As Integer = 0 To len - 1
          Dim tmp As Char = Chr(0)
          tmp = readChar
          tab(i) = tmp
      Next
      Dim result As Integer = npi0(tab, len)
      Console.Write(result)
      End Sub
      
    End Module
    
    
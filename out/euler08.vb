Imports System

Module euler08

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
  
  Sub Main()
    Dim i As Integer = 1
    Dim last(4) As Integer
    For j As Integer = 0 To 4
        Dim c As Char = readChar
        Dim d As Integer = Asc(c) - Asc("0"C)
        i = i * d
        last(j) = d
    Next
    Dim max0 As Integer = i
    Dim index As Integer = 0
    Dim nskipdiv As Integer = 0
    For k As Integer = 1 To 995
        Dim e As Char = readChar
        Dim f As Integer = Asc(e) - Asc("0"C)
        If f = 0 Then
            i = 1
            nskipdiv = 4
        Else 
            i = i * f
            If nskipdiv < 0 Then
                i = i \ last(index)
            End If
            nskipdiv = nskipdiv - 1
        End If
        last(index) = f
        index = (index + 1) Mod 5
        max0 = Math.Max(max0, i)
    Next
    Console.Write(max0 & Chr(10))
    End Sub
    
  End Module
  
  
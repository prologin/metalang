Imports System

Module pathfinding

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
  Function pathfind_aux(ByRef cache as Integer()(), ByRef tab as Char()(), ByVal x as Integer, ByVal y as Integer, ByVal posX as Integer, ByVal posY as Integer) As Integer
    If posX = x - 1 AndAlso posY = y - 1 Then
        Return 0
    ElseIf posX < 0 OrElse posY < 0 OrElse posX >= x OrElse posY >= y Then
        Return x * y * 10
    ElseIf tab(posY)(posX) = Chr(35) Then
        Return x * y * 10
    ElseIf cache(posY)(posX) <> -1 Then
        Return cache(posY)(posX)
    Else 
        cache(posY)(posX) = x * y * 10
        Dim val1 As Integer = pathfind_aux(cache, tab, x, y, posX + 1, posY)
        Dim val2 As Integer = pathfind_aux(cache, tab, x, y, posX - 1, posY)
        Dim val3 As Integer = pathfind_aux(cache, tab, x, y, posX, posY - 1)
        Dim val4 As Integer = pathfind_aux(cache, tab, x, y, posX, posY + 1)
        Dim out0 As Integer = 1 + Math.Min(Math.Min(Math.Min(val1, val2), val3), val4)
        cache(posY)(posX) = out0
        Return out0
    End If
  End Function
  Function pathfind(ByRef tab as Char()(), ByVal x as Integer, ByVal y as Integer) As Integer
    Dim cache(y - 1)() As Integer
    For i As Integer = 0 To y - 1
        Dim tmp(x - 1) As Integer
        For j As Integer = 0 To x - 1
            tmp(j) = -1
        Next
        cache(i) = tmp
        Next
        Return pathfind_aux(cache, tab, x, y, 0, 0)
    End Function
    Sub Main()
      Dim x As Integer = readInt
      stdin_sep
      Dim y As Integer = readInt
      stdin_sep
      Dim tab(y - 1)() As Char
      For i As Integer = 0 To y - 1
          Dim tab2(x - 1) As Char
          For j As Integer = 0 To x - 1
              Dim tmp As Char = Chr(0)
              tmp = readChar
              tab2(j) = tmp
          Next
          stdin_sep
          tab(i) = tab2
          Next
          Dim result As Integer = pathfind(tab, x, y)
          Console.Write(result)
      End Sub
      
      End Module
      
      
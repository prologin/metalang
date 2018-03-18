Imports System

Module pathfindList

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
  Function pathfind_aux(ByRef cache as Integer(), ByRef tab as Integer(), ByVal len as Integer, ByVal pos as Integer) As Integer
    If pos >= len - 1 Then
        Return 0
    ElseIf cache(pos) <> -1 Then
        Return cache(pos)
    Else 
        cache(pos) = len * 2
        Dim posval As Integer = pathfind_aux(cache, tab, len, tab(pos))
        Dim oneval As Integer = pathfind_aux(cache, tab, len, pos + 1)
        Dim out0 As Integer = 0
        If posval < oneval Then
            out0 = 1 + posval
        Else 
            out0 = 1 + oneval
        End If
        cache(pos) = out0
        Return out0
    End If
  End Function
  Function pathfind(ByRef tab as Integer(), ByVal len as Integer) As Integer
    Dim cache(len - 1) As Integer
    For i As Integer = 0 To len - 1
        cache(i) = -1
    Next
    Return pathfind_aux(cache, tab, len, 0)
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
      Dim result As Integer = pathfind(tab, len)
      Console.Write(result)
      End Sub
      
    End Module
    
    
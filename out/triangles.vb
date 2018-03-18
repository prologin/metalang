Imports System

Module triangles

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
  ' Ce code a été généré par metalang
  '   Il gère les entrées sorties pour un programme dynamique classique
  '   dans les épreuves de prologin
  'on le retrouve ici : http://projecteuler.net/problem=18
  '
  
  Function find0(ByVal len as Integer, ByRef tab as Integer()(), ByRef cache as Integer()(), ByVal x as Integer, ByVal y as Integer) As Integer
    '
    '	Cette fonction est récursive
    '	
    
    If y = len - 1 Then
        Return tab(y)(x)
    ElseIf x > y Then
        Return -10000
    ElseIf cache(y)(x) <> 0 Then
        Return cache(y)(x)
    End If
    Dim result As Integer = 0
    Dim out0 As Integer = find0(len, tab, cache, x, y + 1)
    Dim out1 As Integer = find0(len, tab, cache, x + 1, y + 1)
    If out0 > out1 Then
        result = out0 + tab(y)(x)
    Else 
        result = out1 + tab(y)(x)
    End If
    cache(y)(x) = result
    Return result
  End Function
  Function find(ByVal len as Integer, ByRef tab as Integer()()) As Integer
    Dim tab2(len - 1)() As Integer
    For i As Integer = 0 To len - 1
        Dim tab3(i) As Integer
        For j As Integer = 0 To i
            tab3(j) = 0
        Next
        tab2(i) = tab3
        Next
        Return find0(len, tab, tab2, 0, 0)
    End Function
    Sub Main()
      Dim len As Integer = readInt
      stdin_sep
      Dim tab(len - 1)() As Integer
      For i As Integer = 0 To len - 1
          Dim tab2(i) As Integer
          For j As Integer = 0 To i
              Dim tmp As Integer = readInt
              stdin_sep
              tab2(j) = tmp
          Next
          tab(i) = tab2
          Next
          Console.Write(find(len, tab) & Chr(10))
          For k As Integer = 0 To len - 1
              For l As Integer = 0 To k
                  Console.Write(tab(k)(l) & " ")
              Next
              Console.Write(Chr(10))
          Next
      End Sub
      
      End Module
      
      
Imports System

Module vigenere

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
  Function position_alphabet(ByVal c as Char) As Integer
    Dim i As Integer = Asc(c)
    If i <= Asc("Z"C) AndAlso i >= Asc("A"C) Then
        Return i - Asc("A"C)
    ElseIf i <= Asc("z"C) AndAlso i >= Asc("a"C) Then
        Return i - Asc("a"C)
    Else 
        Return -1
    End If
  End Function
  Function of_position_alphabet(ByVal c as Integer) As Char
    Return Chr(c + Asc("a"C))
  End Function
  Sub crypte(ByVal taille_cle as Integer, ByRef cle as Char(), ByVal taille as Integer, ByRef message as Char())
    For i As Integer = 0 To taille - 1
        Dim lettre As Integer = position_alphabet(message(i))
        If lettre <> -1 Then
            Dim addon As Integer = position_alphabet(cle(i Mod taille_cle))
            Dim new0 As Integer = (addon + lettre) Mod 26
            message(i) = of_position_alphabet(new0)
        End If
    Next
  End Sub
  Sub Main()
    Dim taille_cle As Integer = readInt
    stdin_sep
    Dim cle(taille_cle - 1) As Char
    For index As Integer = 0 To taille_cle - 1
        Dim out0 As Char = readChar
        cle(index) = out0
    Next
    stdin_sep
    Dim taille As Integer = readInt
    stdin_sep
    Dim message(taille - 1) As Char
    For index2 As Integer = 0 To taille - 1
        Dim out2 As Char = readChar
        message(index2) = out2
    Next
    crypte(taille_cle, cle, taille, message)
    For i As Integer = 0 To taille - 1
        Console.Write(message(i))
    Next
    Console.Write(Chr(10))
    End Sub
    
    End Module
    
    
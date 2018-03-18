Imports System

Module cambriolage

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
  Function nbPassePartout(ByVal n as Integer, ByRef passepartout as Integer()(), ByVal m as Integer, ByRef serrures as Integer()()) As Integer
    Dim max_ancient As Integer = 0
    Dim max_recent As Integer = 0
    For i As Integer = 0 To m - 1
        If serrures(i)(0) = -1 AndAlso serrures(i)(1) > max_ancient Then
            max_ancient = serrures(i)(1)
        End If
        If serrures(i)(0) = 1 AndAlso serrures(i)(1) > max_recent Then
            max_recent = serrures(i)(1)
        End If
    Next
    Dim max_ancient_pp As Integer = 0
    Dim max_recent_pp As Integer = 0
    For i As Integer = 0 To n - 1
        Dim pp As Integer() = passepartout(i)
        If pp(0) >= max_ancient AndAlso pp(1) >= max_recent Then
            Return 1
        End If
        max_ancient_pp = Math.Max(max_ancient_pp, pp(0))
        max_recent_pp = Math.Max(max_recent_pp, pp(1))
    Next
    If max_ancient_pp >= max_ancient AndAlso max_recent_pp >= max_recent Then
        Return 2
    Else 
        Return 0
    End If
  End Function
  Sub Main()
    Dim n As Integer = readInt
    stdin_sep
    Dim passepartout(n - 1)() As Integer
    For i As Integer = 0 To n - 1
        Dim out0(1) As Integer
        For j As Integer = 0 To 1
            Dim out01 As Integer = readInt
            stdin_sep
            out0(j) = out01
        Next
        passepartout(i) = out0
        Next
        Dim m As Integer = readInt
        stdin_sep
        Dim serrures(m - 1)() As Integer
        For k As Integer = 0 To m - 1
            Dim out1(1) As Integer
            For l As Integer = 0 To 1
                Dim out_ As Integer = readInt
                stdin_sep
                out1(l) = out_
            Next
            serrures(k) = out1
            Next
            Console.Write(nbPassePartout(n, passepartout, m, serrures))
        End Sub
        
        End Module
        
        
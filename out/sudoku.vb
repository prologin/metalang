Imports System

Module sudoku

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
  ' lit un sudoku sur l'entrée standard 
  
  Function read_sudoku() As Integer()
    Dim out0(9 * 9 - 1) As Integer
    For i As Integer = 0 To 9 * 9 - 1
        Dim k As Integer = readInt
        stdin_sep
        out0(i) = k
    Next
    Return out0
    End Function
    ' affiche un sudoku 
    
    Sub print_sudoku(ByRef sudoku0 as Integer())
      For y As Integer = 0 To 8
          For x As Integer = 0 To 8
              Console.Write(sudoku0(x + y * 9) & " ")
              If x Mod 3 = 2 Then
                  Console.Write(" ")
              End If
          Next
          Console.Write(Chr(10))
          If y Mod 3 = 2 Then
              Console.Write(Chr(10))
          End If
      Next
      Console.Write(Chr(10))
    End Sub
    ' dit si les variables sont toutes différentes 
    
    ' dit si les variables sont toutes différentes 
    
    ' dit si le sudoku est terminé de remplir 
    
    Function sudoku_done(ByRef s as Integer()) As Boolean
      For i As Integer = 0 To 80
          If s(i) = 0 Then
              Return false
          End If
      Next
      Return true
    End Function
    ' dit si il y a une erreur dans le sudoku 
    
    Function sudoku_error(ByRef s as Integer()) As Boolean
      Dim out1 As Boolean = false
      For x As Integer = 0 To 8
          out1 = out1 OrElse s(x) <> 0 AndAlso s(x) = s(x + 9) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 2) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 2) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 3) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 3) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 3) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 4) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 4) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 4) OrElse s(x + 9 * 3) <> 0 AndAlso s(x + 9 * 3) = s(x + 9 * 4) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 5) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 5) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 5) OrElse s(x + 9 * 3) <> 0 AndAlso s(x + 9 * 3) = s(x + 9 * 5) OrElse s(x + 9 * 4) <> 0 AndAlso s(x + 9 * 4) = s(x + 9 * 5) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 6) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 6) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 6) OrElse s(x + 9 * 3) <> 0 AndAlso s(x + 9 * 3) = s(x + 9 * 6) OrElse s(x + 9 * 4) <> 0 AndAlso s(x + 9 * 4) = s(x + 9 * 6) OrElse s(x + 9 * 5) <> 0 AndAlso s(x + 9 * 5) = s(x + 9 * 6) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 7) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 7) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 7) OrElse s(x + 9 * 3) <> 0 AndAlso s(x + 9 * 3) = s(x + 9 * 7) OrElse s(x + 9 * 4) <> 0 AndAlso s(x + 9 * 4) = s(x + 9 * 7) OrElse s(x + 9 * 5) <> 0 AndAlso s(x + 9 * 5) = s(x + 9 * 7) OrElse s(x + 9 * 6) <> 0 AndAlso s(x + 9 * 6) = s(x + 9 * 7) OrElse s(x) <> 0 AndAlso s(x) = s(x + 9 * 8) OrElse s(x + 9) <> 0 AndAlso s(x + 9) = s(x + 9 * 8) OrElse s(x + 9 * 2) <> 0 AndAlso s(x + 9 * 2) = s(x + 9 * 8) OrElse s(x + 9 * 3) <> 0 AndAlso s(x + 9 * 3) = s(x + 9 * 8) OrElse s(x + 9 * 4) <> 0 AndAlso s(x + 9 * 4) = s(x + 9 * 8) OrElse s(x + 9 * 5) <> 0 AndAlso s(x + 9 * 5) = s(x + 9 * 8) OrElse s(x + 9 * 6) <> 0 AndAlso s(x + 9 * 6) = s(x + 9 * 8) OrElse s(x + 9 * 7) <> 0 AndAlso s(x + 9 * 7) = s(x + 9 * 8)
      Next
      Dim out2 As Boolean = false
      For x As Integer = 0 To 8
          out2 = out2 OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 1) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 2) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 2) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 3) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 3) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 3) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 4) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 4) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 4) OrElse s(x * 9 + 3) <> 0 AndAlso s(x * 9 + 3) = s(x * 9 + 4) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 5) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 5) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 5) OrElse s(x * 9 + 3) <> 0 AndAlso s(x * 9 + 3) = s(x * 9 + 5) OrElse s(x * 9 + 4) <> 0 AndAlso s(x * 9 + 4) = s(x * 9 + 5) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 6) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 6) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 6) OrElse s(x * 9 + 3) <> 0 AndAlso s(x * 9 + 3) = s(x * 9 + 6) OrElse s(x * 9 + 4) <> 0 AndAlso s(x * 9 + 4) = s(x * 9 + 6) OrElse s(x * 9 + 5) <> 0 AndAlso s(x * 9 + 5) = s(x * 9 + 6) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 7) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 7) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 7) OrElse s(x * 9 + 3) <> 0 AndAlso s(x * 9 + 3) = s(x * 9 + 7) OrElse s(x * 9 + 4) <> 0 AndAlso s(x * 9 + 4) = s(x * 9 + 7) OrElse s(x * 9 + 5) <> 0 AndAlso s(x * 9 + 5) = s(x * 9 + 7) OrElse s(x * 9 + 6) <> 0 AndAlso s(x * 9 + 6) = s(x * 9 + 7) OrElse s(x * 9) <> 0 AndAlso s(x * 9) = s(x * 9 + 8) OrElse s(x * 9 + 1) <> 0 AndAlso s(x * 9 + 1) = s(x * 9 + 8) OrElse s(x * 9 + 2) <> 0 AndAlso s(x * 9 + 2) = s(x * 9 + 8) OrElse s(x * 9 + 3) <> 0 AndAlso s(x * 9 + 3) = s(x * 9 + 8) OrElse s(x * 9 + 4) <> 0 AndAlso s(x * 9 + 4) = s(x * 9 + 8) OrElse s(x * 9 + 5) <> 0 AndAlso s(x * 9 + 5) = s(x * 9 + 8) OrElse s(x * 9 + 6) <> 0 AndAlso s(x * 9 + 6) = s(x * 9 + 8) OrElse s(x * 9 + 7) <> 0 AndAlso s(x * 9 + 7) = s(x * 9 + 8)
      Next
      Dim out3 As Boolean = false
      For x As Integer = 0 To 8
          out3 = out3 OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s((x Mod 3) * 3 * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) <> 0 AndAlso s(((x Mod 3) * 3 + 1) * 9 + (x \ 3) * 3 + 2) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) <> 0 AndAlso s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2) OrElse s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) <> 0 AndAlso s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 1) = s(((x Mod 3) * 3 + 2) * 9 + (x \ 3) * 3 + 2)
      Next
      Return out1 OrElse out2 OrElse out3
    End Function
    ' résout le sudoku
    
    Function solve(ByRef sudoku0 as Integer()) As Boolean
      If sudoku_error(sudoku0) Then
          Return false
      End If
      If sudoku_done(sudoku0) Then
          Return true
      End If
      For i As Integer = 0 To 80
          If sudoku0(i) = 0 Then
              For p As Integer = 1 To 9
                  sudoku0(i) = p
                  If solve(sudoku0) Then
                      Return true
                  End If
              Next
              sudoku0(i) = 0
              Return false
          End If
      Next
      Return false
    End Function
    Sub Main()
      Dim sudoku0 As Integer() = read_sudoku()
      print_sudoku(sudoku0)
      If solve(sudoku0) Then
          print_sudoku(sudoku0)
      Else 
          Console.Write("no solution" & Chr(10))
      End If
    End Sub
    
  End Module
  
  
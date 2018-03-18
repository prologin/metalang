Imports System

Module sort

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
  Function copytab(ByRef tab as Integer(), ByVal len as Integer) As Integer()
    Dim o(len - 1) As Integer
    For i As Integer = 0 To len - 1
        o(i) = tab(i)
    Next
    Return o
    End Function
    Sub bubblesort(ByRef tab as Integer(), ByVal len as Integer)
      For i As Integer = 0 To len - 1
          For j As Integer = i + 1 To len - 1
              If tab(i) > tab(j) Then
                  Dim tmp As Integer = tab(i)
                  tab(i) = tab(j)
                  tab(j) = tmp
              End If
          Next
      Next
    End Sub
    Sub qsort0(ByRef tab as Integer(), ByVal len as Integer, ByVal i as Integer, ByVal j as Integer)
      If i < j Then
          Dim i0 As Integer = i
          Dim j0 As Integer = j
          ' pivot : tab[0] 
          
          Do While i <> j
              If tab(i) > tab(j) Then
                  If i = j - 1 Then
                      ' on inverse simplement
                      
                      Dim tmp As Integer = tab(i)
                      tab(i) = tab(j)
                      tab(j) = tmp
                      i = i + 1
                  Else 
                      ' on place tab[i+1] à la place de tab[j], tab[j] à la place de tab[i] et tab[i] à la place de tab[i+1] 
                      
                      Dim tmp As Integer = tab(i)
                      tab(i) = tab(j)
                      tab(j) = tab(i + 1)
                      tab(i + 1) = tmp
                      i = i + 1
                  End If
              Else 
                  j = j - 1
              End If
          Loop
          qsort0(tab, len, i0, i - 1)
          qsort0(tab, len, i + 1, j0)
      End If
    End Sub
    Sub Main()
      Dim len As Integer = 2
      len = readInt
      stdin_sep
      Dim tab(len - 1) As Integer
      For i_ As Integer = 0 To len - 1
          Dim tmp As Integer = 0
          tmp = readInt
          stdin_sep
          tab(i_) = tmp
      Next
      Dim tab2 As Integer() = copytab(tab, len)
      bubblesort(tab2, len)
      For i As Integer = 0 To len - 1
          Console.Write(tab2(i) & " ")
      Next
      Console.Write(Chr(10))
      Dim tab3 As Integer() = copytab(tab, len)
      qsort0(tab3, len, 0, len - 1)
      For i As Integer = 0 To len - 1
          Console.Write(tab3(i) & " ")
      Next
      Console.Write(Chr(10))
      End Sub
      
    End Module
    
    
Imports System

Module euler36

  Function palindrome2(ByRef pow2 as Integer(), ByVal n as Integer) As Boolean
    Dim t(19) As Boolean
    For i As Integer = 0 To 19
        t(i) = n \ pow2(i) Mod 2 = 1
    Next
    Dim nnum As Integer = 0
    For j As Integer = 1 To 19
        If t(j) Then
            nnum = j
        End If
    Next
    For k As Integer = 0 To nnum \ 2
        If t(k) <> t(nnum - k) Then
            Return false
        End If
    Next
    Return true
    End Function
    Sub Main()
      Dim p As Integer = 1
      Dim pow2(19) As Integer
      For i As Integer = 0 To 19
          p = p * 2
          pow2(i) = p \ 2
      Next
      Dim sum As Integer = 0
      For d As Integer = 1 To 9
          If palindrome2(pow2, d) Then
              Console.Write(d & Chr(10))
              sum = sum + d
          End If
          If palindrome2(pow2, d * 10 + d) Then
              Console.Write((d * 10 + d) & Chr(10))
              sum = sum + d * 10 + d
          End If
      Next
      For a0 As Integer = 0 To 4
          Dim a As Integer = a0 * 2 + 1
          For b As Integer = 0 To 9
              For c As Integer = 0 To 9
                  Dim num0 As Integer = a * 100000 + b * 10000 + c * 1000 + c * 100 + b * 10 + a
                  If palindrome2(pow2, num0) Then
                      Console.Write(num0 & Chr(10))
                      sum = sum + num0
                  End If
                  Dim num1 As Integer = a * 10000 + b * 1000 + c * 100 + b * 10 + a
                  If palindrome2(pow2, num1) Then
                      Console.Write(num1 & Chr(10))
                      sum = sum + num1
                  End If
              Next
              Dim num2 As Integer = a * 100 + b * 10 + a
              If palindrome2(pow2, num2) Then
                  Console.Write(num2 & Chr(10))
                  sum = sum + num2
              End If
              Dim num3 As Integer = a * 1000 + b * 100 + b * 10 + a
              If palindrome2(pow2, num3) Then
                  Console.Write(num3 & Chr(10))
                  sum = sum + num3
              End If
          Next
      Next
      Console.Write("sum=" & sum & Chr(10))
      End Sub
      
    End Module
    
    
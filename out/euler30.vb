Imports System

Module euler30

  
  Sub Main()
    '
    'a + b * 10 + c * 100 + d * 1000 + e * 10 000 =
    '  a ^ 5 +
    '  b ^ 5 +
    '  c ^ 5 +
    '  d ^ 5 +
    '  e ^ 5
    '
    
    Dim p(9) As Integer
    For i As Integer = 0 To 9
        p(i) = i * i * i * i * i
    Next
    Dim sum As Integer = 0
    For a As Integer = 0 To 9
        For b As Integer = 0 To 9
            For c As Integer = 0 To 9
                For d As Integer = 0 To 9
                    For e As Integer = 0 To 9
                        For f As Integer = 0 To 9
                            Dim s As Integer = p(a) + p(b) + p(c) + p(d) + p(e) + p(f)
                            Dim r As Integer = a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000
                            If s = r AndAlso r <> 1 Then
                                Console.Write(f & e & d & c & b & a & " " & r & Chr(10))
                                sum = sum + r
                            End If
                        Next
                    Next
                Next
            Next
        Next
    Next
    Console.Write(sum)
    End Sub
    
  End Module
  
  
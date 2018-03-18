Imports System

Module euler34

  
  Sub Main()
    Dim f(9) As Integer
    For j As Integer = 0 To 9
        f(j) = 1
    Next
    For i As Integer = 1 To 9
        f(i) = f(i) * i * f(i - 1)
        Console.Write(f(i) & " ")
    Next
    Dim out0 As Integer = 0
    Console.Write(Chr(10))
    For a As Integer = 0 To 9
        For b As Integer = 0 To 9
            For c As Integer = 0 To 9
                For d As Integer = 0 To 9
                    For e As Integer = 0 To 9
                        For g As Integer = 0 To 9
                            Dim sum As Integer = f(a) + f(b) + f(c) + f(d) + f(e) + f(g)
                            Dim num As Integer = ((((a * 10 + b) * 10 + c) * 10 + d) * 10 + e) * 10 + g
                            If a = 0 Then
                                sum = sum - 1
                                If b = 0 Then
                                    sum = sum - 1
                                    If c = 0 Then
                                        sum = sum - 1
                                        If d = 0 Then
                                            sum = sum - 1
                                        End If
                                    End If
                                End If
                            End If
                            If sum = num AndAlso sum <> 1 AndAlso sum <> 2 Then
                                out0 = out0 + num
                                Console.Write(num & " ")
                            End If
                        Next
                    Next
                Next
            Next
        Next
    Next
    Console.Write(Chr(10) & out0 & Chr(10))
    End Sub
    
  End Module
  
  
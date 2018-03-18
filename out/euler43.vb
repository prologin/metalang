Imports System

Module euler43

  
  Sub Main()
    '
    'The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.
    '
    'Let d1 be the 1st digit, d2 be the 2nd digit, and so on. In this way, we note the following:
    '
    'd2d3d4=406 is divisible by 2
    'd3d4d5=063 is divisible by 3
    'd4d5d6=635 is divisible by 5
    'd5d6d7=357 is divisible by 7
    'd6d7d8=572 is divisible by 11
    'd7d8d9=728 is divisible by 13
    'd8d9d10=289 is divisible by 17
    'Find the sum of all 0 to 9 pandigital numbers with this property.
    '
    'd4 % 2 == 0
    '(d3 + d4 + d5) % 3 == 0
    'd6 = 5 ou d6 = 0
    '(d5 * 100 + d6 * 10 + d7  ) % 7 == 0
    '(d6 * 100 + d7 * 10 + d8  ) % 11 == 0
    '(d7 * 100 + d8 * 10 + d9  ) % 13 == 0
    '(d8 * 100 + d9 * 10 + d10 ) % 17 == 0
    '
    '
    'd4 % 2 == 0
    'd6 = 5 ou d6 = 0
    '
    '(d3 + d4 + d5) % 3 == 0
    '(d5 * 2 + d6 * 3 + d7) % 7 == 0
    '
    
    Dim allowed(9) As Boolean
    For i As Integer = 0 To 9
        allowed(i) = true
    Next
    For i6 As Integer = 0 To 1
        Dim d6 As Integer = i6 * 5
        If allowed(d6) Then
            allowed(d6) = false
            For d7 As Integer = 0 To 9
                If allowed(d7) Then
                    allowed(d7) = false
                    For d8 As Integer = 0 To 9
                        If allowed(d8) Then
                            allowed(d8) = false
                            For d9 As Integer = 0 To 9
                                If allowed(d9) Then
                                    allowed(d9) = false
                                    For d10 As Integer = 1 To 9
                                        If allowed(d10) AndAlso (d6 * 100 + d7 * 10 + d8) Mod 11 = 0 AndAlso (d7 * 100 + d8 * 10 + d9) Mod 13 = 0 AndAlso (d8 * 100 + d9 * 10 + d10) Mod 17 = 0 Then
                                            allowed(d10) = false
                                            For d5 As Integer = 0 To 9
                                                If allowed(d5) Then
                                                    allowed(d5) = false
                                                    If (d5 * 100 + d6 * 10 + d7) Mod 7 = 0 Then
                                                        For i4 As Integer = 0 To 4
                                                            Dim d4 As Integer = i4 * 2
                                                            If allowed(d4) Then
                                                                allowed(d4) = false
                                                                For d3 As Integer = 0 To 9
                                                                    If allowed(d3) Then
                                                                        allowed(d3) = false
                                                                        If (d3 + d4 + d5) Mod 3 = 0 Then
                                                                            For d2 As Integer = 0 To 9
                                                                                If allowed(d2) Then
                                                                                    allowed(d2) = false
                                                                                    For d1 As Integer = 0 To 9
                                                                                        If allowed(d1) Then
                                                                                            allowed(d1) = false
                                                                                            Console.Write(d1 & d2 & d3 & d4 & d5 & d6 & d7 & d8 & d9 & d10 & " + ")
                                                                                            allowed(d1) = true
                                                                                        End If
                                                                                    Next
                                                                                    allowed(d2) = true
                                                                                End If
                                                                            Next
                                                                        End If
                                                                        allowed(d3) = true
                                                                    End If
                                                                Next
                                                                allowed(d4) = true
                                                            End If
                                                        Next
                                                    End If
                                                    allowed(d5) = true
                                                End If
                                            Next
                                            allowed(d10) = true
                                        End If
                                    Next
                                    allowed(d9) = true
                                End If
                            Next
                            allowed(d8) = true
                        End If
                    Next
                    allowed(d7) = true
                End If
            Next
            allowed(d6) = true
        End If
    Next
    Console.Write(0 & Chr(10))
    End Sub
    
  End Module
  
  
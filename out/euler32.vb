Imports System

Module euler32

  '
  'We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once;
  'for example, the 5-digit number, 15234, is 1 through 5 pandigital.
  '
  'The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier,
  'and product is 1 through 9 pandigital.
  '
  'Find the sum of all products whose multiplicand/multiplier/product identity can be written as a
  '1 through 9 pandigital.
  '
  'HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.
  '
  '
  '(a * 10 + b) ( c * 100 + d * 10 + e) =
  '  a * c * 1000 +
  '  a * d * 100 +
  '  a * e * 10 +
  '  b * c * 100 +
  '  b * d * 10 +
  '  b * e
  '  => b != e != b * e % 10 ET
  '  a != d != (b * e / 10 + b * d + a * e ) % 10
  '
  
  Function okdigits(ByRef ok as Boolean(), ByVal n as Integer) As Boolean
    If n = 0 Then
        Return true
    Else 
        Dim digit As Integer = n Mod 10
        If ok(digit) Then
            ok(digit) = false
            Dim o As Boolean = okdigits(ok, n \ 10)
            ok(digit) = true
            Return o
        Else 
            Return false
        End If
    End If
  End Function
  Sub Main()
    Dim count As Integer = 0
    Dim allowed(9) As Boolean
    For i As Integer = 0 To 9
        allowed(i) = i <> 0
    Next
    Dim counted(99999) As Boolean
    For j As Integer = 0 To 99999
        counted(j) = false
    Next
    For e As Integer = 1 To 9
        allowed(e) = false
        For b As Integer = 1 To 9
            If allowed(b) Then
                allowed(b) = false
                Dim be As Integer = b * e Mod 10
                If allowed(be) Then
                    allowed(be) = false
                    For a As Integer = 1 To 9
                        If allowed(a) Then
                            allowed(a) = false
                            For c As Integer = 1 To 9
                                If allowed(c) Then
                                    allowed(c) = false
                                    For d As Integer = 1 To 9
                                        If allowed(d) Then
                                            allowed(d) = false
                                            ' 2 * 3 digits 
                                            
                                            Dim product As Integer = (a * 10 + b) * (c * 100 + d * 10 + e)
                                            If Not counted(product) AndAlso okdigits(allowed, product \ 10) Then
                                                counted(product) = true
                                                count = count + product
                                                Console.Write(product & " ")
                                            End If
                                            ' 1  * 4 digits 
                                            
                                            Dim product2 As Integer = b * (a * 1000 + c * 100 + d * 10 + e)
                                            If Not counted(product2) AndAlso okdigits(allowed, product2 \ 10) Then
                                                counted(product2) = true
                                                count = count + product2
                                                Console.Write(product2 & " ")
                                            End If
                                            allowed(d) = true
                                        End If
                                    Next
                                    allowed(c) = true
                                End If
                            Next
                            allowed(a) = true
                        End If
                    Next
                    allowed(be) = true
                End If
                allowed(b) = true
            End If
        Next
        allowed(e) = true
    Next
    Console.Write(count & Chr(10))
    End Sub
    
    End Module
    
    
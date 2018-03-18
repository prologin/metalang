Imports System

Module bigints

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
  Public Class bigint
    Public bigint_sign As Boolean
    Public bigint_len As Integer
    Public bigint_chiffres As Integer()
  End Class
  Function read_bigint(ByVal len as Integer) As bigint
    Dim chiffres(len - 1) As Integer
    For j As Integer = 0 To len - 1
        Dim c As Char = readChar
        chiffres(j) = Asc(c)
    Next
    For i As Integer = 0 To (len - 1) \ 2
        Dim tmp As Integer = chiffres(i)
        chiffres(i) = chiffres(len - 1 - i)
        chiffres(len - 1 - i) = tmp
    Next
    Dim e As bigint = new bigint()
    e.bigint_sign = true
    e.bigint_len = len
    e.bigint_chiffres = chiffres
    Return e
    End Function
    Sub print_bigint(ByRef a as bigint)
      If Not a.bigint_sign Then
          Console.Write("-"C)
      End If
      For i As Integer = 0 To a.bigint_len - 1
          Console.Write(a.bigint_chiffres(a.bigint_len - 1 - i))
      Next
    End Sub
    Function bigint_eq(ByRef a as bigint, ByRef b as bigint) As Boolean
      ' Renvoie vrai si a = b 
      
      If a.bigint_sign <> b.bigint_sign Then
          Return false
      ElseIf a.bigint_len <> b.bigint_len Then
          Return false
      Else 
          For i As Integer = 0 To a.bigint_len - 1
              If a.bigint_chiffres(i) <> b.bigint_chiffres(i) Then
                  Return false
              End If
          Next
          Return true
      End If
    End Function
    Function bigint_gt(ByRef a as bigint, ByRef b as bigint) As Boolean
      ' Renvoie vrai si a > b 
      
      If a.bigint_sign AndAlso Not b.bigint_sign Then
          Return true
      ElseIf Not a.bigint_sign AndAlso b.bigint_sign Then
          Return false
      Else 
          If a.bigint_len > b.bigint_len Then
              Return a.bigint_sign
          ElseIf a.bigint_len < b.bigint_len Then
              Return Not a.bigint_sign
          Else 
              For i As Integer = 0 To a.bigint_len - 1
                  Dim j As Integer = a.bigint_len - 1 - i
                  If a.bigint_chiffres(j) > b.bigint_chiffres(j) Then
                      Return a.bigint_sign
                  ElseIf a.bigint_chiffres(j) < b.bigint_chiffres(j) Then
                      Return Not a.bigint_sign
                  End If
              Next
          End If
          Return true
      End If
    End Function
    Function bigint_lt(ByRef a as bigint, ByRef b as bigint) As Boolean
      Return Not bigint_gt(a, b)
    End Function
    Function add_bigint_positif(ByRef a as bigint, ByRef b as bigint) As bigint
      ' Une addition ou on en a rien a faire des signes 
      
      Dim len As Integer = Math.Max(a.bigint_len, b.bigint_len) + 1
      Dim retenue As Integer = 0
      Dim chiffres(len - 1) As Integer
      For i As Integer = 0 To len - 1
          Dim tmp As Integer = retenue
          If i < a.bigint_len Then
              tmp = tmp + a.bigint_chiffres(i)
          End If
          If i < b.bigint_len Then
              tmp = tmp + b.bigint_chiffres(i)
          End If
          retenue = tmp \ 10
          chiffres(i) = tmp Mod 10
      Next
      Do While len > 0 AndAlso chiffres(len - 1) = 0
          len = len - 1
      Loop
      Dim f As bigint = new bigint()
      f.bigint_sign = true
      f.bigint_len = len
      f.bigint_chiffres = chiffres
      Return f
      End Function
      Function sub_bigint_positif(ByRef a as bigint, ByRef b as bigint) As bigint
        ' Une soustraction ou on en a rien a faire des signes
        'Pré-requis : a > b
        '
        
        Dim len As Integer = a.bigint_len
        Dim retenue As Integer = 0
        Dim chiffres(len - 1) As Integer
        For i As Integer = 0 To len - 1
            Dim tmp As Integer = retenue + a.bigint_chiffres(i)
            If i < b.bigint_len Then
                tmp = tmp - b.bigint_chiffres(i)
            End If
            If tmp < 0 Then
                tmp = tmp + 10
                retenue = -1
            Else 
                retenue = 0
            End If
            chiffres(i) = tmp
        Next
        Do While len > 0 AndAlso chiffres(len - 1) = 0
            len = len - 1
        Loop
        Dim g As bigint = new bigint()
        g.bigint_sign = true
        g.bigint_len = len
        g.bigint_chiffres = chiffres
        Return g
        End Function
        Function neg_bigint(ByRef a as bigint) As bigint
          Dim h As bigint = new bigint()
          h.bigint_sign = Not a.bigint_sign
          h.bigint_len = a.bigint_len
          h.bigint_chiffres = a.bigint_chiffres
          Return h
        End Function
        Function add_bigint(ByRef a as bigint, ByRef b as bigint) As bigint
          If a.bigint_sign = b.bigint_sign Then
              If a.bigint_sign Then
                  Return add_bigint_positif(a, b)
              Else 
                  Return neg_bigint(add_bigint_positif(a, b))
              End If
          ElseIf a.bigint_sign Then
              ' a positif, b negatif 
              
              If bigint_gt(a, neg_bigint(b)) Then
                  Return sub_bigint_positif(a, b)
              Else 
                  Return neg_bigint(sub_bigint_positif(b, a))
              End If
          Else 
              ' a negatif, b positif 
              
              If bigint_gt(neg_bigint(a), b) Then
                  Return neg_bigint(sub_bigint_positif(a, b))
              Else 
                  Return sub_bigint_positif(b, a)
              End If
          End If
        End Function
        Function sub_bigint(ByRef a as bigint, ByRef b as bigint) As bigint
          Return add_bigint(a, neg_bigint(b))
        End Function
        Function mul_bigint_cp(ByRef a as bigint, ByRef b as bigint) As bigint
          ' Cet algorithm est quadratique.
          'C'est le même que celui qu'on enseigne aux enfants en CP.
          'D'ou le nom de la fonction. 
          
          Dim len As Integer = a.bigint_len + b.bigint_len + 1
          Dim chiffres(len - 1) As Integer
          For k As Integer = 0 To len - 1
              chiffres(k) = 0
          Next
          For i As Integer = 0 To a.bigint_len - 1
              Dim retenue As Integer = 0
              For j As Integer = 0 To b.bigint_len - 1
                  chiffres(i + j) = chiffres(i + j) + retenue + b.bigint_chiffres(j) * a.bigint_chiffres(i)
                  retenue = chiffres(i + j) \ 10
                  chiffres(i + j) = chiffres(i + j) Mod 10
              Next
              chiffres(i + b.bigint_len) = chiffres(i + b.bigint_len) + retenue
          Next
          chiffres(a.bigint_len + b.bigint_len) = chiffres(a.bigint_len + b.bigint_len - 1) \ 10
          chiffres(a.bigint_len + b.bigint_len - 1) = chiffres(a.bigint_len + b.bigint_len - 1) Mod 10
          For l As Integer = 0 To 2
              If len <> 0 AndAlso chiffres(len - 1) = 0 Then
                  len = len - 1
              End If
          Next
          Dim m As bigint = new bigint()
          m.bigint_sign = a.bigint_sign = b.bigint_sign
          m.bigint_len = len
          m.bigint_chiffres = chiffres
          Return m
          End Function
          Function bigint_premiers_chiffres(ByRef a as bigint, ByVal i as Integer) As bigint
            Dim len As Integer = Math.Min(i, a.bigint_len)
            Do While len <> 0 AndAlso a.bigint_chiffres(len - 1) = 0
                len = len - 1
            Loop
            Dim o As bigint = new bigint()
            o.bigint_sign = a.bigint_sign
            o.bigint_len = len
            o.bigint_chiffres = a.bigint_chiffres
            Return o
          End Function
          Function bigint_shift(ByRef a as bigint, ByVal i as Integer) As bigint
            Dim chiffres(a.bigint_len + i - 1) As Integer
            For k As Integer = 0 To a.bigint_len + i - 1
                If k >= i Then
                    chiffres(k) = a.bigint_chiffres(k - i)
                Else 
                    chiffres(k) = 0
                End If
            Next
            Dim p As bigint = new bigint()
            p.bigint_sign = a.bigint_sign
            p.bigint_len = a.bigint_len + i
            p.bigint_chiffres = chiffres
            Return p
            End Function
            Function mul_bigint(ByRef aa as bigint, ByRef bb as bigint) As bigint
              If aa.bigint_len = 0 Then
                  Return aa
              ElseIf bb.bigint_len = 0 Then
                  Return bb
              ElseIf aa.bigint_len < 3 OrElse bb.bigint_len < 3 Then
                  Return mul_bigint_cp(aa, bb)
              End If
              ' Algorithme de Karatsuba 
              
              Dim split As Integer = Math.Min(aa.bigint_len, bb.bigint_len) \ 2
              Dim a As bigint = bigint_shift(aa, -split)
              Dim b As bigint = bigint_premiers_chiffres(aa, split)
              Dim c As bigint = bigint_shift(bb, -split)
              Dim d As bigint = bigint_premiers_chiffres(bb, split)
              Dim amoinsb As bigint = sub_bigint(a, b)
              Dim cmoinsd As bigint = sub_bigint(c, d)
              Dim ac As bigint = mul_bigint(a, c)
              Dim bd As bigint = mul_bigint(b, d)
              Dim amoinsbcmoinsd As bigint = mul_bigint(amoinsb, cmoinsd)
              Dim acdec As bigint = bigint_shift(ac, 2 * split)
              Return add_bigint(add_bigint(acdec, bd), bigint_shift(sub_bigint(add_bigint(ac, bd), amoinsbcmoinsd), split))
              ' ac × 102k + (ac + bd – (a – b)(c – d)) × 10k + bd 
              
            End Function
            '
            'Division,
            'Modulo
            '
            
            Function log10(ByVal a as Integer) As Integer
              Dim out0 As Integer = 1
              Do While a >= 10
                  a = a \ 10
                  out0 = out0 + 1
              Loop
              Return out0
            End Function
            Function bigint_of_int(ByVal i as Integer) As bigint
              Dim size As Integer = log10(i)
              If i = 0 Then
                  size = 0
              End If
              Dim t(size - 1) As Integer
              For j As Integer = 0 To size - 1
                  t(j) = 0
              Next
              For k As Integer = 0 To size - 1
                  t(k) = i Mod 10
                  i = i \ 10
              Next
              Dim q As bigint = new bigint()
              q.bigint_sign = true
              q.bigint_len = size
              q.bigint_chiffres = t
              Return q
              End Function
              Function fact_bigint(ByRef a as bigint) As bigint
                Dim one As bigint = bigint_of_int(1)
                Dim out0 As bigint = one
                Do While Not bigint_eq(a, one)
                    out0 = mul_bigint(a, out0)
                    a = sub_bigint(a, one)
                Loop
                Return out0
              End Function
              Function sum_chiffres_bigint(ByRef a as bigint) As Integer
                Dim out0 As Integer = 0
                For i As Integer = 0 To a.bigint_len - 1
                    out0 = out0 + a.bigint_chiffres(i)
                Next
                Return out0
              End Function
              ' http://projecteuler.net/problem=20 
              
              Function euler20() As Integer
                Dim a As bigint = bigint_of_int(15)
                ' normalement c'est 100 
                
                a = fact_bigint(a)
                Return sum_chiffres_bigint(a)
              End Function
              Function bigint_exp(ByRef a as bigint, ByVal b as Integer) As bigint
                If b = 1 Then
                    Return a
                ElseIf b Mod 2 = 0 Then
                    Return bigint_exp(mul_bigint(a, a), b \ 2)
                Else 
                    Return mul_bigint(a, bigint_exp(a, b - 1))
                End If
              End Function
              Function bigint_exp_10chiffres(ByRef a as bigint, ByVal b as Integer) As bigint
                a = bigint_premiers_chiffres(a, 10)
                If b = 1 Then
                    Return a
                ElseIf b Mod 2 = 0 Then
                    Return bigint_exp_10chiffres(mul_bigint(a, a), b \ 2)
                Else 
                    Return mul_bigint(a, bigint_exp_10chiffres(a, b - 1))
                End If
              End Function
              Sub euler48()
                Dim sum As bigint = bigint_of_int(0)
                For i As Integer = 1 To 100
                    ' 1000 normalement 
                    
                    Dim ib As bigint = bigint_of_int(i)
                    Dim ibeib As bigint = bigint_exp_10chiffres(ib, i)
                    sum = add_bigint(sum, ibeib)
                    sum = bigint_premiers_chiffres(sum, 10)
                Next
                Console.Write("euler 48 = ")
                print_bigint(sum)
                Console.Write(Chr(10))
              End Sub
              Function euler16() As Integer
                Dim a As bigint = bigint_of_int(2)
                a = bigint_exp(a, 100)
                ' 1000 normalement 
                
                Return sum_chiffres_bigint(a)
              End Function
              Function euler25() As Integer
                Dim i As Integer = 2
                Dim a As bigint = bigint_of_int(1)
                Dim b As bigint = bigint_of_int(1)
                Do While b.bigint_len < 100
                    ' 1000 normalement 
                    
                    Dim c As bigint = add_bigint(a, b)
                    a = b
                    b = c
                    i = i + 1
                Loop
                Return i
              End Function
              Function euler29() As Integer
                Dim maxA As Integer = 5
                Dim maxB As Integer = 5
                Dim a_bigint(maxA) As bigint
                For j As Integer = 0 To maxA
                    a_bigint(j) = bigint_of_int(j * j)
                Next
                Dim a0_bigint(maxA) As bigint
                For j2 As Integer = 0 To maxA
                    a0_bigint(j2) = bigint_of_int(j2)
                Next
                Dim b(maxA) As Integer
                For k As Integer = 0 To maxA
                    b(k) = 2
                Next
                Dim n As Integer = 0
                Dim found As Boolean = true
                Do While found
                    Dim min0 As bigint = a0_bigint(0)
                    found = false
                    For i As Integer = 2 To maxA
                        If b(i) <= maxB Then
                            If found Then
                                If bigint_lt(a_bigint(i), min0) Then
                                    min0 = a_bigint(i)
                                End If
                            Else 
                                min0 = a_bigint(i)
                                found = true
                            End If
                        End If
                    Next
                    If found Then
                        n = n + 1
                        For l As Integer = 2 To maxA
                            If bigint_eq(a_bigint(l), min0) AndAlso b(l) <= maxB Then
                                b(l) = b(l) + 1
                                a_bigint(l) = mul_bigint(a_bigint(l), a0_bigint(l))
                            End If
                        Next
                    End If
                Loop
                Return n
                End Function
                Sub Main()
                  Console.Write(euler29() & Chr(10))
                  Dim sum As bigint = read_bigint(50)
                  For i As Integer = 2 To 100
                      stdin_sep
                      Dim tmp As bigint = read_bigint(50)
                      sum = add_bigint(sum, tmp)
                  Next
                  Console.Write("euler13 = ")
                  print_bigint(sum)
                  Console.Write(Chr(10) & "euler25 = " & euler25() & Chr(10) & "euler16 = " & euler16() & Chr(10))
                  euler48()
                  Console.Write("euler20 = " & euler20() & Chr(10))
                  Dim a As bigint = bigint_of_int(999999)
                  Dim b As bigint = bigint_of_int(9951263)
                  print_bigint(a)
                  Console.Write(">>1=")
                  print_bigint(bigint_shift(a, -1))
                  Console.Write(Chr(10))
                  print_bigint(a)
                  Console.Write("*")
                  print_bigint(b)
                  Console.Write("=")
                  print_bigint(mul_bigint(a, b))
                  Console.Write(Chr(10))
                  print_bigint(a)
                  Console.Write("*")
                  print_bigint(b)
                  Console.Write("=")
                  print_bigint(mul_bigint_cp(a, b))
                  Console.Write(Chr(10))
                  print_bigint(a)
                  Console.Write("+")
                  print_bigint(b)
                  Console.Write("=")
                  print_bigint(add_bigint(a, b))
                  Console.Write(Chr(10))
                  print_bigint(b)
                  Console.Write("-")
                  print_bigint(a)
                  Console.Write("=")
                  print_bigint(sub_bigint(b, a))
                  Console.Write(Chr(10))
                  print_bigint(a)
                  Console.Write("-")
                  print_bigint(b)
                  Console.Write("=")
                  print_bigint(sub_bigint(a, b))
                  Console.Write(Chr(10))
                  print_bigint(a)
                  Console.Write(">")
                  print_bigint(b)
                  Console.Write("=")
                  If bigint_gt(a, b) Then
                      Console.Write("True")
                  Else 
                      Console.Write("False")
                  End If
                  Console.Write(Chr(10))
                End Sub
                
                End Module
                 
Imports System

Module euler12

  Function max2_(ByVal a as Integer, ByVal b as Integer) As Integer
    If a > b Then
      Return a
    Else
      Return b
    End If
  End Function
  
  Function eratostene(ByRef t as Integer(), ByVal max0 as Integer) As Integer
    Dim n As Integer = 0
    For  i As Integer  = 2 to  max0 - 1
      If t(i) = i Then
        Dim j As Integer = i * i
        n = n + 1
        Do While j < max0 AndAlso j > 0
          t(j) = 0
          j = j + i
        Loop
      End If
    Next
    Return n
  End Function
  
  Function fillPrimesFactors(ByRef t as Integer(), ByVal n as Integer, ByRef primes as Integer(), ByVal nprimes as Integer) As Integer
    For  i As Integer  = 0 to  nprimes - 1
      Dim d As Integer = primes(i)
      Do While (n Mod d) = 0
        t(d) = t(d) + 1
        n = n \ d
      Loop
      If n = 1 Then
        Return primes(i)
      End If
    Next
    Return n
  End Function
  
  Function find(ByVal ndiv2 as Integer) As Integer
    Dim maximumprimes As Integer = 110
    Dim era(maximumprimes) As Integer
    For  j As Integer  = 0 to  maximumprimes - 1
      era(j) = j
    Next
    Dim nprimes As Integer = eratostene(era, maximumprimes)
    Dim primes(nprimes) As Integer
    For  o As Integer  = 0 to  nprimes - 1
      primes(o) = 0
    Next
    Dim l As Integer = 0
    For  k As Integer  = 2 to  maximumprimes - 1
      If era(k) = k Then
        primes(l) = k
        l = l + 1
      End If
    Next
    For  n As Integer  = 1 to  10000
      Dim primesFactors(n + 2) As Integer
      For  m As Integer  = 0 to  n + 2 - 1
        primesFactors(m) = 0
      Next
      Dim max0 As Integer = max2_(fillPrimesFactors(primesFactors, n, primes, nprimes), fillPrimesFactors(primesFactors, n + 1, primes, nprimes))
      primesFactors(2) = primesFactors(2) - 1
      Dim ndivs As Integer = 1
      For  i As Integer  = 0 to  max0
        If primesFactors(i) <> 0 Then
          ndivs = ndivs * (1 + primesFactors(i))
        End If
      Next
      If ndivs > ndiv2 Then
        Return (n * (n + 1)) \ 2
      End If
      ' print "n=" print n print "\t" print (n * (n + 1) / 2 ) print " " print ndivs print "\n" 
      
      Next
      Return 0
    End Function
    
    
    Sub Main()
      Console.Write("" & find(500) & "" & Chr(10) & "")
    End Sub
    
    End Module
     
Imports System

Module euler21

  Function eratostene(ByRef t as Integer(), ByVal max0 as Integer) As Integer
    Dim n As Integer = 0
    For i As Integer = 2 To max0 - 1
        If t(i) = i Then
            n = n + 1
            Dim j As Integer = i * i
            Do While j < max0 AndAlso j > 0
                t(j) = 0
                j = j + i
            Loop
        End If
    Next
    Return n
  End Function
  Function fillPrimesFactors(ByRef t as Integer(), ByVal n as Integer, ByRef primes as Integer(), ByVal nprimes as Integer) As Integer
    For i As Integer = 0 To nprimes - 1
        Dim d As Integer = primes(i)
        Do While n Mod d = 0
            t(d) = t(d) + 1
            n = n \ d
        Loop
        If n = 1 Then
            Return primes(i)
        End If
    Next
    Return n
  End Function
  Function sumdivaux2(ByRef t as Integer(), ByVal n as Integer, ByVal i as Integer) As Integer
    Do While i < n AndAlso t(i) = 0
        i = i + 1
    Loop
    Return i
  End Function
  Function sumdivaux(ByRef t as Integer(), ByVal n as Integer, ByVal i as Integer) As Integer
    If i > n Then
        Return 1
    ElseIf t(i) = 0 Then
        Return sumdivaux(t, n, sumdivaux2(t, n, i + 1))
    Else 
        Dim o As Integer = sumdivaux(t, n, sumdivaux2(t, n, i + 1))
        Dim out0 As Integer = 0
        Dim p As Integer = i
        For j As Integer = 1 To t(i)
            out0 = out0 + p
            p = p * i
        Next
        Return (out0 + 1) * o
    End If
  End Function
  Function sumdiv(ByVal nprimes as Integer, ByRef primes as Integer(), ByVal n as Integer) As Integer
    Dim t(n) As Integer
    For i As Integer = 0 To n
        t(i) = 0
    Next
    Dim max0 As Integer = fillPrimesFactors(t, n, primes, nprimes)
    Return sumdivaux(t, max0, 0)
    End Function
    Sub Main()
      Dim maximumprimes As Integer = 1001
      Dim era(maximumprimes - 1) As Integer
      For j As Integer = 0 To maximumprimes - 1
          era(j) = j
      Next
      Dim nprimes As Integer = eratostene(era, maximumprimes)
      Dim primes(nprimes - 1) As Integer
      For o As Integer = 0 To nprimes - 1
          primes(o) = 0
      Next
      Dim l As Integer = 0
      For k As Integer = 2 To maximumprimes - 1
          If era(k) = k Then
              primes(l) = k
              l = l + 1
          End If
      Next
      Console.Write(l & " == " & nprimes & Chr(10))
      Dim sum As Integer = 0
      For n As Integer = 2 To 1000
          Dim other As Integer = sumdiv(nprimes, primes, n) - n
          If other > n Then
              Dim othersum As Integer = sumdiv(nprimes, primes, other) - other
              If othersum = n Then
                  Console.Write(other & " & " & n & Chr(10))
                  sum = sum + other + n
              End If
          End If
      Next
      Console.Write(Chr(10) & sum & Chr(10))
      End Sub
      
      End Module
      
      
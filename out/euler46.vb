Imports System

Module euler46

  Function eratostene(ByRef t as Integer(), ByVal max0 as Integer) As Integer
    Dim n As Integer = 0
    For i As Integer = 2 To max0 - 1
        If t(i) = i Then
            n = n + 1
            If max0 \ i > i Then
                Dim j As Integer = i * i
                Do While j < max0 AndAlso j > 0
                    t(j) = 0
                    j = j + i
                Loop
            End If
        End If
    Next
    Return n
  End Function
  Sub Main()
    Dim maximumprimes As Integer = 6000
    Dim era(maximumprimes - 1) As Integer
    For j_ As Integer = 0 To maximumprimes - 1
        era(j_) = j_
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
    Dim canbe(maximumprimes - 1) As Boolean
    For i_ As Integer = 0 To maximumprimes - 1
        canbe(i_) = false
    Next
    For i As Integer = 0 To nprimes - 1
        For j As Integer = 0 To maximumprimes - 1
            Dim n As Integer = primes(i) + 2 * j * j
            If n < maximumprimes Then
                canbe(n) = true
            End If
        Next
    Next
    For m As Integer = 1 To maximumprimes
        Dim m2 As Integer = m * 2 + 1
        If m2 < maximumprimes AndAlso Not canbe(m2) Then
            Console.Write(m2 & Chr(10))
        End If
    Next
    End Sub
    
    End Module
     
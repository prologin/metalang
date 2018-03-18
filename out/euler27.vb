Imports System

Module euler27

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
  Function isPrime(ByVal n as Integer, ByRef primes as Integer(), ByVal len as Integer) As Boolean
    Dim i As Integer = 0
    If n < 0 Then
        n = -n
    End If
    Do While primes(i) * primes(i) < n
        If n Mod primes(i) = 0 Then
            Return false
        End If
        i = i + 1
    Loop
    Return true
  End Function
  Function test(ByVal a as Integer, ByVal b as Integer, ByRef primes as Integer(), ByVal len as Integer) As Integer
    For n As Integer = 0 To 200
        Dim j As Integer = n * n + a * n + b
        If Not isPrime(j, primes, len) Then
            Return n
        End If
    Next
    Return 200
  End Function
  Sub Main()
    Dim maximumprimes As Integer = 1000
    Dim era(maximumprimes - 1) As Integer
    For j As Integer = 0 To maximumprimes - 1
        era(j) = j
    Next
    Dim result As Integer = 0
    Dim max0 As Integer = 0
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
    Dim ma As Integer = 0
    Dim mb As Integer = 0
    For b As Integer = 3 To 999
        If era(b) = b Then
            For a As Integer = -999 To 999
                Dim n1 As Integer = test(a, b, primes, nprimes)
                Dim n2 As Integer = test(a, -b, primes, nprimes)
                If n1 > max0 Then
                    max0 = n1
                    result = a * b
                    ma = a
                    mb = b
                End If
                If n2 > max0 Then
                    max0 = n2
                    result = -a * b
                    ma = a
                    mb = -b
                End If
            Next
        End If
    Next
    Console.Write(ma & " " & mb & Chr(10) & max0 & Chr(10) & result & Chr(10))
    End Sub
    
    End Module
    
    
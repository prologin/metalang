Imports System

Module euler50

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
    Dim maximumprimes As Integer = 1000001
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
    Dim sum(nprimes - 1) As Integer
    For i_ As Integer = 0 To nprimes - 1
        sum(i_) = primes(i_)
    Next
    Dim maxl As Integer = 0
    Dim process As Boolean = true
    Dim stop0 As Integer = maximumprimes - 1
    Dim len As Integer = 1
    Dim resp As Integer = 1
    Do While process
        process = false
        For i As Integer = 0 To stop0
            If i + len < nprimes Then
                sum(i) = sum(i) + primes(i + len)
                If maximumprimes > sum(i) Then
                    process = true
                    If era(sum(i)) = sum(i) Then
                        maxl = len
                        resp = sum(i)
                    End If
                Else 
                    stop0 = Math.Min(stop0, i)
                End If
            End If
        Next
        len = len + 1
    Loop
    Console.Write(resp & Chr(10) & maxl & Chr(10))
    End Sub
    
    End Module
     
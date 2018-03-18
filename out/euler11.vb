Imports System
Imports System.Collections.Generic

Module euler11

  Function find(ByVal n as Integer, ByRef m as Integer()(), ByVal x as Integer, ByVal y as Integer, ByVal dx as Integer, ByVal dy as Integer) As Integer
    If x < 0 OrElse x = 20 OrElse y < 0 OrElse y = 20 Then
        Return -1
    ElseIf n = 0 Then
        Return 1
    Else 
        Return m(y)(x) * find(n - 1, m, x + dx, y + dy, dx, dy)
    End If
  End Function
  Public Class tuple_int_int
    Public tuple_int_int_field_0 As Integer
    Public tuple_int_int_field_1 As Integer
  End Class
  Sub Main()
    Dim directions(7) As tuple_int_int
    For i As Integer = 0 To 7
        If i = 0 Then
            Dim c As tuple_int_int = new tuple_int_int()
            c.tuple_int_int_field_0 = 0
            c.tuple_int_int_field_1 = 1
            directions(i) = c
        ElseIf i = 1 Then
            Dim d As tuple_int_int = new tuple_int_int()
            d.tuple_int_int_field_0 = 1
            d.tuple_int_int_field_1 = 0
            directions(i) = d
        ElseIf i = 2 Then
            Dim e As tuple_int_int = new tuple_int_int()
            e.tuple_int_int_field_0 = 0
            e.tuple_int_int_field_1 = -1
            directions(i) = e
        ElseIf i = 3 Then
            Dim f As tuple_int_int = new tuple_int_int()
            f.tuple_int_int_field_0 = -1
            f.tuple_int_int_field_1 = 0
            directions(i) = f
        ElseIf i = 4 Then
            Dim g As tuple_int_int = new tuple_int_int()
            g.tuple_int_int_field_0 = 1
            g.tuple_int_int_field_1 = 1
            directions(i) = g
        ElseIf i = 5 Then
            Dim h As tuple_int_int = new tuple_int_int()
            h.tuple_int_int_field_0 = 1
            h.tuple_int_int_field_1 = -1
            directions(i) = h
        ElseIf i = 6 Then
            Dim k As tuple_int_int = new tuple_int_int()
            k.tuple_int_int_field_0 = -1
            k.tuple_int_int_field_1 = 1
            directions(i) = k
        Else 
            Dim l As tuple_int_int = new tuple_int_int()
            l.tuple_int_int_field_0 = -1
            l.tuple_int_int_field_1 = -1
            directions(i) = l
        End If
    Next
    Dim max0 As Integer = 0
    Dim m(19)() As Integer
    For o As Integer = 0 To 19
        m(o) = Array(Of String).ConvertAll(Of String, Integer)(Console.ReadLine().Split(" ".ToCharArray()), New Converter(Of String, Integer)(AddressOf Integer.Parse))
    Next
    For j As Integer = 0 To 7
        Dim p As tuple_int_int = directions(j)
        Dim dx As Integer = p.tuple_int_int_field_0
        Dim dy As Integer = p.tuple_int_int_field_1
        For x As Integer = 0 To 19
            For y As Integer = 0 To 19
                max0 = Math.Max(max0, find(4, m, x, y, dx, dy))
            Next
        Next
    Next
    Console.Write(max0 & Chr(10))
    End Sub
    
    End Module
    
    
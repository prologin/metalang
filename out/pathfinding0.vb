Imports System
Imports System.Collections.Generic

Module pathfinding0

  Function pathfind_aux(ByRef cache as Integer()(), ByRef tab as Char()(), ByVal x as Integer, ByVal y as Integer, ByVal posX as Integer, ByVal posY as Integer) As Integer
    If posX = x - 1 AndAlso posY = y - 1 Then
        Return 0
    ElseIf posX < 0 OrElse posY < 0 OrElse posX >= x OrElse posY >= y Then
        Return x * y * 10
    ElseIf tab(posY)(posX) = Chr(35) Then
        Return x * y * 10
    ElseIf cache(posY)(posX) <> -1 Then
        Return cache(posY)(posX)
    Else 
        cache(posY)(posX) = x * y * 10
        Dim val1 As Integer = pathfind_aux(cache, tab, x, y, posX + 1, posY)
        Dim val2 As Integer = pathfind_aux(cache, tab, x, y, posX - 1, posY)
        Dim val3 As Integer = pathfind_aux(cache, tab, x, y, posX, posY - 1)
        Dim val4 As Integer = pathfind_aux(cache, tab, x, y, posX, posY + 1)
        Dim out0 As Integer = 1 + Math.Min(Math.Min(Math.Min(val1, val2), val3), val4)
        cache(posY)(posX) = out0
        Return out0
    End If
  End Function
  Function pathfind(ByRef tab as Char()(), ByVal x as Integer, ByVal y as Integer) As Integer
    Dim cache(y - 1)() As Integer
    For i As Integer = 0 To y - 1
        Dim tmp(x - 1) As Integer
        For j As Integer = 0 To x - 1
            Console.Write(tab(i)(j))
            tmp(j) = -1
        Next
        Console.Write(Chr(10))
        cache(i) = tmp
        Next
        Return pathfind_aux(cache, tab, x, y, 0, 0)
    End Function
    Sub Main()
      Dim x As Integer = Integer.Parse(Console.ReadLine())
      Dim y As Integer = Integer.Parse(Console.ReadLine())
      Console.Write(x & " " & y & Chr(10))
      Dim e(y - 1)() As Char
      For f As Integer = 0 To y - 1
          e(f) = Console.ReadLine().ToCharArray()
      Next
      Dim tab As Char()() = e
      Dim result As Integer = pathfind(tab, x, y)
      Console.Write(result)
      End Sub
      
    End Module
     
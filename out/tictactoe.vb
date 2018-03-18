Imports System

Module tictactoe

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

Function readInt() As Integer
  Dim i As Integer = 0
  Dim s as Char = readChar_()
  Dim sign As Integer = 1
  If s = "-"C Then
    sign = -1
    consommeChar()
  End If
  Do
    Dim c as Char = readChar_()
    If c <= "9"C And c >= "0"C Then
      i = i * 10 + Asc(c) - Asc("0"C)
      consommeChar()
    Else
      return i * sign
    End If
  Loop
End Function
  '
  'Tictactoe : un tictactoe avec une IA
  '
  
  ' La structure de donnée 
  
  Public Class gamestate
    Public cases As Integer()()
    Public firstToPlay As Boolean
    Public note As Integer
    Public ended As Boolean
  End Class
  ' Un Mouvement 
  
  Public Class move
    Public x As Integer
    Public y As Integer
  End Class
  ' On affiche l'état 
  
  Sub print_state(ByRef g as gamestate)
    Console.Write(Chr(10) & "|")
    For y As Integer = 0 To 2
        For x As Integer = 0 To 2
            If g.cases(x)(y) = 0 Then
                Console.Write(" ")
            ElseIf g.cases(x)(y) = 1 Then
                Console.Write("O")
            Else 
                Console.Write("X")
            End If
            Console.Write("|")
        Next
        If y <> 2 Then
            Console.Write(Chr(10) & "|-|-|-|" & Chr(10) & "|")
        End If
    Next
    Console.Write(Chr(10))
  End Sub
  ' On dit qui gagne (info stoquées dans g.ended et g.note ) 
  
  Sub eval0(ByRef g as gamestate)
    Dim win As Integer = 0
    Dim freecase As Integer = 0
    For y As Integer = 0 To 2
        Dim col As Integer = -1
        Dim lin As Integer = -1
        For x As Integer = 0 To 2
            If g.cases(x)(y) = 0 Then
                freecase = freecase + 1
            End If
            Dim colv As Integer = g.cases(x)(y)
            Dim linv As Integer = g.cases(y)(x)
            If col = -1 AndAlso colv <> 0 Then
                col = colv
            ElseIf colv <> col Then
                col = -2
            End If
            If lin = -1 AndAlso linv <> 0 Then
                lin = linv
            ElseIf linv <> lin Then
                lin = -2
            End If
        Next
        If col >= 0 Then
            win = col
        ElseIf lin >= 0 Then
            win = lin
        End If
    Next
    For x As Integer = 1 To 2
        If g.cases(0)(0) = x AndAlso g.cases(1)(1) = x AndAlso g.cases(2)(2) = x Then
            win = x
        End If
        If g.cases(0)(2) = x AndAlso g.cases(1)(1) = x AndAlso g.cases(2)(0) = x Then
            win = x
        End If
    Next
    g.ended = win <> 0 OrElse freecase = 0
    If win = 1 Then
        g.note = 1000
    ElseIf win = 2 Then
        g.note = -1000
    Else 
        g.note = 0
    End If
  End Sub
  ' On applique un mouvement 
  
  Sub apply_move_xy(ByVal x as Integer, ByVal y as Integer, ByRef g as gamestate)
    Dim player As Integer = 2
    If g.firstToPlay Then
        player = 1
    End If
    g.cases(x)(y) = player
    g.firstToPlay = Not g.firstToPlay
  End Sub
  Sub apply_move(ByRef m as move, ByRef g as gamestate)
    apply_move_xy(m.x, m.y, g)
  End Sub
  Sub cancel_move_xy(ByVal x as Integer, ByVal y as Integer, ByRef g as gamestate)
    g.cases(x)(y) = 0
    g.firstToPlay = Not g.firstToPlay
    g.ended = false
  End Sub
  Sub cancel_move(ByRef m as move, ByRef g as gamestate)
    cancel_move_xy(m.x, m.y, g)
  End Sub
  Function can_move_xy(ByVal x as Integer, ByVal y as Integer, ByRef g as gamestate) As Boolean
    Return g.cases(x)(y) = 0
  End Function
  Function can_move(ByRef m as move, ByRef g as gamestate) As Boolean
    Return can_move_xy(m.x, m.y, g)
  End Function
  '
  'Un minimax classique, renvoie la note du plateau
  '
  
  Function minmax(ByRef g as gamestate) As Integer
    eval0(g)
    If g.ended Then
        Return g.note
    End If
    Dim maxNote As Integer = -10000
    If Not g.firstToPlay Then
        maxNote = 10000
    End If
    For x As Integer = 0 To 2
        For y As Integer = 0 To 2
            If can_move_xy(x, y, g) Then
                apply_move_xy(x, y, g)
                Dim currentNote As Integer = minmax(g)
                cancel_move_xy(x, y, g)
                ' Minimum ou Maximum selon le coté ou l'on joue
                
                If currentNote > maxNote = g.firstToPlay Then
                    maxNote = currentNote
                End If
            End If
        Next
    Next
    Return maxNote
  End Function
  '
  'Renvoie le coup de l'IA
  '
  
  Function play(ByRef g as gamestate) As move
    Dim minMove As move = new move()
    minMove.x = 0
    minMove.y = 0
    Dim minNote As Integer = 10000
    For x As Integer = 0 To 2
        For y As Integer = 0 To 2
            If can_move_xy(x, y, g) Then
                apply_move_xy(x, y, g)
                Dim currentNote As Integer = minmax(g)
                Console.Write(x & ", " & y & ", " & currentNote & Chr(10))
                cancel_move_xy(x, y, g)
                If currentNote < minNote Then
                    minNote = currentNote
                    minMove.x = x
                    minMove.y = y
                End If
            End If
        Next
    Next
    Console.Write(minMove.x & minMove.y & Chr(10))
    Return minMove
  End Function
  Function init0() As gamestate
    Dim cases(2)() As Integer
    For i As Integer = 0 To 2
        Dim tab(2) As Integer
        For j As Integer = 0 To 2
            tab(j) = 0
        Next
        cases(i) = tab
        Next
        Dim a As gamestate = new gamestate()
        a.cases = cases
        a.firstToPlay = true
        a.note = 0
        a.ended = false
        Return a
    End Function
    Function read_move() As move
      Dim x As Integer = readInt
      stdin_sep
      Dim y As Integer = readInt
      stdin_sep
      Dim b As move = new move()
      b.x = x
      b.y = y
      Return b
    End Function
    Sub Main()
      For i As Integer = 0 To 1
          Dim state As gamestate = init0()
          Dim c As move = new move()
          c.x = 1
          c.y = 1
          apply_move(c, state)
          Dim d As move = new move()
          d.x = 0
          d.y = 0
          apply_move(d, state)
          Do While Not state.ended
              print_state(state)
              apply_move(play(state), state)
              eval0(state)
              print_state(state)
              If Not state.ended Then
                  apply_move(play(state), state)
                  eval0(state)
              End If
          Loop
          print_state(state)
          Console.Write(state.note & Chr(10))
      Next
    End Sub
    
    End Module
    
    
Imports System

Module brainfuck_compiler

  '
  'Ce test permet de tester les macros
  'C'est un compilateur brainfuck qui lit sur l'entrée standard pendant la compilation
  'et qui produit les macros metalang correspondante
  '
  
  Sub Main()
    Dim input As Char = Chr(32)
    Dim current_pos As Integer = 500
    Dim mem(999) As Integer
    For i As Integer = 0 To 999
        mem(i) = 0
    Next
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    current_pos = current_pos + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    mem(current_pos) = mem(current_pos) + 1
    Do While mem(current_pos) <> 0
        mem(current_pos) = mem(current_pos) - 1
        current_pos = current_pos - 1
        mem(current_pos) = mem(current_pos) + 1
        Console.Write(Chr(mem(current_pos)))
        current_pos = current_pos + 1
    Loop
    End Sub
    
  End Module
  
  
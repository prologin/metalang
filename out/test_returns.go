package main
func is_pair(i int) bool{
  j := 1
  _ = j
  if i < 10 {
      j = 2
      if i == 0 {
          j = 4
          return true
      }
      j = 3
      if i == 2 {
          j = 4
          return true
      }
      j = 5
  }
  j = 6
  if i < 20 {
      if i == 22 {
          j = 0
      }
      j = 8
  }
  return i % 2 == 0
}

func main() {
  
}


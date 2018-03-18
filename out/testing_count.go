package main
import "fmt"

func main() {
  var tab []int = make([]int, 40)
  for i := 0; i < 40; i++ {
      tab[i] = i * i
  }
  fmt.Printf("%d\n", len(tab))
}


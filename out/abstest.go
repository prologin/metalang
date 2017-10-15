package main
import "fmt"
func abs_(n int) int{
  if n > 0 {
      return n
  } else {
      return -n
  }
}
func main() {
  fmt.Printf("%d%d", abs_(5 + 2) * 3, 3 * abs_(5 + 2))
}


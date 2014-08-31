package main
import "fmt"
import "os"
import "bufio"
var reader *bufio.Reader

func skip() {
  var c byte
  fmt.Fscanf(reader, "%c", &c)
  if c == '\n' || c == ' ' {
    skip()
  } else {
    reader.UnreadByte()
  }
}

func max2_(a int, b int) int{
  if a > b {
    return a
  } else {
    return b
  }
}

func read_int_matrix(x int, y int) [][]int{
  var tab [][]int = make([][]int, y)
  for z := 0 ; z <= y - 1; z++ {
    var d []int = make([]int, x)
      for e := 0 ; e <= x - 1; e++ {
        var f int
        fmt.Fscanf(reader, "%d", &f)
          skip()
          d[e] = f;
      }
      tab[z] = d;
  }
  return tab
}

func find(n int, m [][]int, x int, y int, dx int, dy int) int{
  if x < 0 || x == 20 || y < 0 || y == 20 {
    return -1
  } else if n == 0 {
    return 1
  } else {
    return m[y][x] * find(n - 1, m, x + dx, y + dy, dx, dy)
  } 
}


type tuple_int_int struct {
  tuple_int_int_field_0 int;
  tuple_int_int_field_1 int;
}

func main() {
  reader = bufio.NewReader(os.Stdin)
  var directions []* tuple_int_int = make([]* tuple_int_int, 8)
  for i := 0 ; i <= 8 - 1; i++ {
    if i == 0 {
        var v * tuple_int_int = new (tuple_int_int)
          (*v).tuple_int_int_field_0=0
          (*v).tuple_int_int_field_1=1
          directions[i] = v;
      } else if i == 1 {
        var u * tuple_int_int = new (tuple_int_int)
          (*u).tuple_int_int_field_0=1
          (*u).tuple_int_int_field_1=0
          directions[i] = u;
      } else if i == 2 {
        var s * tuple_int_int = new (tuple_int_int)
          (*s).tuple_int_int_field_0=0
          (*s).tuple_int_int_field_1=-1
          directions[i] = s;
      } else if i == 3 {
        var r * tuple_int_int = new (tuple_int_int)
          (*r).tuple_int_int_field_0=-1
          (*r).tuple_int_int_field_1=0
          directions[i] = r;
      } else if i == 4 {
        var q * tuple_int_int = new (tuple_int_int)
          (*q).tuple_int_int_field_0=1
          (*q).tuple_int_int_field_1=1
          directions[i] = q;
      } else if i == 5 {
        var p * tuple_int_int = new (tuple_int_int)
          (*p).tuple_int_int_field_0=1
          (*p).tuple_int_int_field_1=-1
          directions[i] = p;
      } else if i == 6 {
        var o * tuple_int_int = new (tuple_int_int)
          (*o).tuple_int_int_field_0=-1
          (*o).tuple_int_int_field_1=1
          directions[i] = o;
      } else {
        var l * tuple_int_int = new (tuple_int_int)
        (*l).tuple_int_int_field_0=-1
        (*l).tuple_int_int_field_1=-1
        directions[i] = l;
      }      
  }
  var max_ int = 0
  var m [][]int = read_int_matrix(20, 20)
  for j := 0 ; j <= 7; j++ {
    var k * tuple_int_int = directions[j]
      var dx int = (*k).tuple_int_int_field_0
      var dy int = (*k).tuple_int_int_field_1
      for x := 0 ; x <= 19; x++ {
        for y := 0 ; y <= 19; y++ {
            var h int = find(4, m, x, y, dx, dy)
              var g int = max2_(max_, h)
              max_ = g;
          }
      }
  }
  fmt.Printf("%d\n", max_);
}


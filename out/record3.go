package main
import "fmt"
import "os"
import "bufio"
var reader *bufio.Reader

func skip() {
  var c byte
  fmt.Fscanf(reader, "%c", &c);
  if c == '\n' || c == ' ' {
    skip()
  } else {
    reader.UnreadByte()
  }
}



type toto struct {
  foo int;
  bar int;
  blah int;
}

func mktoto(v1 int) * toto{
  var t * toto = new (toto)
  (*t).foo=v1;
  (*t).bar=0;
  (*t).blah=0;
  return t
}

func result(t []* toto, len int) int{
  var out_ int = 0
  for j := 0 ; j <= len - 1; j++ {
    (*t[j]).blah = (*t[j]).blah + 1;
      out_ = out_ + (*t[j]).foo + (*t[j]).blah * (*t[j]).bar + (*t[j]).bar * (*t[j]).foo;
  }
  return out_
}

func main() {
  reader = bufio.NewReader(os.Stdin)
  var a int = 4
  var t []* toto = make([]* toto, a)
  for i := 0 ; i <= a - 1; i++ {
    t[i] = mktoto(i);
  }
  fmt.Fscanf(reader, "%d", &(*t[0]).bar);
  skip()
  fmt.Fscanf(reader, "%d", &(*t[1]).blah);
  var b int = result(t, 4)
  fmt.Printf("%d", b);
  var c int = (*t[2]).blah
  fmt.Printf("%d", c);
}

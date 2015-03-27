import groovy.transform.Field
import java.util.*

class Intlist {
  int head
  Intlist tail
}
Intlist cons(Intlist list, int i)
{
  Intlist out0 = new Intlist()
  out0.head = i
  out0.tail = list
  return out0
}

Intlist rev2(Intlist empty, Intlist acc, Intlist torev)
{
  if (torev == empty)
    return acc
  else
  {
    Intlist acc2 = new Intlist()
    acc2.head = torev.head
    acc2.tail = acc
    return rev2(empty, acc, torev.tail)
  }
}

Intlist rev(Intlist empty, Intlist torev)
{
  return rev2(empty, empty, torev)
}

void test(Intlist empty)
{
  Intlist list = empty
  int i = -1
  while (i != 0)
  {
    if (scanner.hasNext("^-")){
      scanner.next("^-");
      i = -scanner.nextInt();
    }else{
      i = scanner.nextInt();
    }
    if (i != 0)
      list = cons(list, i)
  }
}


@Field Scanner scanner = new Scanner(System.in)


import java.util.*;

public class fibo
{
  static Scanner scanner = new Scanner(System.in);
  /*
La suite de fibonaci
*/
  static int fibo0(int a, int b, int i)
  {
    int out0 = 0;
    int a2 = a;
    int b2 = b;
    for (int j = 0; j <= i + 1; j++)
    {
        out0 += a2;
        int tmp = b2;
        b2 += a2;
        a2 = tmp;
    }
    return out0;
  }
  public static void main(String args[])
  {
    int a;
    if (scanner.hasNext("^-")) {
      scanner.next("^-");
      a = scanner.nextInt();
    } else {
      a = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int b;
    if (scanner.hasNext("^-")) {
      scanner.next("^-");
      b = scanner.nextInt();
    } else {
      b = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int i;
    if (scanner.hasNext("^-")) {
      scanner.next("^-");
      i = scanner.nextInt();
    } else {
      i = scanner.nextInt();
    }
    System.out.print(fibo0(a, b, i));
  }
  
}


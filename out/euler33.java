import java.util.*;

public class euler33
{
  static Scanner scanner = new Scanner(System.in);
  public static int max2(int a, int b)
  {
    return Math.max(a, b);
  }
  
  public static int min2(int a, int b)
  {
    return Math.min(a, b);
  }
  
  public static int pgcd(int a, int b)
  {
    int c = min2(a, b);
    int d = max2(a, b);
    int reste = d % c;
    if (reste == 0)
      return c;
    else
      return pgcd(c, reste);
  }
  
  
  public static void main(String args[])
  {
    int top = 1;
    int bottom = 1;
    for (int i = 1 ; i <= 9; i ++)
      for (int j = 1 ; j <= 9; j ++)
        for (int k = 1 ; k <= 9; k ++)
          if (i != j && j != k)
    {
      int a = i * 10 + j;
      int b = j * 10 + k;
      if (a * k == i * b)
      {
        System.out.printf("%d/%d\n", a, b);
        top *= a;
        bottom *= b;
      }
    }
    System.out.printf("%d/%d\n", top, bottom);
    int p = pgcd(top, bottom);
    System.out.printf("pgcd=%d\n", p);
    int e = bottom / p;
    System.out.printf("%d\n", e);
  }
  
}


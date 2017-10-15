using System;

public class abstest
{
  static int abs_(int n)
  {
    if (n > 0)
        return n;
    else
        return -n;
  }
  
  public static void Main(String[] args)
  {
    Console.Write("" + (abs_(5 + 2) * 3) + (3 * abs_(5 + 2)));
  }
  
}


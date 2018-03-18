using System;

public class testing_count
{
  
  public static void Main(String[] args)
  {
    int[] tab = new int[40];
    for (int i = 0; i < 40; i++)
        tab[i] = i * i;
    Console.Write((tab).Length + "\n");
  }
  
}


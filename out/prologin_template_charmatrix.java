import java.util.*;

public class prologin_template_charmatrix
{
  static Scanner scanner = new Scanner(System.in);
  public static int programme_candidat(char[][] tableau, int taille_x, int taille_y)
  {
    int out0 = 0;
    for (int i = 0 ; i < taille_y; i++)
    {
      for (int j = 0 ; j < taille_x; j++)
      {
        out0 += tableau[i][j] * (i + j * 2);
        System.out.printf("%c", tableau[i][j]);
      }
      System.out.print("--\n");
    }
    return out0;
  }
  
  
  public static void main(String args[])
  {
    int c;
    if (scanner.hasNext("^-")){
      scanner.next("^-");
      c = scanner.nextInt();
    } else {
      c = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int taille_x = c;
    int e;
    if (scanner.hasNext("^-")){
      scanner.next("^-");
      e = scanner.nextInt();
    } else {
      e = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int taille_y = e;
    char[][] g = new char[taille_y][];
    for (int h = 0 ; h < taille_y; h++)
      g[h] = scanner.nextLine().toCharArray();
    char[][] tableau = g;
    System.out.printf("%d\n", programme_candidat(tableau, taille_x, taille_y));
  }
  
}


import java.util.*;

public class prologin_template_2charline
{
  static Scanner scanner = new Scanner(System.in);
  public static int programme_candidat(char[] tableau1, int taille1, char[] tableau2, int taille2)
  {
    int out0 = 0;
    for (int i = 0 ; i < taille1; i++)
    {
      out0 += tableau1[i] * i;
      System.out.printf("%c", tableau1[i]);
    }
    System.out.print("--\n");
    for (int j = 0 ; j < taille2; j++)
    {
      out0 += tableau2[j] * j * 100;
      System.out.printf("%c", tableau2[j]);
    }
    System.out.print("--\n");
    return out0;
  }
  
  
  public static void main(String args[])
  {
    int b;
    if (scanner.hasNext("^-")){
      scanner.next("^-");
      b = scanner.nextInt();
    } else {
      b = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int taille1 = b;
    char[] tableau1 = scanner.nextLine().toCharArray();
    int e;
    if (scanner.hasNext("^-")){
      scanner.next("^-");
      e = scanner.nextInt();
    } else {
      e = scanner.nextInt();
    }
    scanner.findWithinHorizon("[\n\r ]*", 1);
    int taille2 = e;
    char[] tableau2 = scanner.nextLine().toCharArray();
    System.out.printf("%d\n", programme_candidat(tableau1, taille1, tableau2, taille2));
  }
  
}


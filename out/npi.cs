using System;

public class npi
{


static bool eof;
static String buffer;
public static char readChar_(){
  if (buffer == null){
    buffer = Console.ReadLine();
  }
  if (buffer.Length == 0){
    String tmp = Console.ReadLine();
    eof = tmp == null;
    buffer = "\n"+tmp;
  }
  char c = buffer[0];
  return c;
}
public static void consommeChar(){
       readChar_();
  buffer = buffer.Substring(1);
}
public static char readChar(){
  char out_ = readChar_();
  consommeChar();
  return out_;
}

public static void stdin_sep(){
  do{
    if (eof) return;
    char c = readChar_();
    if (c == ' ' || c == '\n' || c == '\t' || c == '\r'){
      consommeChar();
    }else{
      return;
    }
  } while(true);
}

public static int readInt(){
  int i = 0;
  char s = readChar_();
  int sign = 1;
  if (s == '-'){
    sign = -1;
    consommeChar();
  }
  do{
    char c = readChar_();
    if (c <= '9' && c >= '0'){
      i = i * 10 + c - '0';
      consommeChar();
    }else{
      return i * sign;
    }
  } while(true);
}



  
  public static bool is_number(char c)
  {
    return (c <= '9') && (c >= '0');
  }
  
  /*
Notation polonaise inversée
*/
  public static int npi_(char[] str, int len)
  {
    int[] stack = new int[len];
    for (int i = 0 ; i <= len - 1; i ++)
    {
      stack[i] = 0;
    }
    int ptrStack = 0;
    int ptrStr = 0;
    while (ptrStr < len)
    {
      if (str[ptrStr] == (char)32)
      {
        ptrStr = ptrStr + 1;
      }
      else if (is_number(str[ptrStr]))
      {
        int num = 0;
        while (str[ptrStr] != (char)32)
        {
          num = ((num * 10) + str[ptrStr]) - '0';
          ptrStr = ptrStr + 1;
        }
        stack[ptrStack] = num;
        ptrStack = ptrStack + 1;
      }
      else if (str[ptrStr] == (char)43)
      {
        stack[ptrStack - 2] = stack[ptrStack - 2] + stack[ptrStack - 1];
        ptrStack = ptrStack - 1;
        ptrStr = ptrStr + 1;
      }
    }
    return stack[0];
  }
  
  
  public static void Main(String[] args)
  {
    int len = 0;
    len = readInt();
    stdin_sep();
    char[] tab = new char[len];
    for (int i = 0 ; i <= len - 1; i ++)
    {
      char tmp = (char)0;
      tmp = readChar();
      tab[i] = tmp;
    }
    int result = npi_(tab, len);
    Console.Write(result);
  }
  
}

using System;

public class calc
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



  public static int fibo(int a, int b, int i)
  {
    int out_ = 0;
    int a2 = a;
    int b2 = b;
    for (int j = 0 ; j <= i + 1; j ++)
    {
      Console.Write(j);
      out_ = out_ + a2;
      int tmp = b2;
      b2 = b2 + a2;
      a2 = tmp;
    }
    return out_;
  }
  
  
  public static void Main(String[] args)
  {
    int f = fibo(1, 2, 4);
    Console.Write(f);
  }
  
}

object abstest
{
  
  def abs_0(n : Int): Int = {
    if (n > 0)
        return n;
    else
        return -n;
  }
  
  def main(args : Array[String])
  {
    printf("%d%d", abs_0(5 + 2) * 3, 3 * abs_0(5 + 2));
  }
  
}


object testing_count
{
  
  
  def main(args : Array[String])
  {
    var tab :Array[Int] = new Array[Int](40);
    for (i <- 0 to 39)
        tab(i) = i * i;
    printf("%d\n", (tab).length);
  }
  
}


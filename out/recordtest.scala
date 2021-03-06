object recordtest
{
  
var buffer = "";
def read_int() : Int = {
  if (buffer != null && buffer == "") buffer = readLine();
  var sign = 1;
  if (buffer != null && buffer.charAt(0) == '-'){
    sign = -1;
    buffer = buffer.substring(1);
  }
  var c = 0;
  while (buffer != null && buffer != "" && buffer.charAt(0).isDigit){
    c = c * 10 + buffer.charAt(0).asDigit;
    buffer = buffer.substring(1);
  }
  return c * sign;
}
def skip() {
  if (buffer != null && buffer == "") buffer = readLine();
  while (buffer != null && buffer != "" && (buffer.charAt(0) == ' ' || buffer.charAt(0) == '\t' || buffer.charAt(0) == '\n' || buffer.charAt(0) == '\r'))
    buffer = buffer.substring(1);
}
  
  class Toto(_foo: Int, _bar: Int){
    var foo: Int=_foo;
    var bar: Int=_bar;
  }
  
  def main(args : Array[String])
  {
    var param: Toto = new Toto(0, 0);
    param.bar = read_int();
    skip();
    param.foo = read_int();
    printf("%d", param.bar + param.foo * param.bar);
  }
  
}


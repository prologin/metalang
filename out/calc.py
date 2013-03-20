
import sys

char=None

def readchar_():
  global char;
  if char == None:
    char = sys.stdin.read(1);
  return char;

def skipchar():
  global char;
  char = None;
  return;

def readchar():
  out = readchar_();
  skipchar();
  return out;

def stdinsep():
  while True:
    c = readchar_();
    if c == '\n' or c == '\t' or c == '\r' or c == ' ':
      skipchar();
    else:
      return;

def readint():
  c = readchar_();
  if c == '-':
    sign = -1;
    skipchar();
  else:
    sign = 1;
  out = 0;
  while True:
    c = readchar_();
    if c <= '9' and c >= '0' :
      out = out * 10 + int(c);
      skipchar();
    else:
      return out * sign;

def fibo( a, b, i ):
    out_ = 0;
    a2 = a;
    b2 = b;
    for j in range(0, 1 + i + 1):
      print("%d" % j, end='');
      out_ = out_ + a2;
      tmp = b2;
      b2 = b2 + a2;
      a2 = tmp;
    return out_;

n = fibo(1, 2, 4);
print("%d" % n, end='');

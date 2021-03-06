import math
import sys
char_ = None

def readchar_():
    global char_
    if char_ == None:
        char_ = sys.stdin.read(1)
    return char_

def skipchar():
    global char_
    char_ = None
    return

def stdinsep():
    while True:
        c = readchar_()
        if c == '\n' or c == '\t' or c == '\r' or c == ' ':
            skipchar()
        else:
            return

def readint():
    c = readchar_()
    if c == '-':
        sign = -1
        skipchar()
    else:
        sign = 1
    out = 0
    while True:
        c = readchar_()
        if c <= '9' and c >= '0' :
            out = out * 10 + int(c)
            skipchar()
        else:
            return out * sign

def mod(x, y):
    return x - y * math.trunc(x / y)


def exp0(a, b):
    if b == 0:
        return 1
    if mod(b, 2) == 0:
        o = exp0(a, math.trunc(b / 2))
        return o * o
    else:
        return a * exp0(a, b - 1)
a = 0
b = 0
a = readint()
stdinsep()
b = readint()
print("%d" % exp0(a, b), end='')


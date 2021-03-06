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

def readchar():
    out = readchar_()
    skipchar()
    return out

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


"""Ce test effectue un rot13 sur une chaine lue en entrée"""
strlen = readint()
stdinsep()
tab4 = [None] * strlen
for toto in range(0, strlen):
    tmpc = readchar()
    c = ord(tmpc)
    if tmpc != ' ':
        c = mod(c - ord('a') + 13, 26) + ord('a')
    tab4[toto] = c
for j in range(0, strlen):
    print("%c" % tab4[j], end='')


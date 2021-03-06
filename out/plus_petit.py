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


def go0(tab, a, b):
    m = math.trunc((a + b) / 2)
    if a == m:
        if tab[a] == m:
            return b
        else:
            return a
    i = a
    j = b
    while i < j:
        e = tab[i]
        if e < m:
            i += 1
        else:
            j -= 1
            tab[i] = tab[j]
            tab[j] = e
    if i < m:
        return go0(tab, a, m)
    else:
        return go0(tab, m, b)
def plus_petit0(tab, len):
    return go0(tab, 0, len)
len = 0
len = readint()
stdinsep()
tab = [None] * len
for i in range(0, len):
    tmp = 0
    tmp = readint()
    stdinsep()
    tab[i] = tmp
print("%d" % plus_petit0(tab, len), end='')


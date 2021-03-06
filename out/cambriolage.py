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


def nbPassePartout(n, passepartout, m, serrures):
    max_ancient = 0
    max_recent = 0
    for i in range(0, m):
        if serrures[i][0] == -1 and serrures[i][1] > max_ancient:
            max_ancient = serrures[i][1]
        if serrures[i][0] == 1 and serrures[i][1] > max_recent:
            max_recent = serrures[i][1]
    max_ancient_pp = 0
    max_recent_pp = 0
    for i in range(0, n):
        pp = passepartout[i]
        if pp[0] >= max_ancient and pp[1] >= max_recent:
            return 1
        max_ancient_pp = max(max_ancient_pp, pp[0])
        max_recent_pp = max(max_recent_pp, pp[1])
    if max_ancient_pp >= max_ancient and max_recent_pp >= max_recent:
        return 2
    else:
        return 0
n = readint()
stdinsep()
passepartout = [None] * n
for i in range(0, n):
    out0 = [None] * 2
    for j in range(0, 2):
        out01 = readint()
        stdinsep()
        out0[j] = out01
    passepartout[i] = out0
m = readint()
stdinsep()
serrures = [None] * m
for k in range(0, m):
    out1 = [None] * 2
    for l in range(0, 2):
        out_ = readint()
        stdinsep()
        out1[l] = out_
    serrures[k] = out1
print("%d" % nbPassePartout(n, passepartout, m, serrures), end='')


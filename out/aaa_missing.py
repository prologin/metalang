"""
  Ce test a été généré par Metalang.
"""
def result( len, tab ):
    tab2 = [None] * len
    for i in range(0, len):
      tab2[i] = False;
    for i1 in range(0, len):
      tab2[tab[i1]] = True;
    for i2 in range(0, len):
      if not (tab2[i2]):
        return i2;
    return -(1);

len = int(input());
print("%d\n" % ( len ), end='')
tab = list(map(int, input().split()));
print("%d" % result(len, tab), end='')


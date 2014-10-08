require "scanf.rb"
def pathfind_aux( cache, tab, x, y, posX, posY )
    if posX == x - 1 && posY == y - 1 then
      return (0);
    elsif posX < 0 || posY < 0 || posX >= x || posY >= y then
      return (x * y * 10);
    elsif tab[posY][posX] == "#" then
      return (x * y * 10);
    elsif cache[posY][posX] != -1 then
      return (cache[posY][posX]);
    else
      cache[posY][posX] = x * y * 10;
      val1 = pathfind_aux(cache, tab, x, y, posX + 1, posY)
      val2 = pathfind_aux(cache, tab, x, y, posX - 1, posY)
      val3 = pathfind_aux(cache, tab, x, y, posX, posY - 1)
      val4 = pathfind_aux(cache, tab, x, y, posX, posY + 1)
      k = [val1, val2, val3, val4].min
      out0 = 1 + k
      cache[posY][posX] = out0;
      return (out0);
    end
end

def pathfind( tab, x, y )
    cache = [];
    for i in (0 ..  y - 1) do
      tmp = [];
      for j in (0 ..  x - 1) do
        printf "%c", tab[i][j]
        tmp[j] = -1;
      end
      print "\n";
      cache[i] = tmp;
    end
    return (pathfind_aux(cache, tab, x, y, 0, 0));
end

m=scanf("%d")[0];
scanf("%*\n");
x = m
p=scanf("%d")[0];
scanf("%*\n");
y = p
printf "%d %d\n", x, y
r = [];
for s in (0 ..  y - 1) do
  u = [];
  for v in (0 ..  x - 1) do
    w=scanf("%c")[0];
    u[v] = w;
  end
  scanf("%*\n");
  r[s] = u;
end
tab = r
result = pathfind(tab, x, y)
printf "%d", result


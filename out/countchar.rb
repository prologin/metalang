require "scanf.rb"
def nth( tab, tofind, len )
    out0 = 0
    for i in (0 ..  len - 1) do
      if tab[i] == tofind then
        out0 += 1
      end
    end
    return (out0);
end

len = 0
len=scanf("%d")[0];
scanf("%*\n");
tofind = "\000"
tofind=scanf("%c")[0];
scanf("%*\n");
tab = [];
for i in (0 ..  len - 1) do
  tmp = "\000"
  tmp=scanf("%c")[0];
  tab[i] = tmp;
end
result = nth(tab, tofind, len)
printf "%d", result


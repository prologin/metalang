
require "scanf.rb"

def mod(x, y)
  return x - y * (x.to_f / y).to_i
end

def exp_( a, b )
    if b == 0 then
      return (1);
    end
    if (mod(b, 2)) == 0 then
      o = exp_(a, (b.to_f / 2).to_i)
      return (o * o);
    else
      return (a * exp_(a, b - 1));
    end
end

a = 0
b = 0
a=scanf("%d")[0];
scanf("%*\n");
b=scanf("%d")[0];
c = exp_(a, b)
printf "%d", c


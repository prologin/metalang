
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler05 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

function max2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a > b
  then
    return a;
  else
    return b;
  end if;
end;
type e is Array (Integer range <>) of Integer;
type e_PTR is access e;
function primesfactors(c : in Integer) return e_PTR is
  tab : e_PTR;
  n : Integer;
  d : Integer;
begin
  n := c;
  tab := new e (0..n);
  for i in integer range 0..n loop
    tab(i) := 0;
  end loop;
  d := 2;
  while n /= 1 and then d * d <= n loop
    if n rem d = 0
    then
      tab(d) := tab(d) + 1;
      n := n / d;
    else
      d := d + 1;
    end if;
  end loop;
  tab(n) := tab(n) + 1;
  return tab;
end;

  t : e_PTR;
  product : Integer;
  o : e_PTR;
  lim : Integer;
begin
  lim := 20;
  o := new e (0..lim);
  for m in integer range 0..lim loop
    o(m) := 0;
  end loop;
  for i in integer range 1..lim loop
    t := primesfactors(i);
    for j in integer range 1..i loop
      o(j) := max2_0(o(j), t(j));
    end loop;
  end loop;
  product := 1;
  for k in integer range 1..lim loop
    for l in integer range 1..o(k) loop
      product := product * k;
    end loop;
  end loop;
  PInt(product);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

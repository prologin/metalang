
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler50 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

function min2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a < b
  then
    return a;
  else
    return b;
  end if;
end;
type c is Array (Integer range <>) of Integer;
type c_PTR is access c;
function eratostene(t : in c_PTR; max0 : in Integer) return Integer is
  n : Integer;
  j : Integer;
begin
  n := 0;
  for i in integer range 2..max0 - 1 loop
    if t(i) = i
    then
      n := n + 1;
      if max0 / i > i
      then
        j := i * i;
        while j < max0 and then j > 0 loop
          t(j) := 0;
          j := j + i;
        end loop;
      end if;
    end if;
  end loop;
  return n;
end;

  sum : c_PTR;
  stop : Integer;
  resp : Integer;
  process : Boolean;
  primes : c_PTR;
  nprimes : Integer;
  maxl : Integer;
  maximumprimes : Integer;
  len : Integer;
  l : Integer;
  era : c_PTR;
begin
  maximumprimes := 1000001;
  era := new c (0..maximumprimes - 1);
  for j in integer range 0..maximumprimes - 1 loop
    era(j) := j;
  end loop;
  nprimes := eratostene(era, maximumprimes);
  primes := new c (0..nprimes - 1);
  for o in integer range 0..nprimes - 1 loop
    primes(o) := 0;
  end loop;
  l := 0;
  for k in integer range 2..maximumprimes - 1 loop
    if era(k) = k
    then
      primes(l) := k;
      l := l + 1;
    end if;
  end loop;
  PInt(l);
  PString(new char_array'( To_C(" == ")));
  PInt(nprimes);
  PString(new char_array'( To_C("" & Character'Val(10))));
  sum := new c (0..nprimes - 1);
  for i_0 in integer range 0..nprimes - 1 loop
    sum(i_0) := primes(i_0);
  end loop;
  maxl := 0;
  process := TRUE;
  stop := maximumprimes - 1;
  len := 1;
  resp := 1;
  while process loop
    process := FALSE;
    for i in integer range 0..stop loop
      if i + len < nprimes
      then
        sum(i) := sum(i) + primes(i + len);
        if maximumprimes > sum(i)
        then
          process := TRUE;
          if era(sum(i)) = sum(i)
          then
            maxl := len;
            resp := sum(i);
          end if;
        else
          stop := min2_0(stop, i);
        end if;
      end if;
    end loop;
    len := len + 1;
  end loop;
  PInt(resp);
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(maxl);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

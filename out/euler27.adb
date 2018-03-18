
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler27 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
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
      j := i * i;
      while j < max0 and then j > 0 loop
        t(j) := 0;
        j := j + i;
      end loop;
    end if;
  end loop;
  return n;
end;
function isPrime(d : in Integer; primes : in c_PTR; len : in Integer) return Boolean is
  n : Integer;
  i : Integer;
begin
  n := d;
  i := 0;
  if n < 0
  then
    n := (-n);
  end if;
  while primes(i) * primes(i) < n loop
    if n rem primes(i) = 0
    then
      return FALSE;
    end if;
    i := i + 1;
  end loop;
  return TRUE;
end;
function test(a : in Integer; b : in Integer; primes : in c_PTR; len : in Integer) return Integer is
  j : Integer;
begin
  for n in integer range 0..200 loop
    j := n * n + a * n + b;
    if not isPrime(j, primes, len)
    then
      return n;
    end if;
  end loop;
  return 200;
end;

  result : Integer;
  primes : c_PTR;
  nprimes : Integer;
  n2 : Integer;
  n1 : Integer;
  mb : Integer;
  maximumprimes : Integer;
  max0 : Integer;
  ma : Integer;
  l : Integer;
  era : c_PTR;
begin
  maximumprimes := 1000;
  era := new c (0..maximumprimes - 1);
  for j in integer range 0..maximumprimes - 1 loop
    era(j) := j;
  end loop;
  result := 0;
  max0 := 0;
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
  ma := 0;
  mb := 0;
  for b in integer range 3..999 loop
    if era(b) = b
    then
      for a in integer range (-999)..999 loop
        n1 := test(a, b, primes, nprimes);
        n2 := test(a, (-b), primes, nprimes);
        if n1 > max0
        then
          max0 := n1;
          result := a * b;
          ma := a;
          mb := b;
        end if;
        if n2 > max0
        then
          max0 := n2;
          result := (-a) * b;
          ma := a;
          mb := (-b);
        end if;
      end loop;
    end if;
  end loop;
  PInt(ma);
  PString(new char_array'( To_C(" ")));
  PInt(mb);
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(max0);
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(result);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

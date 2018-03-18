
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler12 is


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
      j := i * i;
      n := n + 1;
      while j < max0 and then j > 0 loop
        t(j) := 0;
        j := j + i;
      end loop;
    end if;
  end loop;
  return n;
end;
function fillPrimesFactors(t : in c_PTR; e : in Integer; primes : in c_PTR; nprimes : in Integer) return Integer is
  n : Integer;
  d : Integer;
begin
  n := e;
  for i in integer range 0..nprimes - 1 loop
    d := primes(i);
    while n rem d = 0 loop
      t(d) := t(d) + 1;
      n := n / d;
    end loop;
    if n = 1
    then
      return primes(i);
    end if;
  end loop;
  return n;
end;
function find(ndiv2 : in Integer) return Integer is
  primesFactors : c_PTR;
  primes : c_PTR;
  nprimes : Integer;
  ndivs : Integer;
  maximumprimes : Integer;
  max0 : Integer;
  l : Integer;
  era : c_PTR;
begin
  maximumprimes := 110;
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
  for n in integer range 1..10000 loop
    primesFactors := new c (0..n + 1);
    for m in integer range 0..n + 1 loop
      primesFactors(m) := 0;
    end loop;
    max0 := max2_0(fillPrimesFactors(primesFactors, n, primes, nprimes), fillPrimesFactors(primesFactors, n + 1, primes, nprimes));
    primesFactors(2) := primesFactors(2) - 1;
    ndivs := 1;
    for i in integer range 0..max0 loop
      if primesFactors(i) /= 0
      then
        ndivs := ndivs * (1 + primesFactors(i));
      end if;
    end loop;
    if ndivs > ndiv2
    then
      return n * (n + 1) / 2;
    end if;
    -- print "n=" print n print "\t" print (n * (n + 1) / 2 ) print " " print ndivs print "\n" 
    
  end loop;
  return 0;
end;

begin
  PInt(find(500));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

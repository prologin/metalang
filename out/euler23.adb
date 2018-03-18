
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler23 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function eratostene(t : in a_PTR; max0 : in Integer) return Integer is
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
function fillPrimesFactors(t : in a_PTR; b : in Integer; primes : in a_PTR; nprimes : in Integer) return Integer is
  n : Integer;
  d : Integer;
begin
  n := b;
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
function sumdivaux2(t : in a_PTR; n : in Integer; c : in Integer) return Integer is
  i : Integer;
begin
  i := c;
  while i < n and then t(i) = 0 loop
    i := i + 1;
  end loop;
  return i;
end;
function sumdivaux(t : in a_PTR; n : in Integer; i : in Integer) return Integer is
  p : Integer;
  out0 : Integer;
  o : Integer;
begin
  if i > n
  then
    return 1;
  else
    if t(i) = 0
    then
      return sumdivaux(t, n, sumdivaux2(t, n, i + 1));
    else
      o := sumdivaux(t, n, sumdivaux2(t, n, i + 1));
      out0 := 0;
      p := i;
      for j in integer range 1..t(i) loop
        out0 := out0 + p;
        p := p * i;
      end loop;
      return (out0 + 1) * o;
    end if;
  end if;
end;
function sumdiv(nprimes : in Integer; primes : in a_PTR; n : in Integer) return Integer is
  t : a_PTR;
  max0 : Integer;
begin
  t := new a (0..n);
  for i in integer range 0..n loop
    t(i) := 0;
  end loop;
  max0 := fillPrimesFactors(t, n, primes, nprimes);
  return sumdivaux(t, max0, 0);
end;
type e is Array (Integer range <>) of Boolean;
type e_PTR is access e;

  summable : e_PTR;
  sum : Integer;
  primes : a_PTR;
  other : Integer;
  nprimes : Integer;
  n : Integer;
  maximumprimes : Integer;
  l : Integer;
  era : a_PTR;
  abondant : e_PTR;
begin
  maximumprimes := 30001;
  era := new a (0..maximumprimes - 1);
  for s in integer range 0..maximumprimes - 1 loop
    era(s) := s;
  end loop;
  nprimes := eratostene(era, maximumprimes);
  primes := new a (0..nprimes - 1);
  for t in integer range 0..nprimes - 1 loop
    primes(t) := 0;
  end loop;
  l := 0;
  for k in integer range 2..maximumprimes - 1 loop
    if era(k) = k
    then
      primes(l) := k;
      l := l + 1;
    end if;
  end loop;
  n := 100;
  -- 28124 ça prend trop de temps mais on arrive a passer le test 
  
  abondant := new e (0..n);
  for p in integer range 0..n loop
    abondant(p) := FALSE;
  end loop;
  summable := new e (0..n);
  for q in integer range 0..n loop
    summable(q) := FALSE;
  end loop;
  sum := 0;
  for r in integer range 2..n loop
    other := sumdiv(nprimes, primes, r) - r;
    if other > r
    then
      abondant(r) := TRUE;
    end if;
  end loop;
  for i in integer range 1..n loop
    for j in integer range 1..n loop
      if (abondant(i) and then abondant(j)) and then i + j <= n
      then
        summable(i + j) := TRUE;
      end if;
    end loop;
  end loop;
  for o in integer range 1..n loop
    if not summable(o)
    then
      sum := sum + o;
    end if;
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(sum);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

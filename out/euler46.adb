
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler46 is


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
type b is Array (Integer range <>) of Boolean;
type b_PTR is access b;

  primes : a_PTR;
  nprimes : Integer;
  n : Integer;
  maximumprimes : Integer;
  m2 : Integer;
  l : Integer;
  era : a_PTR;
  canbe : b_PTR;
begin
  maximumprimes := 6000;
  era := new a (0..maximumprimes - 1);
  for j_0 in integer range 0..maximumprimes - 1 loop
    era(j_0) := j_0;
  end loop;
  nprimes := eratostene(era, maximumprimes);
  primes := new a (0..nprimes - 1);
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
  canbe := new b (0..maximumprimes - 1);
  for i_0 in integer range 0..maximumprimes - 1 loop
    canbe(i_0) := FALSE;
  end loop;
  for i in integer range 0..nprimes - 1 loop
    for j in integer range 0..maximumprimes - 1 loop
      n := primes(i) + 2 * j * j;
      if n < maximumprimes
      then
        canbe(n) := TRUE;
      end if;
    end loop;
  end loop;
  for m in integer range 1..maximumprimes loop
    m2 := m * 2 + 1;
    if m2 < maximumprimes and then not canbe(m2)
    then
      PInt(m2);
      PString(new char_array'( To_C("" & Character'Val(10))));
    end if;
  end loop;
end;


with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler10 is


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
  sum : Integer;
  j : Integer;
begin
  sum := 0;
  for i in integer range 2..max0 - 1 loop
    if t(i) = i
    then
      sum := sum + i;
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
  return sum;
end;

  t : a_PTR;
  n : Integer;
begin
  n := 100000;
  -- normalement on met 2000 000 mais là on se tape des int overflow dans plein de langages 
  
  t := new a (0..n - 1);
  for i in integer range 0..n - 1 loop
    t(i) := i;
  end loop;
  t(1) := 0;
  PInt(eratostene(t, n));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

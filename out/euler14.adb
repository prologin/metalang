
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler14 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

function next0(n : in Integer) return Integer is
begin
  if n rem 2 = 0
  then
    return n / 2;
  else
    return 3 * n + 1;
  end if;
end;
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function find(n : in Integer; m : in a_PTR) return Integer is
begin
  if n = 1
  then
    return 1;
  else
    if n >= 1000000
    then
      return 1 + find(next0(n), m);
    else
      if m(n) /= 0
      then
        return m(n);
      else
        m(n) := 1 + find(next0(n), m);
        return m(n);
      end if;
    end if;
  end if;
end;

  n2 : Integer;
  maxi : Integer;
  max0 : Integer;
  m : a_PTR;
begin
  m := new a (0..999999);
  for j in integer range 0..999999 loop
    m(j) := 0;
  end loop;
  max0 := 0;
  maxi := 0;
  for i in integer range 1..999 loop
    -- normalement on met 999999 mais ça dépasse les int32... 
    
    n2 := find(i, m);
    if n2 > max0
    then
      max0 := n2;
      maxi := i;
    end if;
  end loop;
  PInt(max0);
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(maxi);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

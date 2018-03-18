
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler07 is


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
function divisible(n : in Integer; t : in a_PTR; size : in Integer) return Boolean is
begin
  for i in integer range 0..size - 1 loop
    if n rem t(i) = 0
    then
      return TRUE;
    end if;
  end loop;
  return FALSE;
end;
function find(b : in Integer; t : in a_PTR; c : in Integer; nth : in Integer) return Integer is
  used : Integer;
  n : Integer;
begin
  n := b;
  used := c;
  while used /= nth loop
    if divisible(n, t, used)
    then
      n := n + 1;
    else
      t(used) := n;
      n := n + 1;
      used := used + 1;
    end if;
  end loop;
  return t(used - 1);
end;

  t : a_PTR;
  n : Integer;
begin
  n := 10001;
  t := new a (0..n - 1);
  for i in integer range 0..n - 1 loop
    t(i) := 2;
  end loop;
  PInt(find(3, t, 1, n));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

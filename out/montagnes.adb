
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure montagnes is


type stringptr is access all char_array;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

procedure SkipSpaces is
  C : Character;
  Eol : Boolean;
begin
  loop
    Look_Ahead(C, Eol);
    exit when Eol or C /= ' ';
    Get(C);
  end loop;
end;
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function montagnes0(tab : in a_PTR; len : in Integer) return Integer is
  x : Integer;
  max0 : Integer;
  j : Integer;
  i : Integer;
begin
  max0 := 1;
  j := 1;
  i := len - 2;
  while i >= 0 loop
    x := tab(i);
    while j >= 0 and then x > tab(len - j) loop
      j := j - 1;
    end loop;
    j := j + 1;
    tab(len - j) := x;
    if j > max0
    then
      max0 := j;
    end if;
    i := i - 1;
  end loop;
  return max0;
end;

  x : Integer;
  tab : a_PTR;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    x := 0;
    Get(x);
    SkipSpaces;
    tab(i) := x;
  end loop;
  PInt(montagnes0(tab, len));
end;

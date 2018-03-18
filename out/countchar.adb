
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure countchar is


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
type a is Array (Integer range <>) of Character;
type a_PTR is access a;
function nth(tab : in a_PTR; tofind : in Character; len : in Integer) return Integer is
  out0 : Integer;
begin
  out0 := 0;
  for i in integer range 0..len - 1 loop
    if tab(i) = tofind
    then
      out0 := out0 + 1;
    end if;
  end loop;
  return out0;
end;

  tofind : Character;
  tmp : Character;
  tab : a_PTR;
  result : Integer;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tofind := Character'Val(0);
  Get(tofind);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := Character'Val(0);
    Get(tmp);
    tab(i) := tmp;
  end loop;
  result := nth(tab, tofind, len);
  PInt(result);
end;

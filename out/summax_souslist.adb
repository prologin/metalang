
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure summax_souslist is


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
function summax(lst : in a_PTR; len : in Integer) return Integer is
  max0 : Integer;
  current : Integer;
begin
  current := 0;
  max0 := 0;
  for i in integer range 0..len - 1 loop
    current := current + lst(i);
    if current < 0
    then
      current := 0;
    end if;
    if max0 < current
    then
      max0 := current;
    end if;
  end loop;
  return max0;
end;

  tmp : Integer;
  tab : a_PTR;
  result : Integer;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := 0;
    Get(tmp);
    SkipSpaces;
    tab(i) := tmp;
  end loop;
  result := summax(tab, len);
  PInt(result);
end;

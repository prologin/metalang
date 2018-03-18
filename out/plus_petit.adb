
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure plus_petit is


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
type c is Array (Integer range <>) of Integer;
type c_PTR is access c;
function go0(tab : in c_PTR; a : in Integer; b : in Integer) return Integer is
  m : Integer;
  j : Integer;
  i : Integer;
  e : Integer;
begin
  m := (a + b) / 2;
  if a = m
  then
    if tab(a) = m
    then
      return b;
    else
      return a;
    end if;
  end if;
  i := a;
  j := b;
  while i < j loop
    e := tab(i);
    if e < m
    then
      i := i + 1;
    else
      j := j - 1;
      tab(i) := tab(j);
      tab(j) := e;
    end if;
  end loop;
  if i < m
  then
    return go0(tab, a, m);
  else
    return go0(tab, m, b);
  end if;
end;
function plus_petit0(tab : in c_PTR; len : in Integer) return Integer is
begin
  return go0(tab, 0, len);
end;

  tmp : Integer;
  tab : c_PTR;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tab := new c (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := 0;
    Get(tmp);
    SkipSpaces;
    tab(i) := tmp;
  end loop;
  PInt(plus_petit0(tab, len));
end;

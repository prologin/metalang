
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure devine is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
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
function devine0(nombre : in Integer; tab : in a_PTR; len : in Integer) return Boolean is
  min0 : Integer;
  max0 : Integer;
begin
  min0 := tab(0);
  max0 := tab(1);
  for i in integer range 2..len - 1 loop
    if tab(i) > max0 or else tab(i) < min0
    then
      return FALSE;
    end if;
    if tab(i) < nombre
    then
      min0 := tab(i);
    end if;
    if tab(i) > nombre
    then
      max0 := tab(i);
    end if;
    if tab(i) = nombre and then len /= i + 1
    then
      return FALSE;
    end if;
  end loop;
  return TRUE;
end;

  tmp : Integer;
  tab : a_PTR;
  nombre : Integer;
  len : Integer;
begin
  Get(nombre);
  SkipSpaces;
  Get(len);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    Get(tmp);
    SkipSpaces;
    tab(i) := tmp;
  end loop;
  if devine0(nombre, tab, len)
  then
    PString(new char_array'( To_C("True")));
  else
    PString(new char_array'( To_C("False")));
  end if;
end;

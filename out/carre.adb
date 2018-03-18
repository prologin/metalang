
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure carre is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
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
function min2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a < b
  then
    return a;
  else
    return b;
  end if;
end;
type g is Array (Integer range <>) of Integer;
type g_PTR is access g;
type h is Array (Integer range <>) of g_PTR;
type h_PTR is access h;

  y : Integer;
  x : Integer;
  tab : h_PTR;
  e : g_PTR;
begin
  Get(x);
  SkipSpaces;
  Get(y);
  SkipSpaces;
  tab := new h (0..y - 1);
  for d in integer range 0..y - 1 loop
    e := new g (0..x - 1);
    for f in integer range 0..x - 1 loop
      Get(e(f));
      SkipSpaces;
    end loop;
    tab(d) := e;
  end loop;
  for ix in integer range 1..x - 1 loop
    for iy in integer range 1..y - 1 loop
      if tab(iy)(ix) = 1
      then
        tab(iy)(ix) := min2_0(min2_0(tab(iy)(ix - 1), tab(iy - 1)(ix)), tab(iy - 1)(ix - 1)) + 1;
      end if;
    end loop;
  end loop;
  for jy in integer range 0..y - 1 loop
    for jx in integer range 0..x - 1 loop
      PInt(tab(jy)(jx));
      PString(new char_array'( To_C(" ")));
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

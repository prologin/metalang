
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_06readcouple is


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

type d is Array (Integer range <>) of Integer;
type d_PTR is access d;

  l : d_PTR;
  b : Integer;
  a : Integer;
begin
  for i in integer range 1..3 loop
    Get(a);
    SkipSpaces;
    Get(b);
    SkipSpaces;
    PString(new char_array'( To_C("a = ")));
    PInt(a);
    PString(new char_array'( To_C(" b = ")));
    PInt(b);
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  l := new d (0..9);
  for c in integer range 0..9 loop
    Get(l(c));
    SkipSpaces;
  end loop;
  for j in integer range 0..9 loop
    PInt(l(j));
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

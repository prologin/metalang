
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_07triplet is


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

type e is Array (Integer range <>) of Integer;
type e_PTR is access e;

  l : e_PTR;
  c : Integer;
  b : Integer;
  a : Integer;
begin
  for i in integer range 1..3 loop
    Get(a);
    SkipSpaces;
    Get(b);
    SkipSpaces;
    Get(c);
    SkipSpaces;
    PString(new char_array'( To_C("a = ")));
    PInt(a);
    PString(new char_array'( To_C(" b = ")));
    PInt(b);
    PString(new char_array'( To_C("c =")));
    PInt(c);
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  l := new e (0..9);
  for d in integer range 0..9 loop
    Get(l(d));
    SkipSpaces;
  end loop;
  for j in integer range 0..9 loop
    PInt(l(j));
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

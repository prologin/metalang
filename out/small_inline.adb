
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure small_inline is


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

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;

  t : a_PTR;
begin
  t := new a (0..1);
  for d in integer range 0..1 loop
    Get(t(d));
    SkipSpaces;
  end loop;
  PInt(t(0));
  PString(new char_array'( To_C(" - ")));
  PInt(t(1));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

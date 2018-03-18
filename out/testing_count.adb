
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure testing_count is


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

  tab : a_PTR;
begin
  tab := new a (0..39);
  for i in integer range 0..39 loop
    tab(i) := i * i;
  end loop;
  PInt(tab'Length);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

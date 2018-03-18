
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_11arrayconst is


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
procedure test(tab : in a_PTR; len : in Integer) is
begin
  for i in integer range 0..len - 1 loop
    PInt(tab(i));
    PString(new char_array'( To_C(" ")));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

  t : a_PTR;
begin
  t := new a (0..4);
  for i in integer range 0..4 loop
    t(i) := 1;
  end loop;
  test(t, 5);
end;


with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_10stringsarray is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
type toto;
type toto_PTR is access toto;
type toto is record
  s : stringptr;
  v : Integer;
end record;
function idstring(s : in stringptr) return stringptr is
begin
  return s;
end;
procedure printstring(s : in stringptr) is
begin
  PString(idstring(s));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;
procedure print_toto(t : in toto_PTR) is
begin
  PString(t.s);
  PString(new char_array'( To_C(" = ")));
  PInt(t.v);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;
type b is Array (Integer range <>) of stringptr;
type b_PTR is access b;

  tab : b_PTR;
  a : toto_PTR;
begin
  tab := new b (0..1);
  for i in integer range 0..1 loop
    tab(i) := idstring(new char_array'( To_C("chaine de test")));
  end loop;
  for j in integer range 0..1 loop
    printstring(idstring(tab(j)));
  end loop;
  a := new toto;
  a.s := new char_array'( To_C("one"));
  a.v := 1;
  print_toto(a);
end;

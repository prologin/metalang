
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure record3 is


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
type toto;
type toto_PTR is access toto;
type toto is record
  foo : Integer;
  bar : Integer;
  blah : Integer;
end record;
function mktoto(v1 : in Integer) return toto_PTR is
  t : toto_PTR;
begin
  t := new toto;
  t.foo := v1;
  t.bar := 0;
  t.blah := 0;
  return t;
end;
type a is Array (Integer range <>) of toto_PTR;
type a_PTR is access a;
function result(t : in a_PTR; len : in Integer) return Integer is
  out0 : Integer;
begin
  out0 := 0;
  for j in integer range 0..len - 1 loop
    t(j).blah := t(j).blah + 1;
    out0 := out0 + t(j).foo + t(j).blah * t(j).bar + t(j).bar * t(j).foo;
  end loop;
  return out0;
end;

  titi : Integer;
  t : a_PTR;
begin
  t := new a (0..3);
  for i in integer range 0..3 loop
    t(i) := mktoto(i);
  end loop;
  Get(t(0).bar);
  SkipSpaces;
  Get(t(1).blah);
  titi := result(t, 4);
  PInt(titi);
  PInt(t(2).blah);
end;

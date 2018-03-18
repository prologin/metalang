
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure affect is


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
--
--Ce test permet de vérifier que l'implémentation de l'affectation fonctionne correctement
--

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
  t.bar := v1;
  t.blah := v1;
  return t;
end;
function mktoto2(v1 : in Integer) return toto_PTR is
  t : toto_PTR;
begin
  t := new toto;
  t.foo := v1 + 3;
  t.bar := v1 + 2;
  t.blah := v1 + 1;
  return t;
end;
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function result(t_0 : in toto_PTR; t2_0 : in toto_PTR) return Integer is
  t3 : toto_PTR;
  t2 : toto_PTR;
  t : toto_PTR;
  len : Integer;
  cache2 : a_PTR;
  cache1 : a_PTR;
  cache0 : a_PTR;
begin
  t := t_0;
  t2 := t2_0;
  t3 := new toto;
  t3.foo := 0;
  t3.bar := 0;
  t3.blah := 0;
  t3 := t2;
  t := t2;
  t2 := t3;
  t.blah := t.blah + 1;
  len := 1;
  cache0 := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    cache0(i) := (-i);
  end loop;
  cache1 := new a (0..len - 1);
  for j in integer range 0..len - 1 loop
    cache1(j) := j;
  end loop;
  cache2 := cache0;
  cache0 := cache1;
  cache2 := cache0;
  return t.foo + t.blah * t.bar + t.bar * t.foo;
end;

  t2 : toto_PTR;
  t : toto_PTR;
begin
  t := mktoto(4);
  t2 := mktoto(5);
  Get(t.bar);
  SkipSpaces;
  Get(t.blah);
  SkipSpaces;
  Get(t2.bar);
  SkipSpaces;
  Get(t2.blah);
  PInt(result(t, t2));
  PInt(t.blah);
end;

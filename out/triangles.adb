
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure triangles is


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
-- Ce code a été généré par metalang
--   Il gère les entrées sorties pour un programme dynamique classique
--   dans les épreuves de prologin
--on le retrouve ici : http://projecteuler.net/problem=18
--

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
type b is Array (Integer range <>) of a_PTR;
type b_PTR is access b;
function find0(len : in Integer; tab : in b_PTR; cache : in b_PTR; x : in Integer; y : in Integer) return Integer is
  result : Integer;
  out1 : Integer;
  out0 : Integer;
begin
  --
  --	Cette fonction est récursive
  --	
  
  if y = len - 1
  then
    return tab(y)(x);
  else
    if x > y
    then
      return (-10000);
    else
      if cache(y)(x) /= 0
      then
        return cache(y)(x);
      end if;
    end if;
  end if;
  result := 0;
  out0 := find0(len, tab, cache, x, y + 1);
  out1 := find0(len, tab, cache, x + 1, y + 1);
  if out0 > out1
  then
    result := out0 + tab(y)(x);
  else
    result := out1 + tab(y)(x);
  end if;
  cache(y)(x) := result;
  return result;
end;
function find(len : in Integer; tab : in b_PTR) return Integer is
  tab3 : a_PTR;
  tab2 : b_PTR;
begin
  tab2 := new b (0..len - 1);
  for i in integer range 0..len - 1 loop
    tab3 := new a (0..i);
    for j in integer range 0..i loop
      tab3(j) := 0;
    end loop;
    tab2(i) := tab3;
  end loop;
  return find0(len, tab, tab2, 0, 0);
end;

  tmp : Integer;
  tab2 : a_PTR;
  tab : b_PTR;
  len : Integer;
begin
  Get(len);
  SkipSpaces;
  tab := new b (0..len - 1);
  for i in integer range 0..len - 1 loop
    tab2 := new a (0..i);
    for j in integer range 0..i loop
      Get(tmp);
      SkipSpaces;
      tab2(j) := tmp;
    end loop;
    tab(i) := tab2;
  end loop;
  PInt(find(len, tab));
  PString(new char_array'( To_C("" & Character'Val(10))));
  for k in integer range 0..len - 1 loop
    for l in integer range 0..k loop
      PInt(tab(k)(l));
      PString(new char_array'( To_C(" ")));
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

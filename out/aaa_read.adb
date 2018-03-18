
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_read is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PChar(c : in Character) is
begin
  Character'Write (Text_Streams.Stream (Current_Output), c);
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
--
--Ce test permet de vérifier si les différents backends pour les langages implémentent bien
--read int, read char et skip
--

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
type b is Array (Integer range <>) of Character;
type b_PTR is access b;

  tmpi2 : Integer;
  tmpi1 : Integer;
  tmpc : Character;
  tab4 : b_PTR;
  tab2 : a_PTR;
  tab : a_PTR;
  strlen : Integer;
  len : Integer;
  c : Integer;
begin
  Get(len);
  SkipSpaces;
  PInt(len);
  PString(new char_array'( To_C("=len" & Character'Val(10))));
  len := len * 2;
  PString(new char_array'( To_C("len*2=")));
  PInt(len);
  PString(new char_array'( To_C("" & Character'Val(10))));
  len := len / 2;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    Get(tmpi1);
    SkipSpaces;
    PInt(i);
    PString(new char_array'( To_C("=>")));
    PInt(tmpi1);
    PString(new char_array'( To_C(" ")));
    tab(i) := tmpi1;
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  tab2 := new a (0..len - 1);
  for i_0 in integer range 0..len - 1 loop
    Get(tmpi2);
    SkipSpaces;
    PInt(i_0);
    PString(new char_array'( To_C("==>")));
    PInt(tmpi2);
    PString(new char_array'( To_C(" ")));
    tab2(i_0) := tmpi2;
  end loop;
  Get(strlen);
  SkipSpaces;
  PInt(strlen);
  PString(new char_array'( To_C("=strlen" & Character'Val(10))));
  tab4 := new b (0..strlen - 1);
  for toto in integer range 0..strlen - 1 loop
    Get(tmpc);
    c := Character'Pos(tmpc);
    PChar(tmpc);
    PString(new char_array'( To_C(":")));
    PInt(c);
    PString(new char_array'( To_C(" ")));
    if tmpc /= ' '
    then
      c := (c - Character'Pos('a') + 13) rem 26 + Character'Pos('a');
    end if;
    tab4(toto) := Character'Val(c);
  end loop;
  for j in integer range 0..strlen - 1 loop
    PChar(tab4(j));
  end loop;
end;

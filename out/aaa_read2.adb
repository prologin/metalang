
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_read2 is


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

type e is Array (Integer range <>) of Integer;
type e_PTR is access e;
type f is Array (Integer range <>) of Character;
type f_PTR is access f;

  tmpc : Character;
  tab4 : f_PTR;
  tab2 : e_PTR;
  tab : e_PTR;
  strlen : Integer;
  len : Integer;
  c : Integer;
begin
  Get(len);
  SkipSpaces;
  PInt(len);
  PString(new char_array'( To_C("=len" & Character'Val(10))));
  tab := new e (0..len - 1);
  for a in integer range 0..len - 1 loop
    Get(tab(a));
    SkipSpaces;
  end loop;
  for i in integer range 0..len - 1 loop
    PInt(i);
    PString(new char_array'( To_C("=>")));
    PInt(tab(i));
    PString(new char_array'( To_C(" ")));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  tab2 := new e (0..len - 1);
  for b in integer range 0..len - 1 loop
    Get(tab2(b));
    SkipSpaces;
  end loop;
  for i_0 in integer range 0..len - 1 loop
    PInt(i_0);
    PString(new char_array'( To_C("==>")));
    PInt(tab2(i_0));
    PString(new char_array'( To_C(" ")));
  end loop;
  Get(strlen);
  SkipSpaces;
  PInt(strlen);
  PString(new char_array'( To_C("=strlen" & Character'Val(10))));
  tab4 := new f (0..strlen - 1);
  for d in integer range 0..strlen - 1 loop
    Get(tab4(d));
  end loop;
  SkipSpaces;
  for i3 in integer range 0..strlen - 1 loop
    tmpc := tab4(i3);
    c := Character'Pos(tmpc);
    PChar(tmpc);
    PString(new char_array'( To_C(":")));
    PInt(c);
    PString(new char_array'( To_C(" ")));
    if tmpc /= ' '
    then
      c := (c - Character'Pos('a') + 13) rem 26 + Character'Pos('a');
    end if;
    tab4(i3) := Character'Val(c);
  end loop;
  for j in integer range 0..strlen - 1 loop
    PChar(tab4(j));
  end loop;
end;

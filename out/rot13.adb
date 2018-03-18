
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure rot13 is


type stringptr is access all char_array;
procedure PChar(c : in Character) is
begin
  Character'Write (Text_Streams.Stream (Current_Output), c);
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
--Ce test effectue un rot13 sur une chaine lue en entrée
--

type a is Array (Integer range <>) of Character;
type a_PTR is access a;

  tmpc : Character;
  tab4 : a_PTR;
  strlen : Integer;
  c : Integer;
begin
  Get(strlen);
  SkipSpaces;
  tab4 := new a (0..strlen - 1);
  for toto in integer range 0..strlen - 1 loop
    Get(tmpc);
    c := Character'Pos(tmpc);
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

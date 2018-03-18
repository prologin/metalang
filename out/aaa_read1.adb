
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_read1 is


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

type b is Array (Integer range <>) of Character;
type b_PTR is access b;

  str : b_PTR;
begin
  str := new b (0..11);
  for a in integer range 0..11 loop
    Get(str(a));
  end loop;
  SkipSpaces;
  for i in integer range 0..11 loop
    PChar(str(i));
  end loop;
end;

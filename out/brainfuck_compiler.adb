
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure brainfuck_compiler is


type stringptr is access all char_array;
procedure PChar(c : in Character) is
begin
  Character'Write (Text_Streams.Stream (Current_Output), c);
end;
--
--Ce test permet de tester les macros
--C'est un compilateur brainfuck qui lit sur l'entrée standard pendant la compilation
--et qui produit les macros metalang correspondante
--

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;

  mem : a_PTR;
  input : Character;
  current_pos : Integer;
begin
  input := ' ';
  current_pos := 500;
  mem := new a (0..999);
  for i in integer range 0..999 loop
    mem(i) := 0;
  end loop;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  current_pos := current_pos + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  mem(current_pos) := mem(current_pos) + 1;
  while mem(current_pos) /= 0 loop
    mem(current_pos) := mem(current_pos) - 1;
    current_pos := current_pos - 1;
    mem(current_pos) := mem(current_pos) + 1;
    PChar(Character'Val(mem(current_pos)));
    current_pos := current_pos + 1;
  end loop;
end;

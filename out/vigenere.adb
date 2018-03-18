
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure vigenere is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
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
function position_alphabet(c : in Character) return Integer is
  i : Integer;
begin
  i := Character'Pos(c);
  if i <= Character'Pos('Z') and then i >= Character'Pos('A')
  then
    return i - Character'Pos('A');
  else
    if i <= Character'Pos('z') and then i >= Character'Pos('a')
    then
      return i - Character'Pos('a');
    else
      return (-1);
    end if;
  end if;
end;
function of_position_alphabet(c : in Integer) return Character is
begin
  return Character'Val(c + Character'Pos('a'));
end;
type a is Array (Integer range <>) of Character;
type a_PTR is access a;
procedure crypte(taille_cle : in Integer; cle : in a_PTR; taille : in Integer; message : in a_PTR) is
  new0 : Integer;
  lettre : Integer;
  addon : Integer;
begin
  for i in integer range 0..taille - 1 loop
    lettre := position_alphabet(message(i));
    if lettre /= (-1)
    then
      addon := position_alphabet(cle(i rem taille_cle));
      new0 := (addon + lettre) rem 26;
      message(i) := of_position_alphabet(new0);
    end if;
  end loop;
end;

  taille_cle : Integer;
  taille : Integer;
  out2 : Character;
  out0 : Character;
  message : a_PTR;
  cle : a_PTR;
begin
  Get(taille_cle);
  SkipSpaces;
  cle := new a (0..taille_cle - 1);
  for index in integer range 0..taille_cle - 1 loop
    Get(out0);
    cle(index) := out0;
  end loop;
  SkipSpaces;
  Get(taille);
  SkipSpaces;
  message := new a (0..taille - 1);
  for index2 in integer range 0..taille - 1 loop
    Get(out2);
    message(index2) := out2;
  end loop;
  crypte(taille_cle, cle, taille, message);
  for i in integer range 0..taille - 1 loop
    PChar(message(i));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

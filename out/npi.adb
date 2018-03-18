
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure npi is


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
function is_number(c : in Character) return Boolean is
begin
  return Character'Pos(c) <= Character'Pos('9') and then Character'Pos(c) >= Character'Pos('0');
end;
--
--Notation polonaise inversée, ce test permet d'évaluer une expression écrite en NPI
--

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
type b is Array (Integer range <>) of Character;
type b_PTR is access b;
function npi0(str : in b_PTR; len : in Integer) return Integer is
  stack : a_PTR;
  ptrStr : Integer;
  ptrStack : Integer;
  num : Integer;
begin
  stack := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    stack(i) := 0;
  end loop;
  ptrStack := 0;
  ptrStr := 0;
  while ptrStr < len loop
    if str(ptrStr) = ' '
    then
      ptrStr := ptrStr + 1;
    else
      if is_number(str(ptrStr))
      then
        num := 0;
        while str(ptrStr) /= ' ' loop
          num := num * 10 + Character'Pos(str(ptrStr)) - Character'Pos('0');
          ptrStr := ptrStr + 1;
        end loop;
        stack(ptrStack) := num;
        ptrStack := ptrStack + 1;
      else
        if str(ptrStr) = '+'
        then
          stack(ptrStack - 2) := stack(ptrStack - 2) + stack(ptrStack - 1);
          ptrStack := ptrStack - 1;
          ptrStr := ptrStr + 1;
        end if;
      end if;
    end if;
  end loop;
  return stack(0);
end;

  tmp : Character;
  tab : b_PTR;
  result : Integer;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tab := new b (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := Character'Val(0);
    Get(tmp);
    tab(i) := tmp;
  end loop;
  result := npi0(tab, len);
  PInt(result);
end;

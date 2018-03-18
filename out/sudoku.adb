
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure sudoku is


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
-- lit un sudoku sur l'entrée standard 

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function read_sudoku return a_PTR is
  out0 : a_PTR;
  k : Integer;
begin
  out0 := new a (0..9 * 9 - 1);
  for i in integer range 0..9 * 9 - 1 loop
    Get(k);
    SkipSpaces;
    out0(i) := k;
  end loop;
  return out0;
end;
-- affiche un sudoku 

procedure print_sudoku(sudoku0 : in a_PTR) is
begin
  for y in integer range 0..8 loop
    for x in integer range 0..8 loop
      PInt(sudoku0(x + y * 9));
      PString(new char_array'( To_C(" ")));
      if x rem 3 = 2
      then
        PString(new char_array'( To_C(" ")));
      end if;
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
    if y rem 3 = 2
    then
      PString(new char_array'( To_C("" & Character'Val(10))));
    end if;
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;
-- dit si les variables sont toutes différentes 

-- dit si les variables sont toutes différentes 

-- dit si le sudoku est terminé de remplir 

function sudoku_done(s : in a_PTR) return Boolean is
begin
  for i in integer range 0..80 loop
    if s(i) = 0
    then
      return FALSE;
    end if;
  end loop;
  return TRUE;
end;
-- dit si il y a une erreur dans le sudoku 

function sudoku_error(s : in a_PTR) return Boolean is
  out3 : Boolean;
  out2 : Boolean;
  out1 : Boolean;
begin
  out1 := FALSE;
  for x in integer range 0..8 loop
    out1 := (((((((((((((((((((((((((((((((((((out1 or else (s(x) /= 0 and then s(x) = s(x + 9))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 2))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 2))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 3))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 3))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 3))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 4))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 4))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 4))) or else (s(x + 9 * 3) /= 0 and then s(x + 9 * 3) = s(x + 9 * 4))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 5))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 5))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 5))) or else (s(x + 9 * 3) /= 0 and then s(x + 9 * 3) = s(x + 9 * 5))) or else (s(x + 9 * 4) /= 0 and then s(x + 9 * 4) = s(x + 9 * 5))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 6))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 6))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 6))) or else (s(x + 9 * 3) /= 0 and then s(x + 9 * 3) = s(x + 9 * 6))) or else (s(x + 9 * 4) /= 0 and then s(x + 9 * 4) = s(x + 9 * 6))) or else (s(x + 9 * 5) /= 0 and then s(x + 9 * 5) = s(x + 9 * 6))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 7))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 7))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 7))) or else (s(x + 9 * 3) /= 0 and then s(x + 9 * 3) = s(x + 9 * 7))) or else (s(x + 9 * 4) /= 0 and then s(x + 9 * 4) = s(x + 9 * 7))) or else (s(x + 9 * 5) /= 0 and then s(x + 9 * 5) = s(x + 9 * 7))) or else (s(x + 9 * 6) /= 0 and then s(x + 9 * 6) = s(x + 9 * 7))) or else (s(x) /= 0 and then s(x) = s(x + 9 * 8))) or else (s(x + 9) /= 0 and then s(x + 9) = s(x + 9 * 8))) or else (s(x + 9 * 2) /= 0 and then s(x + 9 * 2) = s(x + 9 * 8))) or else (s(x + 9 * 3) /= 0 and then s(x + 9 * 3) = s(x + 9 * 8))) or else (s(x + 9 * 4) /= 0 and then s(x + 9 * 4) = s(x + 9 * 8))) or else (s(x + 9 * 5) /= 0 and then s(x + 9 * 5) = s(x + 9 * 8))) or else (s(x + 9 * 6) /= 0 and then s(x + 9 * 6) = s(x + 9 * 8))) or else (s(x + 9 * 7) /= 0 and then s(x + 9 * 7) = s(x + 9 * 8));
  end loop;
  out2 := FALSE;
  for x in integer range 0..8 loop
    out2 := (((((((((((((((((((((((((((((((((((out2 or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 1))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 2))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 2))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 3))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 3))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 3))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 4))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 4))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 4))) or else (s(x * 9 + 3) /= 0 and then s(x * 9 + 3) = s(x * 9 + 4))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 5))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 5))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 5))) or else (s(x * 9 + 3) /= 0 and then s(x * 9 + 3) = s(x * 9 + 5))) or else (s(x * 9 + 4) /= 0 and then s(x * 9 + 4) = s(x * 9 + 5))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 6))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 6))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 6))) or else (s(x * 9 + 3) /= 0 and then s(x * 9 + 3) = s(x * 9 + 6))) or else (s(x * 9 + 4) /= 0 and then s(x * 9 + 4) = s(x * 9 + 6))) or else (s(x * 9 + 5) /= 0 and then s(x * 9 + 5) = s(x * 9 + 6))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 7))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 7))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 7))) or else (s(x * 9 + 3) /= 0 and then s(x * 9 + 3) = s(x * 9 + 7))) or else (s(x * 9 + 4) /= 0 and then s(x * 9 + 4) = s(x * 9 + 7))) or else (s(x * 9 + 5) /= 0 and then s(x * 9 + 5) = s(x * 9 + 7))) or else (s(x * 9 + 6) /= 0 and then s(x * 9 + 6) = s(x * 9 + 7))) or else (s(x * 9) /= 0 and then s(x * 9) = s(x * 9 + 8))) or else (s(x * 9 + 1) /= 0 and then s(x * 9 + 1) = s(x * 9 + 8))) or else (s(x * 9 + 2) /= 0 and then s(x * 9 + 2) = s(x * 9 + 8))) or else (s(x * 9 + 3) /= 0 and then s(x * 9 + 3) = s(x * 9 + 8))) or else (s(x * 9 + 4) /= 0 and then s(x * 9 + 4) = s(x * 9 + 8))) or else (s(x * 9 + 5) /= 0 and then s(x * 9 + 5) = s(x * 9 + 8))) or else (s(x * 9 + 6) /= 0 and then s(x * 9 + 6) = s(x * 9 + 8))) or else (s(x * 9 + 7) /= 0 and then s(x * 9 + 7) = s(x * 9 + 8));
  end loop;
  out3 := FALSE;
  for x in integer range 0..8 loop
    out3 := (((((((((((((((((((((((((((((((((((out3 or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) /= 0 and then s((x rem 3) * 3 * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) /= 0 and then s(((x rem 3) * 3 + 1) * 9 + (x / 3) * 3 + 2) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3) /= 0 and then s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2))) or else (s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) /= 0 and then s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 1) = s(((x rem 3) * 3 + 2) * 9 + (x / 3) * 3 + 2));
  end loop;
  return (out1 or else out2) or else out3;
end;
-- résout le sudoku

function solve(sudoku0 : in a_PTR) return Boolean is
begin
  if sudoku_error(sudoku0)
  then
    return FALSE;
  end if;
  if sudoku_done(sudoku0)
  then
    return TRUE;
  end if;
  for i in integer range 0..80 loop
    if sudoku0(i) = 0
    then
      for p in integer range 1..9 loop
        sudoku0(i) := p;
        if solve(sudoku0)
        then
          return TRUE;
        end if;
      end loop;
      sudoku0(i) := 0;
      return FALSE;
    end if;
  end loop;
  return FALSE;
end;

  sudoku0 : a_PTR;
begin
  sudoku0 := read_sudoku;
  print_sudoku(sudoku0);
  if solve(sudoku0)
  then
    print_sudoku(sudoku0);
  else
    PString(new char_array'( To_C("no solution" & Character'Val(10))));
  end if;
end;

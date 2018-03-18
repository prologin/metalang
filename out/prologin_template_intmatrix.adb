
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure prologin_template_intmatrix is


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
type d is Array (Integer range <>) of Integer;
type d_PTR is access d;
type e is Array (Integer range <>) of d_PTR;
type e_PTR is access e;
function programme_candidat(tableau : in e_PTR; x : in Integer; y : in Integer) return Integer is
  out0 : Integer;
begin
  out0 := 0;
  for i in integer range 0..y - 1 loop
    for j in integer range 0..x - 1 loop
      out0 := out0 + tableau(i)(j) * (i * 2 + j);
    end loop;
  end loop;
  return out0;
end;

  taille_y : Integer;
  taille_x : Integer;
  tableau : e_PTR;
  b : d_PTR;
begin
  Get(taille_x);
  SkipSpaces;
  Get(taille_y);
  SkipSpaces;
  tableau := new e (0..taille_y - 1);
  for a in integer range 0..taille_y - 1 loop
    b := new d (0..taille_x - 1);
    for c in integer range 0..taille_x - 1 loop
      Get(b(c));
      SkipSpaces;
    end loop;
    tableau(a) := b;
  end loop;
  PInt(programme_candidat(tableau, taille_x, taille_y));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

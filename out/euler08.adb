
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed;

procedure euler08 is
function max2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a > b
  then
    return a;
  else
    return b;
  end if;
end;

type h is Array (Integer range <>) of Integer;
type h_PTR is access h;

  nskipdiv : Integer;
  max0 : Integer;
  last : h_PTR;
  index : Integer;
  i : Integer;
  f : Integer;
  e : Character;
  d : Integer;
  c : Character;
begin
  i := (1);
  last := new h (0..(5));
  for j in integer range (0)..(5) - (1) loop
    Get(c);
    d := Character'Pos(c) - Character'Pos('0');
    i := i * d;
    last(j) := d;
  end loop;
  max0 := i;
  index := (0);
  nskipdiv := (0);
  for k in integer range (1)..(995) loop
    Get(e);
    f := Character'Pos(e) - Character'Pos('0');
    if f = (0)
    then
      i := (1);
      nskipdiv := (4);
    else
      i := i * f;
      if nskipdiv < (0)
      then
        i := i / last(index);
      end if;
      nskipdiv := nskipdiv - (1);
    end if;
    last(index) := f;
    index := (index + (1)) rem (5);
    max0 := max2_0(max0, i);
  end loop;
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(max0), Left));
  String'Write (Text_Streams.Stream (Current_Output), "" & Character'Val(10) & "");
end;

with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed;

procedure euler24 is
function fact(n : in Integer) return Integer is
  prod : Integer;
begin
  prod := (1);
  for i in integer range (2)..n loop
    prod := prod * i;
  end loop;
  return prod;
end;

type b is Array (Integer range <>) of Integer;
type b_PTR is access b;
type c is Array (Integer range <>) of Boolean;
type c_PTR is access c;
procedure show(lim : in Integer; a : in Integer) is
  t : b_PTR;
  pris : c_PTR;
  nth : Integer;
  nchiffre : Integer;
  n : Integer;
begin
  nth := a;
  t := new b (0..lim);
  for i in integer range (0)..lim - (1) loop
    t(i) := i;
  end loop;
  pris := new c (0..lim);
  for j in integer range (0)..lim - (1) loop
    pris(j) := FALSE;
  end loop;
  for k in integer range (1)..lim - (1) loop
    n := fact(lim - k);
    nchiffre := nth / n;
    nth := nth rem n;
    for l in integer range (0)..lim - (1) loop
      if (not pris(l))
      then
        if nchiffre = (0)
        then
          String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(l), Left));
          pris(l) := TRUE;
        end if;
        nchiffre := nchiffre - (1);
      end if;
    end loop;
  end loop;
  for m in integer range (0)..lim - (1) loop
    if (not pris(m))
    then
      String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(m), Left));
    end if;
  end loop;
  String'Write (Text_Streams.Stream (Current_Output), "" & Character'Val(10) & "");
end;


  nth : Integer;
begin
  show((10), (999999));
end;
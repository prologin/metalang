
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler26 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
type e is Array (Integer range <>) of Integer;
type e_PTR is access e;
function periode(restes : in e_PTR; c : in Integer; d : in Integer; b : in Integer) return Integer is
  reste : Integer;
  len : Integer;
  chiffre : Integer;
  a : Integer;
begin
  len := c;
  a := d;
  while a /= 0 loop
    chiffre := a / b;
    reste := a rem b;
    for i in integer range 0..len - 1 loop
      if restes(i) = reste
      then
        return len - i;
      end if;
    end loop;
    restes(len) := reste;
    len := len + 1;
    a := reste * 10;
  end loop;
  return 0;
end;

  t : e_PTR;
  p : Integer;
  mi : Integer;
  m : Integer;
begin
  t := new e (0..999);
  for j in integer range 0..999 loop
    t(j) := 0;
  end loop;
  m := 0;
  mi := 0;
  for i in integer range 1..1000 loop
    p := periode(t, 0, 1, i);
    if p > m
    then
      mi := i;
      m := p;
    end if;
  end loop;
  PInt(mi);
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(m);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

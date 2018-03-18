
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler40 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

function exp0(a : in Integer; e : in Integer) return Integer is
  o : Integer;
begin
  o := 1;
  for i in integer range 1..e loop
    o := o * a;
  end loop;
  return o;
end;
type c is Array (Integer range <>) of Integer;
type c_PTR is access c;
function e(t : in c_PTR; b : in Integer) return Integer is
  nombre : Integer;
  n : Integer;
  chiffre : Integer;
begin
  n := b;
  for i in integer range 1..8 loop
    if n >= t(i) * i
    then
      n := n - t(i) * i;
    else
      nombre := exp0(10, i - 1) + n / i;
      chiffre := i - 1 - n rem i;
      return nombre / exp0(10, chiffre) rem 10;
    end if;
  end loop;
  return (-1);
end;

  v : Integer;
  t : c_PTR;
  puiss : Integer;
  out0 : Integer;
begin
  t := new c (0..8);
  for i in integer range 0..8 loop
    t(i) := exp0(10, i) - exp0(10, i - 1);
  end loop;
  for i2 in integer range 1..8 loop
    PInt(i2);
    PString(new char_array'( To_C(" => ")));
    PInt(t(i2));
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  for j in integer range 0..80 loop
    PInt(e(t, j));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  for k in integer range 1..50 loop
    PInt(k);
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  for j2 in integer range 169..220 loop
    PInt(e(t, j2));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  for k2 in integer range 90..110 loop
    PInt(k2);
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  out0 := 1;
  for l in integer range 0..6 loop
    puiss := exp0(10, l);
    v := e(t, puiss - 1);
    out0 := out0 * v;
    PString(new char_array'( To_C("10^")));
    PInt(l);
    PString(new char_array'( To_C("=")));
    PInt(puiss);
    PString(new char_array'( To_C(" v=")));
    PInt(v);
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  PInt(out0);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

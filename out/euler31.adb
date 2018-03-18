
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler31 is


type stringptr is access all char_array;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
type b is Array (Integer range <>) of a_PTR;
type b_PTR is access b;
function result(sum : in Integer; t : in a_PTR; maxIndex : in Integer; cache : in b_PTR) return Integer is
  out0 : Integer;
  div : Integer;
begin
  if cache(sum)(maxIndex) /= 0
  then
    return cache(sum)(maxIndex);
  else
    if sum = 0 or else maxIndex = 0
    then
      return 1;
    else
      out0 := 0;
      div := sum / t(maxIndex);
      for i in integer range 0..div loop
        out0 := out0 + result(sum - i * t(maxIndex), t, maxIndex - 1, cache);
      end loop;
      cache(sum)(maxIndex) := out0;
      return out0;
    end if;
  end if;
end;

  t : a_PTR;
  o : a_PTR;
  cache : b_PTR;
begin
  t := new a (0..7);
  for i in integer range 0..7 loop
    t(i) := 0;
  end loop;
  t(0) := 1;
  t(1) := 2;
  t(2) := 5;
  t(3) := 10;
  t(4) := 20;
  t(5) := 50;
  t(6) := 100;
  t(7) := 200;
  cache := new b (0..200);
  for j in integer range 0..200 loop
    o := new a (0..7);
    for k in integer range 0..7 loop
      o(k) := 0;
    end loop;
    cache(j) := o;
  end loop;
  PInt(result(200, t, 7, cache));
end;


with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler32 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
--
--We shall say that an n-digit number is pandigital if it makes use of all the digits 1 to n exactly once;
--for example, the 5-digit number, 15234, is 1 through 5 pandigital.
--
--The product 7254 is unusual, as the identity, 39 × 186 = 7254, containing multiplicand, multiplier,
--and product is 1 through 9 pandigital.
--
--Find the sum of all products whose multiplicand/multiplier/product identity can be written as a
--1 through 9 pandigital.
--
--HINT: Some products can be obtained in more than one way so be sure to only include it once in your sum.
--
--
--(a * 10 + b) ( c * 100 + d * 10 + e) =
--  a * c * 1000 +
--  a * d * 100 +
--  a * e * 10 +
--  b * c * 100 +
--  b * d * 10 +
--  b * e
--  => b != e != b * e % 10 ET
--  a != d != (b * e / 10 + b * d + a * e ) % 10
--

type f is Array (Integer range <>) of Boolean;
type f_PTR is access f;
function okdigits(ok : in f_PTR; n : in Integer) return Boolean is
  o : Boolean;
  digit : Integer;
begin
  if n = 0
  then
    return TRUE;
  else
    digit := n rem 10;
    if ok(digit)
    then
      ok(digit) := FALSE;
      o := okdigits(ok, n / 10);
      ok(digit) := TRUE;
      return o;
    else
      return FALSE;
    end if;
  end if;
end;

  product2 : Integer;
  product : Integer;
  counted : f_PTR;
  count : Integer;
  be : Integer;
  allowed : f_PTR;
begin
  count := 0;
  allowed := new f (0..9);
  for i in integer range 0..9 loop
    allowed(i) := i /= 0;
  end loop;
  counted := new f (0..99999);
  for j in integer range 0..99999 loop
    counted(j) := FALSE;
  end loop;
  for e in integer range 1..9 loop
    allowed(e) := FALSE;
    for b in integer range 1..9 loop
      if allowed(b)
      then
        allowed(b) := FALSE;
        be := b * e rem 10;
        if allowed(be)
        then
          allowed(be) := FALSE;
          for a in integer range 1..9 loop
            if allowed(a)
            then
              allowed(a) := FALSE;
              for c in integer range 1..9 loop
                if allowed(c)
                then
                  allowed(c) := FALSE;
                  for d in integer range 1..9 loop
                    if allowed(d)
                    then
                      allowed(d) := FALSE;
                      -- 2 * 3 digits 
                      
                      product := (a * 10 + b) * (c * 100 + d * 10 + e);
                      if
                      not counted(product) and then okdigits(allowed, product / 10)
                      then
                        counted(product) := TRUE;
                        count := count + product;
                        PInt(product);
                        PString(new char_array'( To_C(" ")));
                      end if;
                      -- 1  * 4 digits 
                      
                      product2 := b * (a * 1000 + c * 100 + d * 10 + e);
                      if
                      not counted(product2) and then okdigits(allowed, product2 / 10)
                      then
                        counted(product2) := TRUE;
                        count := count + product2;
                        PInt(product2);
                        PString(new char_array'( To_C(" ")));
                      end if;
                      allowed(d) := TRUE;
                    end if;
                  end loop;
                  allowed(c) := TRUE;
                end if;
              end loop;
              allowed(a) := TRUE;
            end if;
          end loop;
          allowed(be) := TRUE;
        end if;
        allowed(b) := TRUE;
      end if;
    end loop;
    allowed(e) := TRUE;
  end loop;
  PInt(count);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

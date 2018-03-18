
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler36 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;
type e is Array (Integer range <>) of Boolean;
type e_PTR is access e;
type f is Array (Integer range <>) of Integer;
type f_PTR is access f;
function palindrome2(pow2 : in f_PTR; n : in Integer) return Boolean is
  t : e_PTR;
  nnum : Integer;
begin
  t := new e (0..19);
  for i in integer range 0..19 loop
    t(i) := n / pow2(i) rem 2 = 1;
  end loop;
  nnum := 0;
  for j in integer range 1..19 loop
    if t(j)
    then
      nnum := j;
    end if;
  end loop;
  for k in integer range 0..nnum / 2 loop
    if t(k) /= t(nnum - k)
    then
      return FALSE;
    end if;
  end loop;
  return TRUE;
end;

  sum : Integer;
  pow2 : f_PTR;
  p : Integer;
  num3 : Integer;
  num2 : Integer;
  num1 : Integer;
  num0 : Integer;
  a : Integer;
begin
  p := 1;
  pow2 := new f (0..19);
  for i in integer range 0..19 loop
    p := p * 2;
    pow2(i) := p / 2;
  end loop;
  sum := 0;
  for d in integer range 1..9 loop
    if palindrome2(pow2, d)
    then
      PInt(d);
      PString(new char_array'( To_C("" & Character'Val(10))));
      sum := sum + d;
    end if;
    if palindrome2(pow2, d * 10 + d)
    then
      PInt(d * 10 + d);
      PString(new char_array'( To_C("" & Character'Val(10))));
      sum := sum + d * 10 + d;
    end if;
  end loop;
  for a0 in integer range 0..4 loop
    a := a0 * 2 + 1;
    for b in integer range 0..9 loop
      for c in integer range 0..9 loop
        num0 := a * 100000 + b * 10000 + c * 1000 + c * 100 + b * 10 + a;
        if palindrome2(pow2, num0)
        then
          PInt(num0);
          PString(new char_array'( To_C("" & Character'Val(10))));
          sum := sum + num0;
        end if;
        num1 := a * 10000 + b * 1000 + c * 100 + b * 10 + a;
        if palindrome2(pow2, num1)
        then
          PInt(num1);
          PString(new char_array'( To_C("" & Character'Val(10))));
          sum := sum + num1;
        end if;
      end loop;
      num2 := a * 100 + b * 10 + a;
      if palindrome2(pow2, num2)
      then
        PInt(num2);
        PString(new char_array'( To_C("" & Character'Val(10))));
        sum := sum + num2;
      end if;
      num3 := a * 1000 + b * 100 + b * 10 + a;
      if palindrome2(pow2, num3)
      then
        PInt(num3);
        PString(new char_array'( To_C("" & Character'Val(10))));
        sum := sum + num3;
      end if;
    end loop;
  end loop;
  PString(new char_array'( To_C("sum=")));
  PInt(sum);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

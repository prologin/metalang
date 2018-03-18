
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler15 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
type b is Array (Integer range <>) of a_PTR;
type b_PTR is access b;

  tab2 : a_PTR;
  tab : b_PTR;
  r : Integer;
  q : Integer;
  n : Integer;
begin
  n := 10;
  -- normalement on doit mettre 20 mais là on se tape un overflow 
  
  n := n + 1;
  tab := new b (0..n - 1);
  for i in integer range 0..n - 1 loop
    tab2 := new a (0..n - 1);
    for j in integer range 0..n - 1 loop
      tab2(j) := 0;
    end loop;
    tab(i) := tab2;
  end loop;
  for l in integer range 0..n - 1 loop
    tab(n - 1)(l) := 1;
    tab(l)(n - 1) := 1;
  end loop;
  for o in integer range 2..n loop
    r := n - o;
    for p in integer range 2..n loop
      q := n - p;
      tab(r)(q) := tab(r + 1)(q) + tab(r)(q + 1);
    end loop;
  end loop;
  for m in integer range 0..n - 1 loop
    for k in integer range 0..n - 1 loop
      PInt(tab(m)(k));
      PString(new char_array'( To_C(" ")));
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  PInt(tab(0)(0));
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

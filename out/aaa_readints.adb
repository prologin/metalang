
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure aaa_readints is


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

type e is Array (Integer range <>) of Integer;
type e_PTR is access e;
type f is Array (Integer range <>) of e_PTR;
type f_PTR is access f;

  tab2 : f_PTR;
  tab1 : e_PTR;
  len : Integer;
  c : e_PTR;
begin
  Get(len);
  SkipSpaces;
  PInt(len);
  PString(new char_array'( To_C("=len" & Character'Val(10))));
  tab1 := new e (0..len - 1);
  for a in integer range 0..len - 1 loop
    Get(tab1(a));
    SkipSpaces;
  end loop;
  for i in integer range 0..len - 1 loop
    PInt(i);
    PString(new char_array'( To_C("=>")));
    PInt(tab1(i));
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
  Get(len);
  SkipSpaces;
  tab2 := new f (0..len - 2);
  for b in integer range 0..len - 2 loop
    c := new e (0..len - 1);
    for d in integer range 0..len - 1 loop
      Get(c(d));
      SkipSpaces;
    end loop;
    tab2(b) := c;
  end loop;
  for i in integer range 0..len - 2 loop
    for j in integer range 0..len - 1 loop
      PInt(tab2(i)(j));
      PString(new char_array'( To_C(" ")));
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

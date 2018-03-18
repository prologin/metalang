
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure longest_increasing_subsequence is


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
type f is Array (Integer range <>) of Integer;
type f_PTR is access f;
function dichofind(len : in Integer; tab : in f_PTR; tofind : in Integer; a : in Integer; b : in Integer) return Integer is
  c : Integer;
begin
  if a >= b - 1
  then
    return a;
  else
    c := (a + b) / 2;
    if tab(c) < tofind
    then
      return dichofind(len, tab, tofind, c, b);
    else
      return dichofind(len, tab, tofind, a, c);
    end if;
  end if;
end;
function process(len : in Integer; tab : in f_PTR) return Integer is
  size : f_PTR;
  k : Integer;
begin
  size := new f (0..len - 1);
  for j in integer range 0..len - 1 loop
    if j = 0
    then
      size(j) := 0;
    else
      size(j) := len * 2;
    end if;
  end loop;
  for i in integer range 0..len - 1 loop
    k := dichofind(len, size, tab(i), 0, len - 1);
    if size(k + 1) > tab(i)
    then
      size(k + 1) := tab(i);
    end if;
  end loop;
  for l in integer range 0..len - 1 loop
    PInt(size(l));
    PString(new char_array'( To_C(" ")));
  end loop;
  for m in integer range 0..len - 1 loop
    k := len - 1 - m;
    if size(k) /= len * 2
    then
      return k;
    end if;
  end loop;
  return 0;
end;

  n : Integer;
  len : Integer;
  d : f_PTR;
begin
  Get(n);
  SkipSpaces;
  for i in integer range 1..n loop
    Get(len);
    SkipSpaces;
    d := new f (0..len - 1);
    for e in integer range 0..len - 1 loop
      Get(d(e));
      SkipSpaces;
    end loop;
    PInt(process(len, d));
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

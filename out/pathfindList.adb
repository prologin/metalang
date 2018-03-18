
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure pathfindList is


type stringptr is access all char_array;
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
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function pathfind_aux(cache : in a_PTR; tab : in a_PTR; len : in Integer; pos : in Integer) return Integer is
  posval : Integer;
  out0 : Integer;
  oneval : Integer;
begin
  if pos >= len - 1
  then
    return 0;
  else
    if cache(pos) /= (-1)
    then
      return cache(pos);
    else
      cache(pos) := len * 2;
      posval := pathfind_aux(cache, tab, len, tab(pos));
      oneval := pathfind_aux(cache, tab, len, pos + 1);
      out0 := 0;
      if posval < oneval
      then
        out0 := 1 + posval;
      else
        out0 := 1 + oneval;
      end if;
      cache(pos) := out0;
      return out0;
    end if;
  end if;
end;
function pathfind(tab : in a_PTR; len : in Integer) return Integer is
  cache : a_PTR;
begin
  cache := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    cache(i) := (-1);
  end loop;
  return pathfind_aux(cache, tab, len, 0);
end;

  tmp : Integer;
  tab : a_PTR;
  result : Integer;
  len : Integer;
begin
  len := 0;
  Get(len);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := 0;
    Get(tmp);
    SkipSpaces;
    tab(i) := tmp;
  end loop;
  result := pathfind(tab, len);
  PInt(result);
end;

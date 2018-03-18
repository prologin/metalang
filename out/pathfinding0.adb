
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure pathfinding0 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PChar(c : in Character) is
begin
  Character'Write (Text_Streams.Stream (Current_Output), c);
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
function min2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a < b
  then
    return a;
  else
    return b;
  end if;
end;
type k is Array (Integer range <>) of Integer;
type k_PTR is access k;
type l is Array (Integer range <>) of k_PTR;
type l_PTR is access l;
type m is Array (Integer range <>) of Character;
type m_PTR is access m;
type o is Array (Integer range <>) of m_PTR;
type o_PTR is access o;
function pathfind_aux(cache : in l_PTR; tab : in o_PTR; x : in Integer; y : in Integer; posX : in Integer; posY : in Integer) return Integer is
  val4 : Integer;
  val3 : Integer;
  val2 : Integer;
  val1 : Integer;
  out0 : Integer;
begin
  if posX = x - 1 and then posY = y - 1
  then
    return 0;
  else
    if ((posX < 0 or else posY < 0) or else posX >= x) or else posY >= y
    then
      return x * y * 10;
    else
      if tab(posY)(posX) = '#'
      then
        return x * y * 10;
      else
        if cache(posY)(posX) /= (-1)
        then
          return cache(posY)(posX);
        else
          cache(posY)(posX) := x * y * 10;
          val1 := pathfind_aux(cache, tab, x, y, posX + 1, posY);
          val2 := pathfind_aux(cache, tab, x, y, posX - 1, posY);
          val3 := pathfind_aux(cache, tab, x, y, posX, posY - 1);
          val4 := pathfind_aux(cache, tab, x, y, posX, posY + 1);
          out0 := 1 + min2_0(min2_0(min2_0(val1, val2), val3), val4);
          cache(posY)(posX) := out0;
          return out0;
        end if;
      end if;
    end if;
  end if;
end;
function pathfind(tab : in o_PTR; x : in Integer; y : in Integer) return Integer is
  tmp : k_PTR;
  cache : l_PTR;
begin
  cache := new l (0..y - 1);
  for i in integer range 0..y - 1 loop
    tmp := new k (0..x - 1);
    for j in integer range 0..x - 1 loop
      PChar(tab(i)(j));
      tmp(j) := (-1);
    end loop;
    PString(new char_array'( To_C("" & Character'Val(10))));
    cache(i) := tmp;
  end loop;
  return pathfind_aux(cache, tab, x, y, 0, 0);
end;

  y : Integer;
  x : Integer;
  tab : o_PTR;
  result : Integer;
  g : m_PTR;
  e : o_PTR;
begin
  Get(x);
  SkipSpaces;
  Get(y);
  SkipSpaces;
  PInt(x);
  PString(new char_array'( To_C(" ")));
  PInt(y);
  PString(new char_array'( To_C("" & Character'Val(10))));
  e := new o (0..y - 1);
  for f in integer range 0..y - 1 loop
    g := new m (0..x - 1);
    for h in integer range 0..x - 1 loop
      Get(g(h));
    end loop;
    SkipSpaces;
    e(f) := g;
  end loop;
  tab := e;
  result := pathfind(tab, x, y);
  PInt(result);
end;


with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure cambriolage is


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
function max2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a > b
  then
    return a;
  else
    return b;
  end if;
end;
type c is Array (Integer range <>) of Integer;
type c_PTR is access c;
type d is Array (Integer range <>) of c_PTR;
type d_PTR is access d;
function nbPassePartout(n : in Integer; passepartout : in d_PTR; m : in Integer; serrures : in d_PTR) return Integer is
  pp : c_PTR;
  max_recent_pp : Integer;
  max_recent : Integer;
  max_ancient_pp : Integer;
  max_ancient : Integer;
begin
  max_ancient := 0;
  max_recent := 0;
  for i in integer range 0..m - 1 loop
    if serrures(i)(0) = (-1) and then serrures(i)(1) > max_ancient
    then
      max_ancient := serrures(i)(1);
    end if;
    if serrures(i)(0) = 1 and then serrures(i)(1) > max_recent
    then
      max_recent := serrures(i)(1);
    end if;
  end loop;
  max_ancient_pp := 0;
  max_recent_pp := 0;
  for i in integer range 0..n - 1 loop
    pp := passepartout(i);
    if pp(0) >= max_ancient and then pp(1) >= max_recent
    then
      return 1;
    end if;
    max_ancient_pp := max2_0(max_ancient_pp, pp(0));
    max_recent_pp := max2_0(max_recent_pp, pp(1));
  end loop;
  if max_ancient_pp >= max_ancient and then max_recent_pp >= max_recent
  then
    return 2;
  else
    return 0;
  end if;
end;

  serrures : d_PTR;
  passepartout : d_PTR;
  out_0 : Integer;
  out1 : c_PTR;
  out01 : Integer;
  out0 : c_PTR;
  n : Integer;
  m : Integer;
begin
  Get(n);
  SkipSpaces;
  passepartout := new d (0..n - 1);
  for i in integer range 0..n - 1 loop
    out0 := new c (0..1);
    for j in integer range 0..1 loop
      Get(out01);
      SkipSpaces;
      out0(j) := out01;
    end loop;
    passepartout(i) := out0;
  end loop;
  Get(m);
  SkipSpaces;
  serrures := new d (0..m - 1);
  for k in integer range 0..m - 1 loop
    out1 := new c (0..1);
    for l in integer range 0..1 loop
      Get(out_0);
      SkipSpaces;
      out1(l) := out_0;
    end loop;
    serrures(k) := out1;
  end loop;
  PInt(nbPassePartout(n, passepartout, m, serrures));
end;

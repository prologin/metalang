
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure sort is


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
type a is Array (Integer range <>) of Integer;
type a_PTR is access a;
function copytab(tab : in a_PTR; len : in Integer) return a_PTR is
  o : a_PTR;
begin
  o := new a (0..len - 1);
  for i in integer range 0..len - 1 loop
    o(i) := tab(i);
  end loop;
  return o;
end;
procedure bubblesort(tab : in a_PTR; len : in Integer) is
  tmp : Integer;
begin
  for i in integer range 0..len - 1 loop
    for j in integer range i + 1..len - 1 loop
      if tab(i) > tab(j)
      then
        tmp := tab(i);
        tab(i) := tab(j);
        tab(j) := tmp;
      end if;
    end loop;
  end loop;
end;
procedure qsort0(tab : in a_PTR; len : in Integer; b : in Integer; c : in Integer) is
  tmp : Integer;
  j0 : Integer;
  j : Integer;
  i0 : Integer;
  i : Integer;
begin
  i := b;
  j := c;
  if i < j
  then
    i0 := i;
    j0 := j;
    -- pivot : tab[0] 
    
    while i /= j loop
      if tab(i) > tab(j)
      then
        if i = j - 1
        then
          -- on inverse simplement
          
          tmp := tab(i);
          tab(i) := tab(j);
          tab(j) := tmp;
          i := i + 1;
        else
          -- on place tab[i+1] à la place de tab[j], tab[j] à la place de tab[i] et tab[i] à la place de tab[i+1] 
          
          tmp := tab(i);
          tab(i) := tab(j);
          tab(j) := tab(i + 1);
          tab(i + 1) := tmp;
          i := i + 1;
        end if;
      else
        j := j - 1;
      end if;
    end loop;
    qsort0(tab, len, i0, i - 1);
    qsort0(tab, len, i + 1, j0);
  end if;
end;

  tmp : Integer;
  tab3 : a_PTR;
  tab2 : a_PTR;
  tab : a_PTR;
  len : Integer;
begin
  len := 2;
  Get(len);
  SkipSpaces;
  tab := new a (0..len - 1);
  for i_0 in integer range 0..len - 1 loop
    tmp := 0;
    Get(tmp);
    SkipSpaces;
    tab(i_0) := tmp;
  end loop;
  tab2 := copytab(tab, len);
  bubblesort(tab2, len);
  for i in integer range 0..len - 1 loop
    PInt(tab2(i));
    PString(new char_array'( To_C(" ")));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  tab3 := copytab(tab, len);
  qsort0(tab3, len, 0, len - 1);
  for i in integer range 0..len - 1 loop
    PInt(tab3(i));
    PString(new char_array'( To_C(" ")));
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

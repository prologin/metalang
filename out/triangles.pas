program triangles;


var global_char : char;
var global_has_char : boolean;

procedure skip_char();
begin
   global_has_char := true;
   read(global_char);
end;

procedure skip();
var
   n : char;
   t : char;
   s : char;
begin
   n := #13;
   t := #10;
   s := #32;
   if not( global_has_char ) then
      skip_char();
   while (global_char = s) or (global_char = n) or (global_char = t) do
   begin
      skip_char();
   end;
end;

function read_char_aux() : char;
begin
   if global_has_char then
      read_char_aux := global_char
   else
   begin
      skip_char();
      read_char_aux := global_char;
   end
end;

function read_char() : char;
var
   c : char;
begin
   c := read_char_aux();
   skip_char();
   read_char := c;
end;



function read_int() : integer;
var
   c    : char;
   i    : integer;
   sign :  integer;
begin
   i := 0;
   c := read_char_aux();
   if c = '-' then begin
      skip_char();
      sign := -1;
   end
   else
      sign := 1;

   repeat
      c := read_char_aux();
      if (ord(c) <=57) and (ord(c) >= 48) then
      begin
         i := i * 10 + ord(c) - 48;
         skip_char();
      end
      else
         exit(i * sign);
   until false;
end;


{ Ce code a été généré par metalang
   Il gère les entrées sorties pour un programme dynamique classique
   dans les épreuves de prologin
}
type q = array of array of integer;
function find0(len : integer; tab : q; cache : q; x : integer; y : integer) : integer;
var
  out0 : integer;
  out1 : integer;
  result : integer;
begin
  {
	Cette fonction est récursive
	}
  if y = (len - 1) then
    begin
      exit(tab[y][x]);
    end
  else if x > y then
    begin
      exit(100000);
    end
  else if cache[y][x] <> 0
  then
    begin
      exit(cache[y][x]);
    end;;;
  result := 0;
  out0 := find0(len, tab, cache, x, y + 1);
  out1 := find0(len, tab, cache, x + 1, y + 1);
  if out0 < out1
  then
    begin
      result := out0 + tab[y][x];
    end
  else
    begin
      result := out1 + tab[y][x];
    end;
  cache[y][y] := result;
  exit(result);
end;

type r = array of integer;
function find(len : integer; tab : q) : integer;
var
  h : integer;
  i : integer;
  j : integer;
  tab2 : q;
  tab3 : r;
begin
  SetLength(tab2, len);
  for i := 0 to  len - 1 do
  begin
    h := i + 1;
    SetLength(tab3, h);
    for j := 0 to  h - 1 do
    begin
      tab3[j] := 0;
    end;
    tab2[i] := tab3;
  end;
  exit(find0(len, tab, tab2, 0, 0));
end;


var
  i : integer;
  j : integer;
  k : integer;
  l : integer;
  len : integer;
  m : integer;
  n : r;
  o : integer;
  tab : q;
  tab2 : r;
  tmp : integer;
begin
  len := 0;
  len := read_int();
  skip();
  SetLength(tab, len);
  for i := 0 to  len - 1 do
  begin
    k := i + 1;
    SetLength(tab2, k);
    for j := 0 to  k - 1 do
    begin
      tmp := 0;
      tmp := read_int();
      skip();
      tab2[j] := tmp;
    end;
    tab[i] := tab2;
  end;
  l := find(len, tab);
  write(l);
  for m := 0 to  (length(tab)) - 1 do
  begin
    n := tab[m];
    for o := 0 to  (length(n)) - 1 do
    begin
      write(n[o]);
    end;
  end;
end.


program pathfinding;

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
function read_char_() : char;
var
   c : char;
begin
   c := read_char_aux();
   skip_char();
   read_char_ := c;
end;
function read_int_() : Longint;
var
   c    : char;
   i    : Longint;
   sign :  Longint;
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

function min2_(a : Longint; b : Longint) : Longint;
begin
  if a < b
  then
    begin
      exit(a);
    end
  else
    begin
      exit(b);
    end;
end;

type r = array of array of Longint;
type s = array of array of char;
function pathfind_aux(cache : r; tab : s; x : Longint; y : Longint; posX : Longint; posY : Longint) : Longint;
var
  m : Longint;
  n : Longint;
  o : Longint;
  out_ : Longint;
  p : Longint;
  q : Longint;
  val1 : Longint;
  val2 : Longint;
  val3 : Longint;
  val4 : Longint;
begin
  if (posX = (x - 1)) and (posY = (y - 1)) then
    begin
      exit(0);
    end
  else if (posX < 0) or (posY < 0) or (posX >= x) or (posY >= y) then
    begin
      exit(x * y * 10);
    end
  else if tab[posY][posX] = #35 then
    begin
      exit(x * y * 10);
    end
  else if cache[posY][posX] <> -1
  then
    begin
      exit(cache[posY][posX]);
    end
  else
    begin
      cache[posY][posX] := x * y * 10;
      val1 := pathfind_aux(cache, tab, x, y, posX + 1, posY);
      val2 := pathfind_aux(cache, tab, x, y, posX - 1, posY);
      val3 := pathfind_aux(cache, tab, x, y, posX, posY - 1);
      val4 := pathfind_aux(cache, tab, x, y, posX, posY + 1);
      n := min2_(val1, val2);
      o := min2_(n, val3);
      p := min2_(o, val4);
      q := p;
      m := q;
      out_ := 1 + m;
      cache[posY][posX] := out_;
      exit(out_);
    end;;;;
end;

type t = array of Longint;
function pathfind(tab : s; x : Longint; y : Longint) : Longint;
var
  cache : r;
  i : Longint;
  j : Longint;
  tmp : t;
begin
  SetLength(cache, y);
  for i := 0 to  y - 1 do
  begin
    SetLength(tmp, x);
    for j := 0 to  x - 1 do
    begin
      tmp[j] := -1;
    end;
    cache[i] := tmp;
  end;
  exit(pathfind_aux(cache, tab, x, y, 0, 0));
end;


var
  i : Longint;
  j : Longint;
  result : Longint;
  tab : s;
  tab2 : array of char;
  tmp : char;
  x : Longint;
  y : Longint;
begin
  x := 0;
  y := 0;
  x := read_int_();
  skip();
  y := read_int_();
  skip();
  SetLength(tab, y);
  for i := 0 to  y - 1 do
  begin
    SetLength(tab2, x);
    for j := 0 to  x - 1 do
    begin
      tmp := #0;
      tmp := read_char_();
      tab2[j] := tmp;
    end;
    skip();
    tab[i] := tab2;
  end;
  result := pathfind(tab, x, y);
  Write(result);
end.



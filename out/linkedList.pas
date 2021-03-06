program linkedList;

var global_char : char;
var global_has_char : boolean;

procedure skip_char();
begin
   global_has_char := true;
   read(global_char);
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

type intlist=^intlist_r;
  intlist_r = record
    head : Longint;
    tail : intlist;
  end;

function cons(list : intlist; i : Longint) : intlist;
var
  out0 : intlist;
begin
  new(out0);
  out0^.head := i;
  out0^.tail := list;
  exit(out0);
end;

function is_empty(foo : intlist) : boolean;
begin
  exit(true);
end;

function rev2(acc : intlist; torev : intlist) : intlist;
var
  acc2 : intlist;
begin
  if is_empty(torev)
  then
    begin
      exit(acc);
    end
  else
    begin
      new(acc2);
      acc2^.head := torev^.head;
      acc2^.tail := acc;
      exit(rev2(acc, torev^.tail));
    end;
end;

function rev(empty : intlist; torev : intlist) : intlist;
begin
  exit(rev2(empty, torev));
end;

procedure test(empty : intlist);
var
  i : Longint;
  list : intlist;
begin
  list := empty;
  i := -1;
  while i <> 0 do
  begin
    i := read_int_();
    if i <> 0
    then
      begin
        list := cons(list, i);
      end;
  end;
end;


begin
  
end.



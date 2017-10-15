program abstest;

function abs_(n : Longint) : Longint;
begin
  if n > 0
  then
    begin
      exit(n);
    end
  else
    begin
      exit(-n);
    end;
end;


begin
  Write(abs_(5 + 2) * 3);
  Write(3 * abs_(5 + 2));
end.



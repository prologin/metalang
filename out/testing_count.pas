program testing_count;


type a = array of Longint;

var
  i : Longint;
  tab : a;
begin
  SetLength(tab, 40);
  for i := 0 to  39 do
  begin
    tab[i] := i * i;
  end;
  Write(Length(tab));
  Write(''#10'');
end.



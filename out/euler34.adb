
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler34 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

type h is Array (Integer range <>) of Integer;
type h_PTR is access h;

  sum : Integer;
  out0 : Integer;
  num : Integer;
  f : h_PTR;
begin
  f := new h (0..9);
  for j in integer range 0..9 loop
    f(j) := 1;
  end loop;
  for i in integer range 1..9 loop
    f(i) := f(i) * i * f(i - 1);
    PInt(f(i));
    PString(new char_array'( To_C(" ")));
  end loop;
  out0 := 0;
  PString(new char_array'( To_C("" & Character'Val(10))));
  for a in integer range 0..9 loop
    for b in integer range 0..9 loop
      for c in integer range 0..9 loop
        for d in integer range 0..9 loop
          for e in integer range 0..9 loop
            for g in integer range 0..9 loop
              sum := f(a) + f(b) + f(c) + f(d) + f(e) + f(g);
              num := ((((a * 10 + b) * 10 + c) * 10 + d) * 10 + e) * 10 + g;
              if a = 0
              then
                sum := sum - 1;
                if b = 0
                then
                  sum := sum - 1;
                  if c = 0
                  then
                    sum := sum - 1;
                    if d = 0
                    then
                      sum := sum - 1;
                    end if;
                  end if;
                end if;
              end if;
              if (sum = num and then sum /= 1) and then sum /= 2
              then
                out0 := out0 + num;
                PInt(num);
                PString(new char_array'( To_C(" ")));
              end if;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
  PInt(out0);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

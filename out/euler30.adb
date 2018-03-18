
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler30 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

type g is Array (Integer range <>) of Integer;
type g_PTR is access g;

  sum : Integer;
  s : Integer;
  r : Integer;
  p : g_PTR;
begin
  --
  --a + b * 10 + c * 100 + d * 1000 + e * 10 000 =
  --  a ^ 5 +
  --  b ^ 5 +
  --  c ^ 5 +
  --  d ^ 5 +
  --  e ^ 5
  --
  
  p := new g (0..9);
  for i in integer range 0..9 loop
    p(i) := i * i * i * i * i;
  end loop;
  sum := 0;
  for a in integer range 0..9 loop
    for b in integer range 0..9 loop
      for c in integer range 0..9 loop
        for d in integer range 0..9 loop
          for e in integer range 0..9 loop
            for f in integer range 0..9 loop
              s := p(a) + p(b) + p(c) + p(d) + p(e) + p(f);
              r := a + b * 10 + c * 100 + d * 1000 + e * 10000 + f * 100000;
              if s = r and then r /= 1
              then
                PInt(f);
                PInt(e);
                PInt(d);
                PInt(c);
                PInt(b);
                PInt(a);
                PString(new char_array'( To_C(" ")));
                PInt(r);
                PString(new char_array'( To_C("" & Character'Val(10))));
                sum := sum + r;
              end if;
            end loop;
          end loop;
        end loop;
      end loop;
    end loop;
  end loop;
  PInt(sum);
end;


with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure euler43 is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PInt(i : in Integer) is
begin
  String'Write (Text_Streams.Stream (Current_Output), Trim(Integer'Image(i), Left));
end;

type a is Array (Integer range <>) of Boolean;
type a_PTR is access a;

  d6 : Integer;
  d4 : Integer;
  allowed : a_PTR;
begin
  --
  --The number, 1406357289, is a 0 to 9 pandigital number because it is made up of each of the digits 0 to 9 in some order, but it also has a rather interesting sub-string divisibility property.
  --
  --Let d1 be the 1st digit, d2 be the 2nd digit, and so on. In this way, we note the following:
  --
  --d2d3d4=406 is divisible by 2
  --d3d4d5=063 is divisible by 3
  --d4d5d6=635 is divisible by 5
  --d5d6d7=357 is divisible by 7
  --d6d7d8=572 is divisible by 11
  --d7d8d9=728 is divisible by 13
  --d8d9d10=289 is divisible by 17
  --Find the sum of all 0 to 9 pandigital numbers with this property.
  --
  --d4 % 2 == 0
  --(d3 + d4 + d5) % 3 == 0
  --d6 = 5 ou d6 = 0
  --(d5 * 100 + d6 * 10 + d7  ) % 7 == 0
  --(d6 * 100 + d7 * 10 + d8  ) % 11 == 0
  --(d7 * 100 + d8 * 10 + d9  ) % 13 == 0
  --(d8 * 100 + d9 * 10 + d10 ) % 17 == 0
  --
  --
  --d4 % 2 == 0
  --d6 = 5 ou d6 = 0
  --
  --(d3 + d4 + d5) % 3 == 0
  --(d5 * 2 + d6 * 3 + d7) % 7 == 0
  --
  
  allowed := new a (0..9);
  for i in integer range 0..9 loop
    allowed(i) := TRUE;
  end loop;
  for i6 in integer range 0..1 loop
    d6 := i6 * 5;
    if allowed(d6)
    then
      allowed(d6) := FALSE;
      for d7 in integer range 0..9 loop
        if allowed(d7)
        then
          allowed(d7) := FALSE;
          for d8 in integer range 0..9 loop
            if allowed(d8)
            then
              allowed(d8) := FALSE;
              for d9 in integer range 0..9 loop
                if allowed(d9)
                then
                  allowed(d9) := FALSE;
                  for d10 in integer range 1..9 loop
                    if
                    ((allowed(d10) and then (d6 * 100 + d7 * 10 + d8) rem 11 = 0) and then (d7 * 100 + d8 * 10 + d9) rem 13 = 0) and then (d8 * 100 + d9 * 10 + d10) rem 17 = 0
                    then
                      allowed(d10) := FALSE;
                      for d5 in integer range 0..9 loop
                        if allowed(d5)
                        then
                          allowed(d5) := FALSE;
                          if (d5 * 100 + d6 * 10 + d7) rem 7 = 0
                          then
                            for i4 in integer range 0..4 loop
                              d4 := i4 * 2;
                              if allowed(d4)
                              then
                                allowed(d4) := FALSE;
                                for d3 in integer range 0..9 loop
                                  if allowed(d3)
                                  then
                                    allowed(d3) := FALSE;
                                    if (d3 + d4 + d5) rem 3 = 0
                                    then
                                      for d2 in integer range 0..9 loop
                                        if allowed(d2)
                                        then
                                          allowed(d2) := FALSE;
                                          for d1 in integer range 0..9 loop
                                            if allowed(d1)
                                            then
                                              allowed(d1) := FALSE;
                                              PInt(d1);
                                              PInt(d2);
                                              PInt(d3);
                                              PInt(d4);
                                              PInt(d5);
                                              PInt(d6);
                                              PInt(d7);
                                              PInt(d8);
                                              PInt(d9);
                                              PInt(d10);
                                              PString(new char_array'( To_C(" + ")));
                                              allowed(d1) := TRUE;
                                            end if;
                                          end loop;
                                          allowed(d2) := TRUE;
                                        end if;
                                      end loop;
                                    end if;
                                    allowed(d3) := TRUE;
                                  end if;
                                end loop;
                                allowed(d4) := TRUE;
                              end if;
                            end loop;
                          end if;
                          allowed(d5) := TRUE;
                        end if;
                      end loop;
                      allowed(d10) := TRUE;
                    end if;
                  end loop;
                  allowed(d9) := TRUE;
                end if;
              end loop;
              allowed(d8) := TRUE;
            end if;
          end loop;
          allowed(d7) := TRUE;
        end if;
      end loop;
      allowed(d6) := TRUE;
    end if;
  end loop;
  PInt(0);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

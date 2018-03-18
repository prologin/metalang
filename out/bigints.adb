
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure bigints is


type stringptr is access all char_array;
procedure PString(s : stringptr) is
begin
  String'Write (Text_Streams.Stream (Current_Output), To_Ada(s.all));
end;
procedure PChar(c : in Character) is
begin
  Character'Write (Text_Streams.Stream (Current_Output), c);
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
function max2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a > b
  then
    return a;
  else
    return b;
  end if;
end;
function min2_0(a : in Integer; b : in Integer) return Integer is
begin
  if a < b
  then
    return a;
  else
    return b;
  end if;
end;
type bigint;
type bigint_PTR is access bigint;
type r is Array (Integer range <>) of Integer;
type r_PTR is access r;
type bigint is record
  bigint_sign : Boolean;
  bigint_len : Integer;
  bigint_chiffres : r_PTR;
end record;
function read_bigint(len : in Integer) return bigint_PTR is
  tmp : Integer;
  e : bigint_PTR;
  chiffres : r_PTR;
  c : Character;
begin
  chiffres := new r (0..len - 1);
  for j in integer range 0..len - 1 loop
    Get(c);
    chiffres(j) := Character'Pos(c);
  end loop;
  for i in integer range 0..(len - 1) / 2 loop
    tmp := chiffres(i);
    chiffres(i) := chiffres(len - 1 - i);
    chiffres(len - 1 - i) := tmp;
  end loop;
  e := new bigint;
  e.bigint_sign := TRUE;
  e.bigint_len := len;
  e.bigint_chiffres := chiffres;
  return e;
end;
procedure print_bigint(a : in bigint_PTR) is
begin
  if not a.bigint_sign
  then
    PChar('-');
  end if;
  for i in integer range 0..a.bigint_len - 1 loop
    PInt(a.bigint_chiffres(a.bigint_len - 1 - i));
  end loop;
end;
function bigint_eq(a : in bigint_PTR; b : in bigint_PTR) return Boolean is
begin
  -- Renvoie vrai si a = b 
  
  if a.bigint_sign /= b.bigint_sign
  then
    return FALSE;
  else
    if a.bigint_len /= b.bigint_len
    then
      return FALSE;
    else
      for i in integer range 0..a.bigint_len - 1 loop
        if a.bigint_chiffres(i) /= b.bigint_chiffres(i)
        then
          return FALSE;
        end if;
      end loop;
      return TRUE;
    end if;
  end if;
end;
function bigint_gt(a : in bigint_PTR; b : in bigint_PTR) return Boolean is
  j : Integer;
begin
  -- Renvoie vrai si a > b 
  
  if a.bigint_sign and then not b.bigint_sign
  then
    return TRUE;
  else
    if not a.bigint_sign and then b.bigint_sign
    then
      return FALSE;
    else
      if a.bigint_len > b.bigint_len
      then
        return a.bigint_sign;
      else
        if a.bigint_len < b.bigint_len
        then
          return not a.bigint_sign;
        else
          for i in integer range 0..a.bigint_len - 1 loop
            j := a.bigint_len - 1 - i;
            if a.bigint_chiffres(j) > b.bigint_chiffres(j)
            then
              return a.bigint_sign;
            else
              if a.bigint_chiffres(j) < b.bigint_chiffres(j)
              then
                return not a.bigint_sign;
              end if;
            end if;
          end loop;
        end if;
      end if;
      return TRUE;
    end if;
  end if;
end;
function bigint_lt(a : in bigint_PTR; b : in bigint_PTR) return Boolean is
begin
  return not bigint_gt(a, b);
end;
function add_bigint_positif(a : in bigint_PTR; b : in bigint_PTR) return bigint_PTR is
  tmp : Integer;
  retenue : Integer;
  len : Integer;
  f : bigint_PTR;
  chiffres : r_PTR;
begin
  -- Une addition ou on en a rien a faire des signes 
  
  len := max2_0(a.bigint_len, b.bigint_len) + 1;
  retenue := 0;
  chiffres := new r (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := retenue;
    if i < a.bigint_len
    then
      tmp := tmp + a.bigint_chiffres(i);
    end if;
    if i < b.bigint_len
    then
      tmp := tmp + b.bigint_chiffres(i);
    end if;
    retenue := tmp / 10;
    chiffres(i) := tmp rem 10;
  end loop;
  while len > 0 and then chiffres(len - 1) = 0 loop
    len := len - 1;
  end loop;
  f := new bigint;
  f.bigint_sign := TRUE;
  f.bigint_len := len;
  f.bigint_chiffres := chiffres;
  return f;
end;
function sub_bigint_positif(a : in bigint_PTR; b : in bigint_PTR) return bigint_PTR is
  tmp : Integer;
  retenue : Integer;
  len : Integer;
  g : bigint_PTR;
  chiffres : r_PTR;
begin
  -- Une soustraction ou on en a rien a faire des signes
  --Pré-requis : a > b
  --
  
  len := a.bigint_len;
  retenue := 0;
  chiffres := new r (0..len - 1);
  for i in integer range 0..len - 1 loop
    tmp := retenue + a.bigint_chiffres(i);
    if i < b.bigint_len
    then
      tmp := tmp - b.bigint_chiffres(i);
    end if;
    if tmp < 0
    then
      tmp := tmp + 10;
      retenue := (-1);
    else
      retenue := 0;
    end if;
    chiffres(i) := tmp;
  end loop;
  while len > 0 and then chiffres(len - 1) = 0 loop
    len := len - 1;
  end loop;
  g := new bigint;
  g.bigint_sign := TRUE;
  g.bigint_len := len;
  g.bigint_chiffres := chiffres;
  return g;
end;
function neg_bigint(a : in bigint_PTR) return bigint_PTR is
  h : bigint_PTR;
begin
  h := new bigint;
  h.bigint_sign := not a.bigint_sign;
  h.bigint_len := a.bigint_len;
  h.bigint_chiffres := a.bigint_chiffres;
  return h;
end;
function add_bigint(a : in bigint_PTR; b : in bigint_PTR) return bigint_PTR is
begin
  if a.bigint_sign = b.bigint_sign
  then
    if a.bigint_sign
    then
      return add_bigint_positif(a, b);
    else
      return neg_bigint(add_bigint_positif(a, b));
    end if;
  else
    if a.bigint_sign
    then
      -- a positif, b negatif 
      
      if bigint_gt(a, neg_bigint(b))
      then
        return sub_bigint_positif(a, b);
      else
        return neg_bigint(sub_bigint_positif(b, a));
      end if;
    else
      -- a negatif, b positif 
      
      if bigint_gt(neg_bigint(a), b)
      then
        return neg_bigint(sub_bigint_positif(a, b));
      else
        return sub_bigint_positif(b, a);
      end if;
    end if;
  end if;
end;
function sub_bigint(a : in bigint_PTR; b : in bigint_PTR) return bigint_PTR is
begin
  return add_bigint(a, neg_bigint(b));
end;
function mul_bigint_cp(a : in bigint_PTR; b : in bigint_PTR) return bigint_PTR is
  retenue : Integer;
  m : bigint_PTR;
  len : Integer;
  chiffres : r_PTR;
begin
  -- Cet algorithm est quadratique.
  --C'est le même que celui qu'on enseigne aux enfants en CP.
  --D'ou le nom de la fonction. 
  
  len := a.bigint_len + b.bigint_len + 1;
  chiffres := new r (0..len - 1);
  for k in integer range 0..len - 1 loop
    chiffres(k) := 0;
  end loop;
  for i in integer range 0..a.bigint_len - 1 loop
    retenue := 0;
    for j in integer range 0..b.bigint_len - 1 loop
      chiffres(i + j) := chiffres(i + j) + retenue + b.bigint_chiffres(j) * a.bigint_chiffres(i);
      retenue := chiffres(i + j) / 10;
      chiffres(i + j) := chiffres(i + j) rem 10;
    end loop;
    chiffres(i + b.bigint_len) := chiffres(i + b.bigint_len) + retenue;
  end loop;
  chiffres(a.bigint_len + b.bigint_len) := chiffres(a.bigint_len + b.bigint_len - 1) / 10;
  chiffres(a.bigint_len + b.bigint_len - 1) := chiffres(a.bigint_len + b.bigint_len - 1) rem 10;
  for l in integer range 0..2 loop
    if len /= 0 and then chiffres(len - 1) = 0
    then
      len := len - 1;
    end if;
  end loop;
  m := new bigint;
  m.bigint_sign := a.bigint_sign = b.bigint_sign;
  m.bigint_len := len;
  m.bigint_chiffres := chiffres;
  return m;
end;
function bigint_premiers_chiffres(a : in bigint_PTR; i : in Integer) return bigint_PTR is
  o : bigint_PTR;
  len : Integer;
begin
  len := min2_0(i, a.bigint_len);
  while len /= 0 and then a.bigint_chiffres(len - 1) = 0 loop
    len := len - 1;
  end loop;
  o := new bigint;
  o.bigint_sign := a.bigint_sign;
  o.bigint_len := len;
  o.bigint_chiffres := a.bigint_chiffres;
  return o;
end;
function bigint_shift(a : in bigint_PTR; i : in Integer) return bigint_PTR is
  p : bigint_PTR;
  chiffres : r_PTR;
begin
  chiffres := new r (0..a.bigint_len + i - 1);
  for k in integer range 0..a.bigint_len + i - 1 loop
    if k >= i
    then
      chiffres(k) := a.bigint_chiffres(k - i);
    else
      chiffres(k) := 0;
    end if;
  end loop;
  p := new bigint;
  p.bigint_sign := a.bigint_sign;
  p.bigint_len := a.bigint_len + i;
  p.bigint_chiffres := chiffres;
  return p;
end;
function mul_bigint(aa : in bigint_PTR; bb : in bigint_PTR) return bigint_PTR is
  split : Integer;
  d : bigint_PTR;
  cmoinsd : bigint_PTR;
  c : bigint_PTR;
  bd : bigint_PTR;
  b : bigint_PTR;
  amoinsbcmoinsd : bigint_PTR;
  amoinsb : bigint_PTR;
  acdec : bigint_PTR;
  ac : bigint_PTR;
  a : bigint_PTR;
begin
  if aa.bigint_len = 0
  then
    return aa;
  else
    if bb.bigint_len = 0
    then
      return bb;
    else
      if aa.bigint_len < 3 or else bb.bigint_len < 3
      then
        return mul_bigint_cp(aa, bb);
      end if;
    end if;
  end if;
  -- Algorithme de Karatsuba 
  
  split := min2_0(aa.bigint_len, bb.bigint_len) / 2;
  a := bigint_shift(aa, (-split));
  b := bigint_premiers_chiffres(aa, split);
  c := bigint_shift(bb, (-split));
  d := bigint_premiers_chiffres(bb, split);
  amoinsb := sub_bigint(a, b);
  cmoinsd := sub_bigint(c, d);
  ac := mul_bigint(a, c);
  bd := mul_bigint(b, d);
  amoinsbcmoinsd := mul_bigint(amoinsb, cmoinsd);
  acdec := bigint_shift(ac, 2 * split);
  return add_bigint(add_bigint(acdec, bd), bigint_shift(sub_bigint(add_bigint(ac, bd), amoinsbcmoinsd), split));
  -- ac × 102k + (ac + bd – (a – b)(c – d)) × 10k + bd 
  
end;
--
--Division,
--Modulo
--

function log10(s : in Integer) return Integer is
  out0 : Integer;
  a : Integer;
begin
  a := s;
  out0 := 1;
  while a >= 10 loop
    a := a / 10;
    out0 := out0 + 1;
  end loop;
  return out0;
end;
function bigint_of_int(u : in Integer) return bigint_PTR is
  t : r_PTR;
  size : Integer;
  q : bigint_PTR;
  i : Integer;
begin
  i := u;
  size := log10(i);
  if i = 0
  then
    size := 0;
  end if;
  t := new r (0..size - 1);
  for j in integer range 0..size - 1 loop
    t(j) := 0;
  end loop;
  for k in integer range 0..size - 1 loop
    t(k) := i rem 10;
    i := i / 10;
  end loop;
  q := new bigint;
  q.bigint_sign := TRUE;
  q.bigint_len := size;
  q.bigint_chiffres := t;
  return q;
end;
function fact_bigint(v : in bigint_PTR) return bigint_PTR is
  out0 : bigint_PTR;
  one : bigint_PTR;
  a : bigint_PTR;
begin
  a := v;
  one := bigint_of_int(1);
  out0 := one;
  while not bigint_eq(a, one) loop
    out0 := mul_bigint(a, out0);
    a := sub_bigint(a, one);
  end loop;
  return out0;
end;
function sum_chiffres_bigint(a : in bigint_PTR) return Integer is
  out0 : Integer;
begin
  out0 := 0;
  for i in integer range 0..a.bigint_len - 1 loop
    out0 := out0 + a.bigint_chiffres(i);
  end loop;
  return out0;
end;
-- http://projecteuler.net/problem=20 

function euler20 return Integer is
  a : bigint_PTR;
begin
  a := bigint_of_int(15);
  -- normalement c'est 100 
  
  a := fact_bigint(a);
  return sum_chiffres_bigint(a);
end;
function bigint_exp(a : in bigint_PTR; b : in Integer) return bigint_PTR is
begin
  if b = 1
  then
    return a;
  else
    if b rem 2 = 0
    then
      return bigint_exp(mul_bigint(a, a), b / 2);
    else
      return mul_bigint(a, bigint_exp(a, b - 1));
    end if;
  end if;
end;
function bigint_exp_10chiffres(w : in bigint_PTR; b : in Integer) return bigint_PTR is
  a : bigint_PTR;
begin
  a := w;
  a := bigint_premiers_chiffres(a, 10);
  if b = 1
  then
    return a;
  else
    if b rem 2 = 0
    then
      return bigint_exp_10chiffres(mul_bigint(a, a), b / 2);
    else
      return mul_bigint(a, bigint_exp_10chiffres(a, b - 1));
    end if;
  end if;
end;
procedure euler48 is
  sum : bigint_PTR;
  ibeib : bigint_PTR;
  ib : bigint_PTR;
begin
  sum := bigint_of_int(0);
  for i in integer range 1..100 loop
    -- 1000 normalement 
    
    ib := bigint_of_int(i);
    ibeib := bigint_exp_10chiffres(ib, i);
    sum := add_bigint(sum, ibeib);
    sum := bigint_premiers_chiffres(sum, 10);
  end loop;
  PString(new char_array'( To_C("euler 48 = ")));
  print_bigint(sum);
  PString(new char_array'( To_C("" & Character'Val(10))));
end;
function euler16 return Integer is
  a : bigint_PTR;
begin
  a := bigint_of_int(2);
  a := bigint_exp(a, 100);
  -- 1000 normalement 
  
  return sum_chiffres_bigint(a);
end;
function euler25 return Integer is
  i : Integer;
  c : bigint_PTR;
  b : bigint_PTR;
  a : bigint_PTR;
begin
  i := 2;
  a := bigint_of_int(1);
  b := bigint_of_int(1);
  while b.bigint_len < 100 loop
    -- 1000 normalement 
    
    c := add_bigint(a, b);
    a := b;
    b := c;
    i := i + 1;
  end loop;
  return i;
end;
type x is Array (Integer range <>) of bigint_PTR;
type x_PTR is access x;
function euler29 return Integer is
  n : Integer;
  min0 : bigint_PTR;
  maxB : Integer;
  maxA : Integer;
  found : Boolean;
  b : r_PTR;
  a_bigint : x_PTR;
  a0_bigint : x_PTR;
begin
  maxA := 5;
  maxB := 5;
  a_bigint := new x (0..maxA);
  for j in integer range 0..maxA loop
    a_bigint(j) := bigint_of_int(j * j);
  end loop;
  a0_bigint := new x (0..maxA);
  for j2 in integer range 0..maxA loop
    a0_bigint(j2) := bigint_of_int(j2);
  end loop;
  b := new r (0..maxA);
  for k in integer range 0..maxA loop
    b(k) := 2;
  end loop;
  n := 0;
  found := TRUE;
  while found loop
    min0 := a0_bigint(0);
    found := FALSE;
    for i in integer range 2..maxA loop
      if b(i) <= maxB
      then
        if found
        then
          if bigint_lt(a_bigint(i), min0)
          then
            min0 := a_bigint(i);
          end if;
        else
          min0 := a_bigint(i);
          found := TRUE;
        end if;
      end if;
    end loop;
    if found
    then
      n := n + 1;
      for l in integer range 2..maxA loop
        if bigint_eq(a_bigint(l), min0) and then b(l) <= maxB
        then
          b(l) := b(l) + 1;
          a_bigint(l) := mul_bigint(a_bigint(l), a0_bigint(l));
        end if;
      end loop;
    end if;
  end loop;
  return n;
end;

  tmp : bigint_PTR;
  sum : bigint_PTR;
  b : bigint_PTR;
  a : bigint_PTR;
begin
  PInt(euler29);
  PString(new char_array'( To_C("" & Character'Val(10))));
  sum := read_bigint(50);
  for i in integer range 2..100 loop
    SkipSpaces;
    tmp := read_bigint(50);
    sum := add_bigint(sum, tmp);
  end loop;
  PString(new char_array'( To_C("euler13 = ")));
  print_bigint(sum);
  PString(new char_array'( To_C("" & Character'Val(10) & "euler25 = ")));
  PInt(euler25);
  PString(new char_array'( To_C("" & Character'Val(10) & "euler16 = ")));
  PInt(euler16);
  PString(new char_array'( To_C("" & Character'Val(10))));
  euler48;
  PString(new char_array'( To_C("euler20 = ")));
  PInt(euler20);
  PString(new char_array'( To_C("" & Character'Val(10))));
  a := bigint_of_int(999999);
  b := bigint_of_int(9951263);
  print_bigint(a);
  PString(new char_array'( To_C(">>1=")));
  print_bigint(bigint_shift(a, (-1)));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(a);
  PString(new char_array'( To_C("*")));
  print_bigint(b);
  PString(new char_array'( To_C("=")));
  print_bigint(mul_bigint(a, b));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(a);
  PString(new char_array'( To_C("*")));
  print_bigint(b);
  PString(new char_array'( To_C("=")));
  print_bigint(mul_bigint_cp(a, b));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(a);
  PString(new char_array'( To_C("+")));
  print_bigint(b);
  PString(new char_array'( To_C("=")));
  print_bigint(add_bigint(a, b));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(b);
  PString(new char_array'( To_C("-")));
  print_bigint(a);
  PString(new char_array'( To_C("=")));
  print_bigint(sub_bigint(b, a));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(a);
  PString(new char_array'( To_C("-")));
  print_bigint(b);
  PString(new char_array'( To_C("=")));
  print_bigint(sub_bigint(a, b));
  PString(new char_array'( To_C("" & Character'Val(10))));
  print_bigint(a);
  PString(new char_array'( To_C(">")));
  print_bigint(b);
  PString(new char_array'( To_C("=")));
  if bigint_gt(a, b)
  then
    PString(new char_array'( To_C("True")));
  else
    PString(new char_array'( To_C("False")));
  end if;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;

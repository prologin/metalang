
with ada.text_io, ada.Integer_text_IO, Ada.Text_IO.Text_Streams, Ada.Strings.Fixed, Interfaces.C;
use ada.text_io, ada.Integer_text_IO, Ada.Strings, Ada.Strings.Fixed, Interfaces.C;

procedure tictactoe is


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
--
--Tictactoe : un tictactoe avec une IA
--

-- La structure de donnée 

type gamestate;
type gamestate_PTR is access gamestate;
type e is Array (Integer range <>) of Integer;
type e_PTR is access e;
type f is Array (Integer range <>) of e_PTR;
type f_PTR is access f;
type gamestate is record
  cases : f_PTR;
  firstToPlay : Boolean;
  note : Integer;
  ended : Boolean;
end record;
-- Un Mouvement 

type move;
type move_PTR is access move;
type move is record
  x : Integer;
  y : Integer;
end record;
-- On affiche l'état 

procedure print_state(g : in gamestate_PTR) is
begin
  PString(new char_array'( To_C("" & Character'Val(10) & "|")));
  for y in integer range 0..2 loop
    for x in integer range 0..2 loop
      if g.cases(x)(y) = 0
      then
        PString(new char_array'( To_C(" ")));
      else
        if g.cases(x)(y) = 1
        then
          PString(new char_array'( To_C("O")));
        else
          PString(new char_array'( To_C("X")));
        end if;
      end if;
      PString(new char_array'( To_C("|")));
    end loop;
    if y /= 2
    then
      PString(new char_array'( To_C("" & Character'Val(10) & "|-|-|-|" & Character'Val(10) & "|")));
    end if;
  end loop;
  PString(new char_array'( To_C("" & Character'Val(10))));
end;
-- On dit qui gagne (info stoquées dans g.ended et g.note ) 

procedure eval0(g : in gamestate_PTR) is
  win : Integer;
  linv : Integer;
  lin : Integer;
  freecase : Integer;
  colv : Integer;
  col : Integer;
begin
  win := 0;
  freecase := 0;
  for y in integer range 0..2 loop
    col := (-1);
    lin := (-1);
    for x in integer range 0..2 loop
      if g.cases(x)(y) = 0
      then
        freecase := freecase + 1;
      end if;
      colv := g.cases(x)(y);
      linv := g.cases(y)(x);
      if col = (-1) and then colv /= 0
      then
        col := colv;
      else
        if colv /= col
        then
          col := (-2);
        end if;
      end if;
      if lin = (-1) and then linv /= 0
      then
        lin := linv;
      else
        if linv /= lin
        then
          lin := (-2);
        end if;
      end if;
    end loop;
    if col >= 0
    then
      win := col;
    else
      if lin >= 0
      then
        win := lin;
      end if;
    end if;
  end loop;
  for x in integer range 1..2 loop
    if (g.cases(0)(0) = x and then g.cases(1)(1) = x) and then g.cases(2)(2) = x
    then
      win := x;
    end if;
    if (g.cases(0)(2) = x and then g.cases(1)(1) = x) and then g.cases(2)(0) = x
    then
      win := x;
    end if;
  end loop;
  g.ended := win /= 0 or else freecase = 0;
  if win = 1
  then
    g.note := 1000;
  else
    if win = 2
    then
      g.note := (-1000);
    else
      g.note := 0;
    end if;
  end if;
end;
-- On applique un mouvement 

procedure apply_move_xy(x : in Integer; y : in Integer; g : in gamestate_PTR) is
  player : Integer;
begin
  player := 2;
  if g.firstToPlay
  then
    player := 1;
  end if;
  g.cases(x)(y) := player;
  g.firstToPlay := not g.firstToPlay;
end;
procedure apply_move(m : in move_PTR; g : in gamestate_PTR) is
begin
  apply_move_xy(m.x, m.y, g);
end;
procedure cancel_move_xy(x : in Integer; y : in Integer; g : in gamestate_PTR) is
begin
  g.cases(x)(y) := 0;
  g.firstToPlay := not g.firstToPlay;
  g.ended := FALSE;
end;
procedure cancel_move(m : in move_PTR; g : in gamestate_PTR) is
begin
  cancel_move_xy(m.x, m.y, g);
end;
function can_move_xy(x : in Integer; y : in Integer; g : in gamestate_PTR) return Boolean is
begin
  return g.cases(x)(y) = 0;
end;
function can_move(m : in move_PTR; g : in gamestate_PTR) return Boolean is
begin
  return can_move_xy(m.x, m.y, g);
end;
--
--Un minimax classique, renvoie la note du plateau
--

function minmax(g : in gamestate_PTR) return Integer is
  maxNote : Integer;
  currentNote : Integer;
begin
  eval0(g);
  if g.ended
  then
    return g.note;
  end if;
  maxNote := (-10000);
  if not g.firstToPlay
  then
    maxNote := 10000;
  end if;
  for x in integer range 0..2 loop
    for y in integer range 0..2 loop
      if can_move_xy(x, y, g)
      then
        apply_move_xy(x, y, g);
        currentNote := minmax(g);
        cancel_move_xy(x, y, g);
        -- Minimum ou Maximum selon le coté ou l'on joue
        
        if (currentNote > maxNote) = g.firstToPlay
        then
          maxNote := currentNote;
        end if;
      end if;
    end loop;
  end loop;
  return maxNote;
end;
--
--Renvoie le coup de l'IA
--

function play(g : in gamestate_PTR) return move_PTR is
  minNote : Integer;
  minMove : move_PTR;
  currentNote : Integer;
begin
  minMove := new move;
  minMove.x := 0;
  minMove.y := 0;
  minNote := 10000;
  for x in integer range 0..2 loop
    for y in integer range 0..2 loop
      if can_move_xy(x, y, g)
      then
        apply_move_xy(x, y, g);
        currentNote := minmax(g);
        PInt(x);
        PString(new char_array'( To_C(", ")));
        PInt(y);
        PString(new char_array'( To_C(", ")));
        PInt(currentNote);
        PString(new char_array'( To_C("" & Character'Val(10))));
        cancel_move_xy(x, y, g);
        if currentNote < minNote
        then
          minNote := currentNote;
          minMove.x := x;
          minMove.y := y;
        end if;
      end if;
    end loop;
  end loop;
  PInt(minMove.x);
  PInt(minMove.y);
  PString(new char_array'( To_C("" & Character'Val(10))));
  return minMove;
end;
function init0 return gamestate_PTR is
  tab : e_PTR;
  cases : f_PTR;
  a : gamestate_PTR;
begin
  cases := new f (0..2);
  for i in integer range 0..2 loop
    tab := new e (0..2);
    for j in integer range 0..2 loop
      tab(j) := 0;
    end loop;
    cases(i) := tab;
  end loop;
  a := new gamestate;
  a.cases := cases;
  a.firstToPlay := TRUE;
  a.note := 0;
  a.ended := FALSE;
  return a;
end;
function read_move return move_PTR is
  y : Integer;
  x : Integer;
  b : move_PTR;
begin
  Get(x);
  SkipSpaces;
  Get(y);
  SkipSpaces;
  b := new move;
  b.x := x;
  b.y := y;
  return b;
end;

  state : gamestate_PTR;
  d : move_PTR;
  c : move_PTR;
begin
  for i in integer range 0..1 loop
    state := init0;
    c := new move;
    c.x := 1;
    c.y := 1;
    apply_move(c, state);
    d := new move;
    d.x := 0;
    d.y := 0;
    apply_move(d, state);
    while not state.ended loop
      print_state(state);
      apply_move(play(state), state);
      eval0(state);
      print_state(state);
      if not state.ended
      then
        apply_move(play(state), state);
        eval0(state);
      end if;
    end loop;
    print_state(state);
    PInt(state.note);
    PString(new char_array'( To_C("" & Character'Val(10))));
  end loop;
end;

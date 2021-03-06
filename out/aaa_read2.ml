(*
Ce test permet de vérifier si les différents backends pour les langages implémentent bien
read int, read char et skip
*)
let () =
 let len = Scanf.scanf "%d " (fun len -> len) in
  Printf.printf "%d=len\n" len;
  let tab = Array.init len (fun _a ->
    let b = Scanf.scanf "%d " (fun b -> b) in
    b) in
  for i = 0 to len - 1 do
    Printf.printf "%d=>%d " i tab.(i)
  done;
  Printf.printf "\n";
  let tab2 = Array.init len (fun _d ->
    let e = Scanf.scanf "%d " (fun e -> e) in
    e) in
  for i_ = 0 to len - 1 do
    Printf.printf "%d==>%d " i_ tab2.(i_)
  done;
  let strlen = Scanf.scanf "%d " (fun strlen -> strlen) in
  Printf.printf "%d=strlen\n" strlen;
  let tab4 = Array.init strlen (fun _f ->
    let g = Scanf.scanf "%c" (fun g -> g) in
    g) in
  Scanf.scanf " " ();
  for i3 = 0 to strlen - 1 do
    let tmpc = tab4.(i3) in
    let c = ref( (int_of_char (tmpc)) ) in
    Printf.printf "%c:%d " tmpc (!c);
    if tmpc <> ' ' then
      c := ((!c) - (int_of_char ('a')) + 13) mod 26 + (int_of_char ('a'));
    tab4.(i3) <- (char_of_int ((!c)))
  done;
  for j = 0 to strlen - 1 do
    Printf.printf "%c" tab4.(j)
  done 
 
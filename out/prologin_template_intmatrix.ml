let read_int_matrix x y =
  let tab = Array.init y (fun _z ->
    let b = Array.init x (fun _c ->
      let d = Scanf.scanf "%d " (fun v_0 -> v_0) in
      d) in
    b) in
  tab

let programme_candidat tableau x y =
  let out_ = ref( 0 ) in
  for i = 0 to y - 1 do
    for j = 0 to x - 1 do
      out_ := (!out_) + tableau.(i).(j) * (i * 2 + j)
    done
  done;
  (!out_)

let () =
begin
  let taille_x = Scanf.scanf "%d " (fun x -> x) in
  let taille_y = Scanf.scanf "%d " (fun x -> x) in
  let tableau = read_int_matrix taille_x taille_y in
  Printf.printf "%d\n" (programme_candidat tableau taille_x taille_y)
end
 
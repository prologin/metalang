let rec f tuple_ =
  let (a, b) = tuple_ in
  (a + 1, b + 1)

let () =
begin
  let t = f ((0, 1)) in
  let (a, b) = t in
  Printf.printf "%d" a;
  Printf.printf " -- ";
  Printf.printf "%d" b;
  Printf.printf "--\n"
end
 
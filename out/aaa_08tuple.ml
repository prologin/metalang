type toto = {
  mutable foo : (int * int);
  mutable bar : int;
};;

let () =
begin
  let bar_ = Scanf.scanf "%d " (fun x -> x) in
  let e, f = Scanf.scanf "%d %d " (fun v_0 v_1 -> v_0, v_1) in
  let t = {
    foo=(e, f);
    bar=bar_;
  } in
  let (a, b) = t.foo in
  Printf.printf "%d %d %d\n" a b t.bar
end
 
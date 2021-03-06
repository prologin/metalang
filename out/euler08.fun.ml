module Array = struct
  include Array
  let init_withenv len f env =
    let refenv = ref env in
    let tab = Array.init len (fun i ->
      let env, out = f i !refenv in
      refenv := env;
      out
    ) in !refenv, tab
end

let main =
  let i = 1 in
  (fun (i, last) ->let max0 = i in
                   let index = 0 in
                   let nskipdiv = 0 in
                   let rec h k i index max0 nskipdiv =
                     if k <= 995
                     then Scanf.scanf "%c"
                     (fun e -> let f = (int_of_char (e)) - (int_of_char ('0')) in
                     (fun (i, nskipdiv) ->( last.(index) <- f;
                                            let index = (index + 1) mod 5 in
                                            let max0 = (max (max0) (i)) in
                                            h (k + 1) i index max0 nskipdiv)) (if f = 0
                                                                               then let i = 1 in
                                                                               let nskipdiv = 4 in
                                                                               i, nskipdiv
                                                                               else let i = i * f in
                                                                               let i = 
                                                                               if nskipdiv < 0
                                                                               then i / last.(index)
                                                                               else i in
                                                                               let nskipdiv = nskipdiv - 1 in
                                                                               i, nskipdiv))
                     else Printf.printf "%d\n" max0 in
                     h 1 i index max0 nskipdiv) (Array.init_withenv 5 (fun j i -> Scanf.scanf "%c"
  (fun c -> let d = (int_of_char (c)) - (int_of_char ('0')) in
  let i = i * d in
  let g = d in
  i, g)) i)


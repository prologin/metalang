type intlist = {mutable head : int; mutable tail : intlist;}
let cons list i =
  let out0 = {head=i;
  tail=list} in
  out0
let rec rev2 empty acc torev =
  let c () = () in
  (if (torev = empty)
   then acc
   else let acc2 = {head=torev.head;
   tail=acc} in
   (rev2 empty acc torev.tail))
let rev empty torev =
  (rev2 empty empty torev)
let test empty =
  let list = empty in
  let i = (- 1) in
  let rec a i list =
    (if (i <> 0)
     then Scanf.scanf "%d"
     (fun  b -> let i = b in
     let list = (if (i <> 0)
                 then let list = (cons list i) in
                 list
                 else list) in
     (a i list))
     else ()) in
    (a i list)
let main =
  ()


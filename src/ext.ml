(*
 * Copyright (c) 2012, Prologin
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *)

(** Standard library

    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
    @author Arthur Wendling (art.wendling\@gmail.com)
*)


(** {2 Standard Operators } *)
let ( $ ) f x = f x
let ( <| ) f x = f x
let ( |> ) x f = f x
let ( @* ) f g x = f (g x)
let ( @$ ) f x = f x
let ( @** ) f g x y = f (g x y)

(** {2 Utils functions } *)
let id x = x
let curry f a b = f (a, b)
let uncurry f (a, b) = f a b

let map_fst f (a, b) = f a, b
let map_snd f (a, b) = a, f b

let const x _ = x
let flip f x y = f y x

let cons x xs = x::xs
let snoc xs x = x::xs

(** {2 type conversion functions } *)
let int = int_of_float
let float = float_of_int
let int_of_bool b = if b then 1 else 0
let float_of_char = float_of_int @* int_of_char
let float_of_bool = float_of_int @* int_of_bool

(** {missing functions in pervasives} *)

let xor a b = (a && not b) || (b && not a)

(** {2 Standard modules } *)

module Int = struct
  type t = int
  let compare : int -> int -> int = Pervasives.compare
  let sqrt = int @* sqrt @* float
  let abs t = if t > 0 then t else -t

  let exp =
    let rec go r a b =
      if b = 0
      then r
      else if b mod 2 = 0
      then go r (a * a) (b / 2)
      else go (a * r) a (b - 1)
    in go 1
end

(**
   Option module
*)
module Option = struct

  let iter f = function
    | None -> ()
    | Some a -> f a

  (**
     Renvoie une exception quand on lui passe None en argument
     Renvoie la valeur x contenue dans Some x
  *)
  let extract = function
    | None -> invalid_arg "Option.get"
    | Some value -> value

  (**
     Si None, renvoie default
     Si Some x, renvoie f x
  *)
  let map_default default f = function
    | None -> default
    | Some value -> f value

  (** renvoie true si la valeur passée en argument est none *)
  let is_none x = map_default true (const false) x
  (** renvoie true si la valeur passée en argument est Some _ *)
  let is_some x = not (is_none x)
  (** renvoie d si None, x si Some x *)
  let default d = map_default d id
  (** crée Some x a partir de x *)
  let return x = Some x
  (** renvoie None si le second argument est None, renvoie f x si le
      second argument est Some x *)
  let bind f = map_default None f
  (** renvoie None si le second argument est None, renvoie Some (f
      x) si le second argument est Some x*)
  let map f = bind (return @* f)

  let catch f x = try Some (f x) with _ -> None
  let snoc xs = map_default xs (snoc xs)
end

(**
   Either module
*)
module Either = struct
  type ('a, 'b) t =
    | A of 'a
    | B of 'b
end

(**
   List module
*)
module List = struct
  include List

  let pack n li =
    let rec f acc1 acc2 i = function
      | [] -> List.rev (List.rev acc1 :: acc2)
      | hd::tl -> if i = 1 then
          f [hd] (List.rev acc1::acc2) n tl
        else f (hd::acc1) acc2 (i - 1) tl
    in f [] [] (n +1) li

  (* TODO faire plus efficace*)
  let collect f li = map f li |> flatten

  let indexof item li =
    fold_left
      (fun (found, index) i ->
         if i = item then index, index + 1
         else (found, index + 1)
      ) (-1, 0) li |> fst

  let zip = combine
  let zip_with = List.map2
  let unzip = split
  let forall = for_all

  let init f n =
    let rec aux li = function
      | 0 -> f 0 :: li
      | n -> aux (f n :: li) (n - 1)
    in aux [] (n - 1)

  let rec seq a b = init (( + ) a) (b - a + 1)
  let ( -- ) = seq

  let rec insert n item li =
    if n = 0
    then item :: li
    else match li with
      | hd::tl -> hd :: insert (n - 1) item tl
      | [] -> invalid_arg "List.insert"

  let rec last = function
    | [] -> invalid_arg "List.last"
    | [x] -> x
    | _ :: xs -> last xs

  let split_last xs =
    let rec go ys = function
      | [] -> invalid_arg "List.split_last"
      | [x] -> x, List.rev ys
      | y :: xs -> go (y::ys) xs
    in go [] xs

  let rec split_at n =
    let rec go n xs ys = match n, ys with
      | 0, _ | _, [] -> List.rev xs, ys
      | _, y::ys -> go (n - 1) (y::ys) ys
    in go n []
  let take n xs = fst (split_at n xs)

  let rec take_while f = function
    | [] -> []
    | t :: _ when not $ f t -> []
    | t :: q -> t :: take_while f q

  let shuffle li =
    let array_shuffle t =
      let len = Array.length t in
      for i = 0 to len - 1 do
        let j = Random.int len in
        let tmp = t.(j) in
        t.(j) <- t.(i) ;
        t.(i) <- tmp
      done in
    let t = Array.of_list li in
    array_shuffle t ;
    Array.to_list t

  let iteri f = ignore @* List.fold_left (fun i x -> f i x ; i + 1) 0


  let filter_map f li =
    List.fold_right (fun x xs -> Option.snoc xs (f x)) li []

  let fold_left_filter_map f a li =
    let acc, li =
      fold_left (fun (a, xs) -> map_snd (Option.snoc xs) @* f a) (a, []) li
    in acc, List.rev li

  let fold_left_map f = fold_left_filter_map (map_snd Option.return @** f)

  let mapi f li = snd (fold_left_map (fun i x -> i + 1, f i x) 0 li)

  let find_opt l = Option.catch (find l)

  let rec join sep = function
    | [] | [_] as li -> li
    | hd :: tl -> hd :: sep :: join sep tl

end

(**
   String module
*)

module String = struct
  include String

  let trim = String.trim

  let join li = List.fold_left (^) "" li

  let rec split s c =
    try
      let index = String.index s c in
      (String.sub s 0 index) :: (split (String.sub s (index +1) ((String.length s) - index - 1)) c)
    with Not_found -> [s]

  let from_char c = make 1 c
  let of_string (s:string) = (s:t)
  let equals a b = 0 = compare a b
  let lines = String.split_on_char '\n'
  let unlines = String.concat "\n"
  let unwords = String.concat " "

  let match_from s s' from =
    try for i = 0 to length s - 1 do
        if s.[i] <> s'.[i + from] then raise Not_found
      done ;
      true
    with Not_found -> false

  let index s s' from =
    let max = length s' - length s in
    let rec go n =
      if n > max
      then raise Not_found
      else if match_from s s' n
      then n
      else go (n + 1)
    in go from

  let is_sub s s' = try ignore (index s s' 0) ; true with Not_found -> false

  let ends_with s s' =
    let l = String.length s in
    let l' = String.length s' in
    if l' > l then false else
      let s = String.sub s (l - l') l' in
      s = s'

  let starts_with s s' =
    let l = String.length s in
    let l' = String.length s' in
    if l' > l then false else
      let s = String.sub s 0 l' in
      s = s'

  let is_prefix s s' = match_from s s' 0

  let is_capitalised s = let c = s.[0] in c >= 'A' && c <= 'Z'

  let fold_left f x s =
    let len = String.length s in
    let rec go i x =
      if i >= len
      then x
      else go (i + 1) (f x s.[i])
    in go 0 x
  let list_of_map f = fold_left (flip (cons @* f)) []

  let for_all f s = fold_left (fun acc c -> acc && f c) true s
  let exists f s = fold_left (fun acc c -> acc || f c) false s

  let of_list li =
    let t = Array.of_list li in
    String.init (Array.length t) (fun i -> t.(i))

  let of_char c = String.make 1 c

  let list_of_fold_map f s a =
    fold_left (fun (a, xs) -> map_snd (snoc xs) @* f a) (a, []) s

  let unescape s =
    let escape = function
      | 'n' -> '\n'
      | 't' -> '\t'
      | '"' -> '"'
      | '\\' -> '\\'
      | _ -> invalid_arg "String.unescape" in
    let buf = Buffer.create (String.length s) in
    let add c = Buffer.add_char buf c ; false in
    ignore $ fold_left (fun escaped c ->
        if not escaped
        then c = '\\' || add c
        else add (escape c)) false s ;
    Buffer.contents buf

  let chararray s =
    let len = length s in
    Array.init len (String.get s)

  let charlist s = Array.to_list (chararray s)
  
  let replace b c a =
    let a, b, c = charlist a, charlist b, charlist c in
    let rec begin_with a b = match a, b with
      | hd1::tl1, hd2::tl2 ->
        if hd1 = hd2 then begin_with tl1 tl2
        else None
      | tail, [] ->  Some tail
      | [], _ -> None
    in
    let rec replace acc a =
      match begin_with a b with
      | Some tail -> replace (List.rev_append c acc) tail
      | None -> match a with
        | hd::tail -> replace (hd::acc) tail
        | [] -> List.rev acc
    in let tab = replace [] a |> Array.of_list in
    String.init (Array.length tab) (fun i -> tab.(i))
end

(** {2 Collections} *)

module type SigSet = sig
  type elt
  type t
  val empty : t
  val is_empty : t -> bool
  val mem : elt -> t -> bool
  val add : elt -> t -> t
  val singleton : elt -> t
  val remove : elt -> t -> t
  val union : t -> t -> t
  val inter : t -> t -> t
  val diff : t -> t -> t
  val compare : t -> t -> int
  val equal : t -> t -> bool
  val subset : t -> t -> bool
  val iter : (elt -> unit) -> t -> unit
  val fold : (elt -> 'a -> 'a) -> t -> 'a -> 'a
  val for_all : (elt -> bool) -> t -> bool
  val exists : (elt -> bool) -> t -> bool
  val filter : (elt -> bool) -> t -> t
  val partition : (elt -> bool) -> t -> t * t
  val cardinal : t -> int
  val elements : t -> elt list
  val min_elt : t -> elt
  val max_elt : t -> elt
  val choose : t -> elt
  val split : elt -> t -> t * bool * t
  val from_list : elt list -> t
end

module MakeSet (K : Set.OrderedType) : SigSet with type elt = K.t = struct
  include Set.Make (K)
  let from_list = List.fold_left (flip add) empty
end

module type SigMap = sig
  type key
  type 'a t
  val empty : 'a t
  val is_empty : 'a t -> bool
  val mem : key -> 'a t -> bool
  val add : key -> 'a -> 'a t -> 'a t
  val singleton : key -> 'a -> 'a t
  val remove : key -> 'a t -> 'a t
  val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
  val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
  val iter : (key -> 'a -> unit) -> 'a t -> unit
  val fold : (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
  val for_all : (key -> 'a -> bool) -> 'a t -> bool
  val exists : (key -> 'a -> bool) -> 'a t -> bool
  val filter : (key -> 'a -> bool) -> 'a t -> 'a t
  val partition : (key -> 'a -> bool) -> 'a t -> 'a t * 'a t
  val cardinal : 'a t -> int
  val bindings : 'a t -> (key * 'a) list
  val min_binding : 'a t -> key * 'a
  val max_binding : 'a t -> key * 'a
  val choose : 'a t -> key * 'a
  val split : key -> 'a t -> 'a t * 'a option * 'a t
  val find : key -> 'a t -> 'a
  val map : ('a -> 'b) -> 'a t -> 'b t
  val mapi : (key -> 'a -> 'b) -> 'a t -> 'b t
  val merge : (key -> 'a option -> 'a option -> 'a option) -> 'a t -> 'a t -> 'a t
  val to_list : 'a t -> (key * 'a) list
  val from_list : (key * 'a) list -> 'a t
  val find_opt : key -> 'a t -> 'a option
end
module MakeMap (K : Map.OrderedType) = struct
  include Map.Make (K)
  let to_list map = fold (curry cons) map []
  let from_list xs = List.fold_left (flip (uncurry add)) empty xs
  let find_opt key = Option.catch (find key)
end

(** {3 Collections prédéfinies} *)
module IntSet = MakeSet (Int)
module IntMap = MakeMap (Int)
module StringMap = MakeMap (String)
module StringSet = MakeSet (String)

(** {2 Fix module} *)
(** les modules dérécursivés *)
module type Fixable = sig
  type ('a, 'b) tofix
  val map : ('a -> 'b) -> ('a, 'c) tofix -> ('b, 'c) tofix

  val next : unit -> int
end

module Fix (F : Fixable) = struct
  type 'a t = F of int * ('a t, 'a) F.tofix
  let annot = function F (i, _) -> i
  let unfix = function F (_, x) -> x
  let fix x = F (F.next (), x)
  let fixa a x = F (a, x)
  let map = F.map
  let rec dmap f (F(i, x)) = F (i, F.map (fun x -> f (dmap f x)) x)
  let rec dfold f (F(i, x))  = f (F.map (dfold f) x)
end

(** {Some Haskell} *)
module type Applicative = sig
  type 'a t
  val ret : 'a -> 'a t
  val (<*>) : ('a -> 'b) t -> 'a t -> 'b t
end

module type Monade = sig
  include Applicative
  val (=<<) : ('a -> 'b t) -> 'a t -> 'b t
end

module ListApp (F:Applicative) = struct
  open F
  let fold_left_map f l = List.fold_right (fun x xs -> ret cons <*> f x <*> xs) l (ret [])
end

module Applicatives = struct
  module FoldMap (Acc : sig type t end) = struct
    type 'a t = Acc.t -> Acc.t * 'a
    let ret x acc = acc, x
    let (<*>) f g acc =
      let acc, e1 = f acc in
      let acc, e2 = g acc in
      acc, e1 e2
    let (=<<) f t acc =
      let acc, x = t acc in
      f x acc
  end
  module Map = struct
    type 'a t = 'a
    let ret x = x
    let (<*>) f g = f g
    let (=<<) f x = f x
  end
  module Fold (Acc : sig type t end) = struct
    type 'a t = (Acc.t -> Acc.t)
    let ret _ acc = acc
    let (<*>) f g acc =
      let acc = f acc in
      let acc = g acc in
      acc
  end
  module Accumule (Acc : sig type t
      val merge : t -> t -> t
      val zero : t
    end) = struct
    type 'a t = Acc.t * 'a
    let ret x = Acc.zero, x
    let (<*>) (acc1, f1) (acc2, x) = Acc.merge acc1 acc2, f1 x
  end
end

module type FoldMapApplicative = sig
  type 'a t
  module Make : functor (F:Applicative) -> sig
    val foldmap : ('a -> 'ra F.t) -> 'a t -> 'ra t F.t
  end
end

module FromFoldMap (F : FoldMapApplicative) = struct

  let foldmap (type acc)  f x =
    let module FoldMap = Applicatives.FoldMap(struct type t = acc end) in
    let module M =  F.Make (FoldMap)
    in M.foldmap f x

  let fold (type acc) f x =
    let module Fold = Applicatives.Fold(struct type t = acc end) in
    let module M = F.Make (Fold)
    in M.foldmap f x

  let map f x =
    let module M = F.Make (Applicatives.Map)
    in M.foldmap f x
end

(** {2 Fix module V2} *)
(** les modules dérécursivés *)

module type Fixable2 = sig
  type ('a, 'b) tofix

  module Make : functor (F:Applicative) -> sig
    val foldmap : ('a -> 'ra F.t) -> ('b -> 'rb F.t) -> ('a, 'b) tofix -> ('ra, 'rb) tofix F.t
  end

  val next : unit -> int
end

module Fix2 (F : Fixable2) = struct
  type 'a t = F of int * ('a t, 'a) F.tofix
  let annot = function F (i, _) -> i
  let unfix = function F (_, x) -> x
  let fix x = F (F.next (), x)
  let fixa a x = F (a, x)

  module Surface = struct

    let foldmap2 (type acc) f g x =
      let module FoldMap = F.Make(Applicatives.FoldMap(struct type t = acc end) ) in
      FoldMap.foldmap f g x

    let fold2 (type acc) f g x =
      let module Fold = F.Make(Applicatives.Fold(struct type t = acc end) ) in
      Fold.foldmap f g x

    let map2 f g x =
      let module Map = F.Make(Applicatives.Map) in
      Map.foldmap f g x

    let foldmap (type acc) f x =
      let module FoldMap = Applicatives.FoldMap(struct type t = acc end) in
      let module M = F.Make(FoldMap) in
      M.foldmap f FoldMap.ret x

    let fold (type acc) f x =
      let module Fold = Applicatives.Fold(struct type t = acc end) in
      let module M = F.Make(Fold) in
      M.foldmap f Fold.ret x

    let map f x =
      let module M = F.Make(Applicatives.Map) in
      M.foldmap f Applicatives.Map.ret x

    let fold f acc x = fold (fun acc x -> f x acc) x acc

    let foldmapt f (F (i, x)) acc = let acc, x = foldmap f x acc in acc, F (i, x)
    let mapt f (F(i, x)) = F (i, map f x)
  end

  module Apply (A : Applicative) = struct
    open A
    module M = F.Make(A)
    let rec fm2 f g (F(i, x)) = f (M.foldmap (fm2 f g) g x)
    let rec fm2i f g (F(i, x)) = f i (M.foldmap (fm2i f g) (g i) x)
    let rec fm f x = fm2 f ret x
    let rec fmi f x = fm2i f (fun _ -> ret) x
    let map g t = fm2i (fun i x -> ret (fixa i) <*> x) (fun _ -> g) t
    let mapi g t = fm2i (fun i x -> ret (fixa i) <*> x) g t
  end

  module Deep = struct
    let rec map f (F(i, x)) = f (F (i, Surface.map (map f) x))
    let rec mapa f (F(i, x)) = f i (F (i, Surface.map (mapa f) x))
    let rec fold f (F(i, x))  = f (Surface.map (fold f) x)

    let rec fold_acc f acc ((F(i, x)) as orig) =
      let acc = Surface.fold (fun acc x ->
          let acc = fold_acc f acc x in
          f acc orig) acc x
      in f acc orig

    let rec foldorig f (F(i, x) as orig)  = f orig (Surface.map (foldorig f) x)
    let rec folda f (F(i, x))  = f i (Surface.map (folda f) x)
    let rec exists f x =
      if f x then true
      else fst (Surface.foldmap (fun x acc -> (acc || exists f x), x) (unfix x) false)

    module Map = Apply(Applicatives.Map)
    let mapg = Map.map
    let map2 (type acc) f g x =
      Map.fm2i (fun i x -> fixa i (f x)) (fun _ -> g) x

    let fold2_bottomup (type acc) x = Map.fm2 x
    let fold2i_bottomup (type acc) f g x = Map.fm2i f (fun _ -> g) x

    let foldmap2_topdown (type acc) f =
      let module Mon = Applicatives.FoldMap(struct type t = acc end) in
      let module M = Apply (Mon)
      in M.fm2 (Mon.(=<<) f)

    let foldmap2i_topdown (type acc) f g =
      let module Mon = Applicatives.FoldMap(struct type t = acc end) in
      let module M = Apply (Mon)
      in M.fm2i (fun i -> Mon.(=<<) (f i)) (fun _ -> g)

    let foldg (type acc) g =
      let module Mon = Applicatives.Fold(struct type t = acc end) in
      let module M = Apply (Mon)
      in M.fm2 (fun f x -> f x) g

    let foldmapg f x acc = foldmap2i_topdown (fun i x acc -> acc, fixa i x) f x acc
    let foldmap_topdown f x acc = foldmap2i_topdown
        (fun i x acc -> let acc, x = f x acc in acc, fixa i x)
        (fun x acc -> acc, x) x acc

  end
end

module MKArrow (App:Applicative) = struct
  type (_, _) arrow =
      Id : ('x, 'x) arrow
    | Arrow :
        ('x -> 'y App.t)
        * ('p, 'q) arrow
      -> ('x * 'p, 'y * 'q) arrow

  let arrow f = Arrow (f, Id)

  let carrow f g = Arrow(f, g)

  let extract : type a b x y . (a * x, b * y) arrow -> (a -> b App.t) * (x, y) arrow  = function
    | Id -> App.ret, Id
    | Arrow (f, x) -> f, x
end

module type FixableN = sig
  type 'a tofix
  module Make : functor (App:Applicative) -> sig
    val foldmap : ('a, 'ra) MKArrow(App).arrow -> 'a tofix -> 'ra tofix App.t
  end
  val next : unit -> int
end

module FixN (F : FixableN) = struct
  type 'a t = Fix of int * ('a t * 'a) F.tofix

  let annot = function Fix (i, _) -> i
  let unfix = function Fix (_, x) -> x
  let fix x = Fix (F.next (), x)
  let fixa a x = Fix (a, x)

  module Apply (App : Applicative) = struct
    open App
    module M = F.Make(App)
    module Arrow = MKArrow(App)
    let rec foldi f (Fix (i, x)) = f i (M.foldmap (Arrow.arrow (foldi f)) x)
    let rec map arrow (Fix (i, x)) =
      ret (fun x -> Fix (i, x)) <*> M.foldmap (Arrow.carrow (map arrow) arrow) x
  end

  module Deep = struct
    module Map = Apply(Applicatives.Map)
    let mapg g x= Map.map (Map.Arrow.arrow g) x
  end

end

module Printers = struct
  let print_list func sep f li =
    let rec p t = function
      | [] -> ()
      | [hd] -> func t hd
      | hd::tl ->
        sep
          t
          func hd
          p tl
    in p f li
end

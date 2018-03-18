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

(** Haskell Printer
    note : http://xkcd.com/1312/
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Helper

module E = AstFun.Expr
module Type = Ast.Type

let prelude_cnt =
  "count t = do
  (a,b) <- getBounds t
  return (b - a + 1)
"

let prelude_and = "
(<&&>) a b =
	do c <- a
	   if c then b
		 else return False"
let prelude_or = "(<||>) a b =
	do c <- a
	   if c then return True
		 else b"
let prelude_ifm = "ifM :: IO Bool -> IO a -> IO a -> IO a
ifM c i e =
  do b <- c
     if b then i else e"
let prelude_writeIOA = "writeIOA :: IOArray Int a -> Int -> a -> IO ()
writeIOA = writeArray"
let prelude_readIOA = "readIOA :: IOArray Int a -> Int -> IO a
readIOA = readArray"
let prelude_skip = "skip_whitespaces :: IO ()
skip_whitespaces =
  ifM isEOF
      (return ())
      (do c <- hLookAhead stdin
          if c == ' ' || c == '\\n' || c == '\\t' || c == '\\r' then
           do getChar
              skip_whitespaces
           else return ())"

let prelude_readint = "read_int_a :: Int -> IO Int
read_int_a b =
  ifM isEOF
      (return b)
      (do c <- hLookAhead stdin
          if isNumber c then
           do getChar
              read_int_a (b * 10 + ord c - 48)
           else return b)

read_int :: IO Int
read_int =
   do c <- hLookAhead stdin
      sign <- if c == '-'
                 then fmap (\\x -> -1::Int) $ hGetChar stdin
                 else return 1
      (* sign) <$> read_int_a 0"

let array_init_withenv = "array_init_withenv :: Int -> ( Int -> env -> IO(env, tabcontent)) -> env -> IO(env, IOArray Int tabcontent)
array_init_withenv len f env =
  do (env, li) <- g 0 env
     (,) env <$> newListArray (0, len - 1) li
  where g i env =
           if i == len
           then return (env, [])
           else do (env', item) <- f i env
                   (env'', li) <- g (i+1) env'
                   return (env'', item:li)"

let array_init1 = "array_init len f = fmap snd (array_init_withenv len (\\x () -> fmap ((,) ()) (f x)) ())"

let array_init2 = "array_init :: Int -> ( Int -> IO out ) -> IO (IOArray Int out)
array_init len f = newListArray (0, len - 1) =<< g 0
  where g i =
           if i == len
           then return []
           else fmap (:) (f i) <*> g (i + 1)"

let nop = -100
let fun_priority = 20
let fun_priority_op = 18
let lambda_priority = 18

let parens (p:int) p2 f fmt =
  let fmt = if p >= p2 then let open Format in "(" ^^ fmt ^^ ")" else fmt in
  Format.fprintf f fmt

let hsapply p f fun_ apply_side_effects args =
  match args with
  | [] -> parens p fun_priority f "%a ()" fun_ ()
  | [false, pr, x] when apply_side_effects -> parens p fun_priority f "%a >>= %a" (pr fun_priority) x fun_ ()
  | _ ->
    let count = if apply_side_effects then List.length args else 0 (* ne sera jamais atteind *) in
    let _, pure, pr = List.fold_left
        (fun (c, pure, p) (isPure, parg, arg) ->
           match pure, isPure with
             (true, true) -> c+1, true, (fun f () -> Format.fprintf f "%a %a" p () (parg fun_priority) arg)
           | (true, false) when c = count -> c+1, true, (fun f () -> Format.fprintf f "%a =<< %a" p () (parg fun_priority) arg)
           | (true, false)  -> c+1, false, (fun f () -> Format.fprintf f "%a <$> %a" p () (parg fun_priority) arg)
           | (false, false) -> c+1, false, (fun f () -> Format.fprintf f "%a <*> %a" p () (parg fun_priority) arg)
           | (false, true) -> c+1, false, (fun f () -> Format.fprintf f "%a <*> return %a" p () (parg fun_priority) arg)
        ) (1, true, fun_) args
    in
    if not pure && apply_side_effects then parens p fun_priority f "join $ %a" pr ()
    else parens p fun_priority f "%a" pr ()

let commutative = function
  | Ast.Expr.Add -> Some Ast.Expr.Add
  | Ast.Expr.Mul -> Some Ast.Expr.Mul
  | Ast.Expr.Eq -> Some Ast.Expr.Eq
  | Ast.Expr.Diff -> Some Ast.Expr.Diff
  | Ast.Expr.Or -> Some Ast.Expr.Or
  | Ast.Expr.And -> Some Ast.Expr.And
  | Ast.Expr.Lower -> Some Ast.Expr.Higher
  | Ast.Expr.LowerEq -> Some Ast.Expr.HigherEq
  | Ast.Expr.Higher -> Some Ast.Expr.Lower
  | Ast.Expr.HigherEq -> Some Ast.Expr.LowerEq
  | Ast.Expr.Div
  | Ast.Expr.Mod
  | Ast.Expr.Sub -> None


  let binopstr = function
    | Ast.Expr.Add -> "+"
    | Ast.Expr.Sub -> "-"
    | Ast.Expr.Mul -> "*"
    | Ast.Expr.Div -> "quot"
    | Ast.Expr.Mod -> "rem"
    | Ast.Expr.Or -> "||"
    | Ast.Expr.And -> "&&"
    | Ast.Expr.Lower -> "<"
    | Ast.Expr.LowerEq -> "<="
    | Ast.Expr.Higher -> ">"
    | Ast.Expr.HigherEq -> ">="
    | Ast.Expr.Eq -> "=="
    | Ast.Expr.Diff -> "/="

  let binop_priority = function
    | Ast.Expr.Add -> -1, -2, -2
    | Ast.Expr.Sub -> -1, -2, -1
    | Ast.Expr.Mul -> 0, -1, -1
    | Ast.Expr.Div -> -10, 15, 15
    | Ast.Expr.Mod -> -10, 15, 15
    | Ast.Expr.Or -> -8, -8, -8
    | Ast.Expr.And -> -10, -10, -10
    | Ast.Expr.Lower -> -5, -5, -5
    | Ast.Expr.LowerEq -> -5, -5, -5
    | Ast.Expr.Higher -> -5, -5, -5
    | Ast.Expr.HigherEq -> -5, -5, -5
    | Ast.Expr.Eq -> -6, -5, -5
    | Ast.Expr.Diff -> -5, -5, -5

  let binopShortCut = function
    | Ast.Expr.And -> Some "<&&>"
    | Ast.Expr.Or -> Some "<||>"
    | _ -> None

  let binopf = function
    | Ast.Expr.Div
    | Ast.Expr.Mod -> true
    | _ -> false


let unopstr = function
  | Ast.Expr.Neg -> "-"
  | Ast.Expr.Not -> "not"

let unopstrf = function
  | Ast.Expr.Neg -> "(-)"
  | Ast.Expr.Not -> "not"


let pbinopf f op =
  if binopf op
  then Format.fprintf f "%s" (binopstr op)
  else Format.fprintf f "(%s)" (binopstr op)

let pbinop f op =
  if binopf op
  then Format.fprintf f "`%s`" (binopstr op)
  else Format.fprintf f "%s" (binopstr op)

let punop f op = Format.fprintf f "%s" (unopstr op)
let punopf f op = Format.fprintf f "%s" (unopstrf op)


let tname f name = Format.fprintf f "%s" (String.capitalize_ascii name)
let ptype f t =
  let open Type in
  let open Format in
  let ptype ty f () = match ty with (* TODO gérer ici le parenthésage *)
    | Integer -> fprintf f "Int"
    | String -> fprintf f "String"
    | Array a -> fprintf f "(IOArray Int %a)" a ()
    | Option a -> fprintf f "(Maybe %a)" a ()
    | Void ->  fprintf f "()"
    | Bool -> fprintf f "Bool"
    | Char -> fprintf f "Char"
    | Named n -> tname f n
    | Struct li ->
      fprintf f "{@[<v 2>@\n%a@\n}@]"
        (print_list
           (fun t (name, type_) ->
              fprintf t "_%s :: IORef %a" name type_ ()
           )
           (sep "%a,@\n%a")
        ) li
    | Enum li ->
      fprintf f "%a"
        (print_list
           (fun t name ->
              Format.fprintf t "%s" name
           )
           (sep "%a@\n| %a")
        ) li
    | Lexems -> assert false
    | Auto -> assert false
    | Tuple li ->
      fprintf f "(%a)"
        (print_list (fun f g -> g f ()) sep_c) li
  in Fixed.Deep.fold ptype t f ()

let binding f s = match s with
  | Ast.UserName s -> Format.fprintf f "%s" s
  | Ast.InternalName i -> Format.fprintf f "internal_%d" i

let rec extract_fun_params' e acc = match E.unfix e with
    | E.Fun ([], e) ->
      let acc f () = Format.fprintf f "%a ()" acc ()
      in true, extract_fun_params e acc
    | E.Fun (params, e) ->
      let acc f () = Format.fprintf f "%a %a" acc () (print_list binding sep_space) params
      in true, extract_fun_params e acc
    | E.FunTuple (params, e) ->
      let acc f () = Format.fprintf f "%a (%a)" acc () (print_list binding sep_c) params
      in true, extract_fun_params e acc
    | _ -> false, (acc, e)
and extract_fun_params e acc = snd @$ extract_fun_params' e acc

let header binand binor array_init array_make ifm read_array write_array f opts =
    let need_stdinsep = opts.AstFun.hasSkip in
    let need_readint = Ast.TypeSet.mem (Type.integer) opts.AstFun.reads in
    let imports = [
      "Text.Printf";
      "Control.Applicative";
      "Control.Monad";
      "Data.Array.MArray";
      "Data.Array.IO";
      "Data.Char";
      "System.IO";
      "Data.IORef"
    ] in
    Format.fprintf f "@[%a@]@\n%a%a%a%a%a%a%a%a%a@\nmain :: IO ()"
      (print_list (fun f s -> Format.fprintf f "import %s" s) sep_nl) imports
      (fun f () -> if binand then Format.fprintf f "%s@\n" prelude_and) ()
      (fun f () -> if binor then Format.fprintf f "%s@\n" prelude_or) ()
      (fun f () -> if ifm then Format.fprintf f "%s@\n" prelude_ifm) ()
      (fun f () -> if need_stdinsep then Format.fprintf f "%s@\n" prelude_skip) ()
      (fun f () -> if need_readint then Format.fprintf f "%s@\n" prelude_readint) ()
      (fun f () -> if write_array then Format.fprintf f "%s@\n" prelude_writeIOA) ()
      (fun f () -> if read_array then Format.fprintf f "%s@\n" prelude_readIOA) ()
      (fun f () -> if Tags.is_taged "use_count"  then Format.fprintf f "%s@\n" prelude_cnt) ()
      (fun f () ->
         match array_init, array_make with
         | (true, true) -> Format.fprintf f "%s@\n%s@\n" array_init_withenv array_init1
         | true, false -> Format.fprintf f "%s@\n" array_init2
         | false, true -> Format.fprintf f "%s@\n" array_init_withenv
         | false, false -> ()
      ) ()


let isSideEffect side_effects expr = match IntMap.find (E.Fixed.annot expr) side_effects with
  | AstFun.EMacro -> false
  | AstFun.EPure -> false
  | AstFun.EEffect -> true

let isPure side_effects expr = not (isSideEffect side_effects expr)
let comment fe f str c = Format.fprintf f "@[<v>{-%s-}@\n%a@]" str fe c

let rec eM typerEnv side_effects macros p f e =
    match E.unfix e with
    | E.Comment (s, c) -> comment (eM typerEnv side_effects macros p) f s c
    | E.Block _ -> expr typerEnv side_effects macros p f e
    | E.LetIn (name, v, e2) ->
      if isPure side_effects e then letin typerEnv side_effects macros p f name v e2 (eM typerEnv side_effects macros nop)
      else expr typerEnv side_effects macros p f e
    | _ ->
      if isSideEffect side_effects e then expr typerEnv side_effects macros p f e
      else parens p (fun_priority - 1) f "return %a" (expr typerEnv side_effects macros fun_priority) e
and expand_macro_call typerEnv side_effects macros f name params code li =
    let lang = "hs" in
    let canBePure = List.for_all (isPure side_effects) li in
    let code_to_expand = List.fold_left
        (fun acc (clang, expantion) ->
           if clang = "" || clang = lang then
             if acc = None then Some (eM typerEnv side_effects macros nop, expantion) else acc
           else if canBePure && ( clang = "" || clang = lang  ^ "_pure") then
             Some ((expr typerEnv side_effects macros fun_priority), expantion)
           else acc
        ) None
        code
    in match code_to_expand with
    | None -> assert false (* TODO *)
    | Some (pr, s) ->
      let listr = List.map
          (fun e ->
             let b = Buffer.create 1 in
             let fb = Format.formatter_of_buffer b in
             Format.fprintf fb "@[<h>%a@]%!" pr e;
             Buffer.contents b
          ) li in
      let expanded = List.fold_left
          (fun s (param, string) ->
             String.replace ("$"^param) string s
          )
          s
          (List.combine params listr)
      in Format.fprintf f "(%s)" expanded
and blockContent typerEnv side_effects macros f li =
    print_list
      (fun f e ->
         match E.unfix e with
         | E.ReadIn( Type.Fixed.F(_, Type.Integer),
                     E.Fixed.F(_, E.Fun ( [name], next))
                   ) ->
           Format.fprintf f "@[<h>%a <- read_int@]@\n%a" binding name
             (blockContent typerEnv side_effects macros) [next]
         | E.ReadIn( Type.Fixed.F(_, Type.Char),
                     E.Fixed.F(_, E.Fun ( [name], next))
                   ) ->
           Format.fprintf f "@[<h>%a <- getChar@]@\n%a" binding name
             (blockContent typerEnv side_effects macros) [next]
         | E.Block li -> blockContent typerEnv side_effects macros f li
         | E.LetIn (s, v, e) ->
           let isfun, (pparams, a) = extract_fun_params' v (fun f () -> ()) in
           if isPure side_effects v then
             Format.fprintf f "@[<h>let %a%a = @[<v>%a@]@]@\n%a" binding s pparams ()
               (if isfun then eM typerEnv side_effects macros nop else expr typerEnv side_effects macros nop) a
               (blockContent typerEnv side_effects macros) [e]
           else
             Format.fprintf f "@[<h>%a%a <-@[<v> %a@]@]@\n%a" binding s pparams () (expr typerEnv side_effects macros nop) a
               (blockContent typerEnv side_effects macros) [e]
         | _ -> eM typerEnv side_effects macros nop f e
      ) sep_nl f li
and block typerEnv side_effects macros p f li =
    parens p (fun_priority -1) f "do @[<v>%a@]" (blockContent typerEnv side_effects macros) li
and expr typerEnv side_effects macros p f e = match E.unfix e with
  | E.Just e -> parens p fun_priority f "Something %a" (expr typerEnv side_effects macros p) e
    | E.ApplyMacro (fun_, li) ->
      begin match Ast.BindingMap.find_opt fun_ macros with
        | None -> assert false
        | Some ((t, params, code)) -> expand_macro_call typerEnv side_effects macros f fun_ params code li
      end
    | E.MultiPrint (formats, exprs) ->
      let side_effect =  List.exists (fun (e, _) -> isSideEffect side_effects e) exprs in
      let exprs = List.map (fun (e, ty) ->
          let pure = isPure side_effects e in
          pure, (fun p f () ->
              if pure then
                Format.fprintf f "(%a::%a)" (expr typerEnv side_effects macros p) e ptype ty
              else Format.fprintf f "(%a::IO %a)" (expr typerEnv side_effects macros p) e ptype ty
            ), ()
        ) exprs in
      let params = (true, (fun p f () -> 
          Format.fprintf f "%S" (format_to_string formats)), ()) :: exprs in
      parens p fun_priority f (if side_effect then "%a" else "%a :: IO()")
        (fun f () -> hsapply p f (fun f () -> Format.fprintf f "printf") true params) ()      
    | E.LetRecIn (name, params, e1, e2) ->
      begin match params with
        | [] -> parens p (fun_priority -1) f "let %a @[<v>() =@\n%a in@\n%a@]"
                  binding name
                  (expr typerEnv side_effects macros nop) e1
                  (expr typerEnv side_effects macros nop) e2
        | _ ->
          parens p (fun_priority -1) f "let %a @[<v>%a =@\n%a in@\n%a@]"
            binding name
            (print_list binding sep_space) params
            (expr typerEnv side_effects macros nop) e1
            (expr typerEnv side_effects macros nop) e2
      end
    | E.BinOp (a, op, b) ->
      let cq, q1, q2 = binop_priority op in
      begin match isPure side_effects a, isPure side_effects b, binopShortCut op, commutative op with
        | true, true, _, _ -> parens p cq f "%a %a %a" (expr typerEnv side_effects macros q1) a pbinop op (expr typerEnv side_effects macros q2)  b
        | true, false, None, _ -> Format.fprintf f "((%a %a) <$> %a)" pbinopf op (expr typerEnv side_effects macros fun_priority) a (expr typerEnv side_effects macros fun_priority) b
        | false, true, _, Some op2 -> Format.fprintf f "((%a %a) <$> %a)" pbinopf op2 (expr typerEnv side_effects macros fun_priority) b (expr typerEnv side_effects macros fun_priority) a
        | _, _, None, _ -> Format.fprintf f "(%a <$> %a <*> %a)" pbinopf op (eM typerEnv side_effects macros fun_priority) a (eM typerEnv side_effects macros fun_priority) b
        | _, _, Some s, _ -> Format.fprintf f "(%a %s %a)" (eM typerEnv side_effects macros fun_priority) a s (eM typerEnv side_effects macros fun_priority) b
      end
    | E.UnOp (a, op) ->
      let pr = match op with
        | Ast.Expr.Neg -> 2
        | Ast.Expr.Not -> fun_priority
      in
      if isPure side_effects a then parens p pr f "%a %a" punop op (expr typerEnv side_effects macros pr) a
      else parens p (fun_priority - 1) f "fmap %a %a"punopf op (expr typerEnv side_effects macros fun_priority) a
    | E.Fun (params, e) ->
      let pparams, e = extract_fun_params (E.fun_ params e) (fun f () -> ()) in
      parens p lambda_priority f "@[<v 2>\\%a ->@\n%a@]" pparams () (eM typerEnv side_effects macros nop) e
    | E.FunTuple (params, e) ->
      let pparams, e = extract_fun_params (E.funtuple params e) (fun f () -> ()) in
      parens p lambda_priority f "@[<v 2>(\\%a ->@\n%a)@]" pparams () (eM typerEnv side_effects macros nop) e
    | E.Apply (e, li) ->
      let default () = let li = List.map (fun e -> isPure side_effects e, expr typerEnv side_effects macros, e) li in
        hsapply p f (fun f () -> (expr typerEnv side_effects macros nop)f e) true li in
      begin match E.unfix e with
        | E.Lief ( E.Binding binding ) ->
          begin match Ast.BindingMap.find_opt binding macros with
            | None -> default ()
            | Some ((t, params, code)) -> expand_macro_call typerEnv side_effects macros f binding params code li
          end
        | _ -> default ()
      end
    | E.Tuple li -> if List.for_all (isPure side_effects) li then
        Format.fprintf f "(%a)" (print_list (expr typerEnv side_effects macros nop) sep_c) li
      else
        let li = List.map (fun e -> (isPure side_effects) e, expr typerEnv side_effects macros, e) li in
        hsapply nop f (fun f () -> Format.fprintf f "(%a)" (print_list (fun _ _ -> ()) sep_c) li)
          false li
    | E.Lief l ->
      begin match l with
        | E.Error -> Format.fprintf f "(assert false)"
        | E.Unit -> Format.fprintf f "()"
        | E.Char c -> Format.fprintf f "%C" c
        | E.String s -> Format.fprintf f "%S" s
        | E.Integer i ->
          (if i < 0 then parens p nop else Format.fprintf) f "%i" i
        | E.Bool true -> Format.fprintf f "True"
        | E.Bool false -> Format.fprintf f "False"
        | E.Enum s -> Format.fprintf f "%s" s
        | E.Binding s -> binding f s
        | E.Nil -> Format.fprintf f "Nothing"
      end
    | E.Comment (s, c) -> comment (expr typerEnv side_effects macros p) f s c
    | E.If (e1, e2, e3) ->
      let pr = if isPure side_effects e2 && isPure side_effects e3 then expr typerEnv side_effects macros nop else eM typerEnv side_effects macros nop in
      if isPure side_effects e1 then parens p (-1) f "@[<v>if %a@\nthen %a@\nelse %a@]" (expr typerEnv side_effects macros nop) e1 pr e2 pr e3
      else parens p (fun_priority - 1) f "@[<h>ifM @[<v>%a@\n%a@\n%a@]@]" (eM typerEnv side_effects macros fun_priority) e1 (eM typerEnv side_effects macros fun_priority) e2 (eM typerEnv side_effects macros fun_priority) e3
    | E.Print (e, t) ->
      begin
        match E.unfix e with
        | E.Lief (E.String s) -> parens p fun_priority f "printf %S :: IO ()"  s
        | _ ->
          if isPure side_effects e then
            parens p fun_priority f "@[printf %S (%a :: %a) :: IO ()@]" (format_type t)
              (expr typerEnv side_effects macros nop) e
              ptype t
          else
            parens p fun_priority f "@[printf %S =<< (%a :: IO %a)@]" (format_type t)
              (expr typerEnv side_effects macros nop) e
              ptype t
      end
    | E.ReadIn (ty, next) ->
      begin
        match Type.unfix ty, E.unfix next with
        | t, E.Fun ([o], E.Fixed.F(_, E.Lief (E.Binding o2) )) when o = o2 ->
          begin match t with
            | Type.Char -> Format.fprintf f "getChar"
            | Type.Integer -> Format.fprintf f "read_int"
            | _ -> assert false
          end
        | _, E.Fun ([_], _ ) -> block typerEnv side_effects macros p f [ E.readin next ty]
        | Type.Integer, _ ->  parens p (fun_priority-1) f "@[<h>read_int >>=@[<v> (%a)@]@]" (expr typerEnv side_effects macros nop) next
        | Type.Char, _ -> parens p (fun_priority-1) f "@[<h>getChar >>=@[<v> (%a)@]@]" (expr typerEnv side_effects macros nop) next
        | _ -> assert false
      end
    | E.Skip ->  Format.fprintf f "skip_whitespaces"
    | E.Block [e] -> expr typerEnv side_effects macros p f e
    | E.Block li -> block typerEnv side_effects macros p f li
    | E.Record li -> (* TODO trier les champs dans le bon ordre et parentheser correctement *)
      let t = Typer.typename_for_field (snd (List.hd li) ) typerEnv in
      Format.fprintf f "@[<v>(%a <$> %a)@]"
        tname t
        (print_list
           (fun f (e, field) ->
              hsapply fun_priority f (fun f () -> Format.fprintf f "newIORef") true
                [isPure side_effects e, expr typerEnv side_effects macros, e])
           (sep "%a <*> %a")) li
    | E.RecordAccess (record, field) ->
      hsapply p f (fun f () -> Format.fprintf f "readIORef") true
        [isPure side_effects record, (fun p f () ->
             hsapply p f (fun f () -> Format.fprintf f "_%s" field) false
               [isPure side_effects record, expr typerEnv side_effects macros, record]), ()]
    | E.RecordAffect (record, field, value) ->    hsapply p f (fun f () -> Format.fprintf f "writeIORef") true
      [isPure side_effects record, (fun p f () ->
           hsapply p f (fun f () -> Format.fprintf f "_%s" field) false
             [isPure side_effects record, expr typerEnv side_effects macros, record]), ();
       isPure side_effects value, (fun p f () -> expr typerEnv side_effects macros p f value), ()
      ]
    | E.ArrayMake (len, lambda, env) ->
      let f' e = isPure side_effects e, expr typerEnv side_effects macros, e in    
      hsapply p f (fun f () -> Format.fprintf f "array_init_withenv") true [f' len; f' lambda; f' env]
    | E.ArrayInit (len, lambda) ->
      let f' e = isPure side_effects e, expr typerEnv side_effects macros, e in    
      hsapply p f (fun f () -> Format.fprintf f "array_init") true [f' len; f' lambda]      
    | E.ArrayAccess (tab, indexes) -> arrayindex typerEnv side_effects macros p f tab indexes
    | E.ArrayAffect (tab, indexes, v) ->
      begin match List.rev indexes with
        | [] -> assert false
        | hd::tl -> let tl = List.rev tl in
          let array_pure = isPure side_effects tab && List.for_all (isPure side_effects) tl in
          hsapply p f (fun f () -> Format.fprintf f "writeIOA") true
            [array_pure, (fun p f () -> arrayindex typerEnv side_effects macros p f tab tl), ();
             isPure side_effects hd, (fun p f () -> expr typerEnv side_effects macros p  f hd), (); 
             isPure side_effects v, (fun p f () -> expr typerEnv side_effects macros p  f v), ()]
      end
    | E.LetIn (name, v, e') ->
      if isPure side_effects e then
        letin typerEnv side_effects macros p f name v e' (expr typerEnv side_effects macros nop)
      else block typerEnv side_effects macros p f [e]
and letin typerEnv side_effects macros p f name v e pexpr =
    let pparams, v = extract_fun_params v (fun f () -> ()) in
    parens p (fun_priority -1) f "@[<h>let %a%a = @[<v>%a@\nin %a@]@]"
      binding name pparams () (expr typerEnv side_effects macros nop) v pexpr e
and arrayindex typerEnv side_effects macros p f tab indexes =
    match List.rev indexes with
    | [] -> expr typerEnv side_effects macros p f tab
    | hd::tl -> let tl = List.rev tl in
      let array_pure = isPure side_effects tab && List.for_all (isPure side_effects) tl in
      hsapply p f (fun f () -> Format.fprintf f "readIOA") true
        [array_pure, (fun p f () -> arrayindex typerEnv side_effects macros p f tab tl), ();
         isPure side_effects hd, (fun p f () -> expr typerEnv side_effects macros p f hd), ();]

  let prog typerEnv (f:Format.formatter) (prog:AstFun.prog) =
    let side_effects = prog.AstFun.side_effects in
    let macros, liitems = List.fold_left (fun (macros, liitems) -> function
        | AstFun.Macro (name, t, params, code) ->
          Ast.BindingMap.add name (t, List.map fst params, code) macros, liitems
        | AstFun.Declaration (name, e) ->
          let pparams, e = extract_fun_params e (fun f () -> ()) in
          macros, (fun f -> Format.fprintf f "@[<v 2>%a%a =@\n%a@]@\n" binding name pparams ()
                      (eM typerEnv side_effects macros nop) e):: liitems
        | AstFun.DeclareType (name, ty) ->
          macros, (fun f -> match Type.unfix ty with
            | Type.Struct _ ->
              Format.fprintf f "@[<v 2>data %a = %a %a@]@\n  deriving Eq@\n@\n"
                tname name
                tname name 
                ptype ty
            | Type.Enum _ ->
              Format.fprintf f "@[<v 2>data %a = %a@]@\n  deriving Eq@\n@\n"
                tname name 
                ptype ty
            | _ ->
              Format.fprintf f "@[<v 2>type %a = %a@]@\n@\n"
                tname name 
                ptype ty
            ):: liitems
      ) (Ast.BindingMap.empty, []) prog.AstFun.declarations
    in
    let unsafeop op = AstFun.existsExpr (fun e ->
        match E.unfix e with
        | E.BinOp (a, op, b) -> isSideEffect side_effects a || isSideEffect side_effects b
        | _ -> false
      ) prog.AstFun.declarations
    in
    let need_readint = Ast.TypeSet.mem (Type.integer) prog.AstFun.options.AstFun.reads in
    let ifm = prog.AstFun.options.AstFun.hasSkip || need_readint || AstFun.existsExpr (fun e ->
        match E.unfix e with
        | E.If (a, b, c) -> isSideEffect side_effects a || isSideEffect side_effects b || isSideEffect side_effects c
        | _ -> false
      ) prog.AstFun.declarations in
    let read_array = AstFun.existsExpr (fun e ->match E.unfix e with
        | E.ArrayAccess _ -> true
        | _ -> false ) prog.AstFun.declarations in
    let write_array = AstFun.existsExpr (fun e ->match E.unfix e with
        | E.ArrayAffect _ -> true
        | _ -> false ) prog.AstFun.declarations in
    let array_init = AstFun.existsExpr (fun e ->match E.unfix e with
        | E.ArrayInit _ -> true
        | _ -> false ) prog.AstFun.declarations in
    let array_make = AstFun.existsExpr (fun e ->match E.unfix e with
        | E.ArrayMake _ -> true
        | _ -> false ) prog.AstFun.declarations in
    Format.fprintf f "%a@\n@[%a@]@\n"
      (header (unsafeop Ast.Expr.And) (unsafeop Ast.Expr.Or) array_init array_make ifm read_array write_array) prog.AstFun.options
      (print_list (fun f g -> g f) sep_nl) (List.rev liitems)

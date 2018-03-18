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
 *
 *)

(** Forth Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Helper
open Ast

let is_string tyenv a =
  match Typer.get_type_a tyenv a |> Type.unfix with
  | Type.String -> true
  | _ -> false
let print_access f access = Format.fprintf f (if access then " @@" else "")
let print_access_double f access = Format.fprintf f (if access then " 2@@" else "")
let print_mut0 tyenv annot m f access =
  let open Format in
  let open Mutable in match m with
  | Var v -> print_varname f v
  | Array (m, li) ->
    if is_string tyenv annot then
      match List.rev li with
      | hd::tl ->
        fprintf f "%a %a %a cells 2 * + %a" m true
          (print_list (fun f a -> fprintf f "%a cells + @@" a ()) (sep "%a %a")) (List.rev tl)
          hd ()
          print_access_double access
      | [] -> assert false
    else
      begin match List.rev li with
        | hd::tl ->
          fprintf f "%a %a %a cells + %a" m true
            (print_list (fun f a -> fprintf f "%a cells + @@" a ()) (sep "%a %a")) (List.rev tl)
            hd ()
            print_access access
        | [] -> assert false
      end
  | Dot (m, field) ->
    if is_string tyenv annot then
      fprintf f "%a ->%s%a" m true field print_access_double access
    else fprintf f "%a ->%s%a" m true field print_access access

let print_mut tyenv m f b = Mutable.Fixed.Deep.folda (print_mut0 tyenv) m f b

let mut_set tyenv f mut =
  match Typer.get_type_a tyenv (Mutable.Fixed.annot mut) |> Type.unfix with
  | Type.String -> begin match Mutable.unfix mut with
      | Mutable.Var v -> Format.fprintf f "2TO %a" print_varname v
      | _ -> Format.fprintf f "%a 2!" (print_mut tyenv mut) false
    end
  | _ -> match Mutable.unfix mut with
    | Mutable.Var v -> Format.fprintf f "TO %a" print_varname v
    | _ -> Format.fprintf f "%a !"(print_mut tyenv mut) false


let print_op f op = let open Expr in Format.fprintf f "%s"
    (match op with
     | Add -> "+"
     | Sub -> "-"
     | Mul -> "*"
     | Div -> "//"
     | Mod -> "%"
     | Or -> "OR"
     | And -> "AND"
     | Lower -> "<"
     | LowerEq -> "<="
     | Higher -> ">"
     | HigherEq -> ">="
     | Eq -> "="
     | Diff -> "<>")

let pprint_string f s =
  let s = " " ^ s in
  let s = Printf.sprintf "%S" s in
  Format.fprintf f (if String.exists ((=) '\\') s then "S\\%s" else "S%s") s

let print_lief f =
  let open Expr in
  let open Format in function
    | String s -> pprint_string f s
    | Char c -> let ci = int_of_char c in
      if ci >= 48 && ci <= 127 then fprintf f "[char] %c" c
      else fprintf f "%d" ci
    | Bool true -> fprintf f "true"
    | Bool false -> fprintf f "false"
    | Enum e -> fprintf f "%s" e
    | Integer i -> fprintf f "%i" i
    | Nil -> fprintf f "0"


let print_expr0 tyenv macros e f prio_parent =
  let open Expr in
  let open Format in
  match e with
  | BinOp (a, op, b) -> fprintf f "%a %a %a" a () b () print_op op
  | UnOp (a, Not) -> fprintf f "%a INVERT" a ()
  | UnOp (a, Neg) -> fprintf f "%a NEGATE" a ()
  | Just a -> fprintf f "%a HERE SWAP ," a ()
  | Lief l -> print_lief f l
  | Access m -> print_mut tyenv m f true
  | Call (func, li) ->
    begin match StringMap.find_opt func macros with
      | Some ( (t, params, code) ) ->
        pmacros f "%s" t params code li ()
      | None -> fprintf f "%a %s" (print_list (fun f x -> x f ()) sep_space) li func
    end
  | Lexems li -> assert false
  | Tuple li -> assert false
  | Record li -> assert false

let print_expr tyenv macros e f () = Expr.Fixed.Deep.fold (print_expr0 tyenv macros) e f ()

let ptypename f t = match Type.unfix t with
  | Type.Named n -> Format.fprintf f "%s%%" n
  | _ -> assert false

let print_instr tyenv macros i =
  let open Ast.Instr in
  let open Format in
  let block_ndrop ndrop f li = print_list (fun f i -> i f ndrop) sep_nl f li in
  let readtype f t = match Type.unfix t with
    | Type.Integer -> fprintf f "read-int"
    | Type.Char -> fprintf f "read-char"
    | _ -> assert false in
  let p f ndrop =
    let block = block_ndrop ndrop in
    match i with
    | Incr _
    | Decr _ -> assert false
    | Declare (var, ty, e, _) -> fprintf f "@[<hov>%a@ { %a }@]" e () print_varname var
    | SelfAffect (mut, op, e) ->  assert false
    | Affect (mut, e) -> fprintf f "%a %a" e () (mut_set tyenv) mut
    | ClikeLoop (init, cond, incr, li) -> assert false
    | Loop (var, e1, e2, li) ->
      fprintf f "@[<v 2>@[<h>%a %a BEGIN 2dup >= WHILE DUP { %a }@]@\n%a@]@\n 1 + REPEAT 2DROP"
        e2 () e1 () print_varname var
        (block_ndrop (ndrop + 2)) li
    | While (e, li) -> fprintf f "@[<v 2>BEGIN@\n%a@]@\n@[<v 2>WHILE@\n%a@]@\nREPEAT" e () block li
    | Comment s -> 
      let lic = String.split s '\n' in
      print_list (fun f s -> fprintf f "\\ %s@\n" s) nosep f lic
    | Tag s -> assert false
    | Return e -> fprintf f "@[<hov>%a%a exit@]" (print_ntimes ndrop) "DROP " e ()
    | AllocArray (name, t, e, None, opt) ->
      if Tags.is_taged "use_count" then
        begin match Type.unfix t with
          | Type.String -> fprintf f "@[<h>%a dup HERE SWAP 2 * 1 + cells allot dup -rot ! 1 + { %a }@]" e () print_varname name
          | _ -> fprintf f "@[<h>%a dup HERE SWAP 1 + cells allot dup -rot ! 1 cells + { %a }@]" e () print_varname name
        end
      else
        begin match Type.unfix t with
          | Type.String -> fprintf f "@[<h>HERE %a cells 2 * allot { %a }@]" e () print_varname name
          | _ -> fprintf f "@[<h>HERE %a cells allot { %a }@]" e () print_varname name
        end
    | AllocArray (name, t, e, Some (var, lambda), opt) -> assert false
    | AllocArrayConst (name, ty, len, lief, opt) -> assert false
    | AllocRecord (name, ty, list, opt) -> fprintf f "%a %%allot { %a }@\n%a"
                                             ptypename ty
                                             print_varname name
                                             (print_list
                                                (fun t (fieldname, expr) ->
                                                   fprintf f (match Typer.child_type_of_field tyenv fieldname Ast.Location.default |> Type.unfix with
                                                       | Type.String -> "%a %a ->%s 2!"
                                                       | _ -> "%a %a ->%s !")
                                                     expr () print_varname name fieldname
                                                ) sep_nl)
                                             list
    | If (e, listif, []) -> fprintf f "%a@\n@[<v 2>IF@\n%a@]@\nTHEN"
                              e () block listif
    | If (e, listif, listelse) -> fprintf f "%a@\n@[<v 2>IF@\n%a@]@\n@[<v 2>ELSE@\n%a@]@\nTHEN"
                                    e () block listif block listelse
    | Call (func, li) -> begin match StringMap.find_opt func macros with
        | Some ( (t, params, code) ) -> pmacros f "%s" t params code li ()
        | None -> fprintf f "%a %s" (print_list (fun f x -> x f ()) sep_space) li func
      end
    | Print li->
      let li = List.map (fun i f -> match i with
          | StringConst s -> fprintf f "@[%a TYPE@]" pprint_string s
          | PrintExpr (ty, expr) -> match Type.unfix ty with
            | Type.Char -> fprintf f "@[%a EMIT@]" expr ()
            | Type.String -> fprintf f "@[%a TYPE@]" expr ()
            | Type.Integer -> fprintf f "@[%a s>d 0 d.r@]" expr ()
            | _ -> assert false
        ) li in
      print_list (fun f g -> g f) sep_nl f li
    | Read li ->
      let li = List.map (fun i f -> match i with
          | Separation -> fprintf f "skipspaces"
          | DeclRead (t, name, _) ->fprintf f "@[%a { %a }@]" readtype t print_varname name
          | ReadExpr (t, mut) -> fprintf f "@[%a %a@]" readtype t (mut_set tyenv) mut) li in
      print_list (fun f e -> e f) sep_nl f li
    | Untuple (li, expr, opt) -> assert false
    | Unquote e -> assert false in p

let print_instr tyenv macros i =
  let open Ast.Instr.Fixed.Deep in
  let p = (fold (print_instr tyenv macros) (mapg (print_expr tyenv macros) i))
  in fun f -> p f 0


let decl_type f (name, t) =
    match (Type.unfix t) with
    | Type.Struct li ->
      Format.fprintf f "@[<v 2>struct@\n%a@]@\nend-struct %s%%@\n"
        (print_list
           (fun t (name, type_) ->
              match Type.unfix type_ with
              | Type.String -> Format.fprintf t "double%% field ->%s" name
              | _ -> Format.fprintf t "cell%% field ->%s" name
           ) sep_nl
        ) li name
    | Type.Enum li ->
      print_list_indexed
        (fun t name index -> Format.fprintf t "%d constant %s" index name
        ) sep_nl
        f li
    | _ -> ()


let prog recursives_definitions typerEnv f (prog: Utils.prog) =
    let instructions macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "fs" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> print_instr typerEnv macros t f) sep_nl f li in
    let print_fun macros f funname li instrs =
      Format.fprintf f "@[<hov>: %s%a { %a }@]@\n@[<v 2>  %a@]@\n;@\n@\n" funname
        (fun f () -> if StringSet.mem funname recursives_definitions then
            Format.fprintf f " recursive") ()
        (print_list (fun f (n, t) ->
             match Type.unfix t with
             | Type.String -> Format.fprintf f "D: %a" print_varname n
             | _ -> print_varname f n)
            sep_space) li
        (instructions macros) instrs
    in
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment s ->
             macros, (fun f -> let lic = String.split s '\n' in
             print_list (fun f s -> Format.fprintf f "\\ %s@\n" s) nosep f lic) :: li
           | Prog.DeclarFun (var, t, vars, instrs, _opt) ->
             macros, (fun f -> print_fun macros f var vars instrs) :: li
           | Prog.DeclareType (name, t) -> macros, (fun f -> Format.fprintf f "%a@\n" decl_type (name, t)) :: li
           | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    Format.fprintf f "%a%a%a%a%a%a%a%a%a@\nmain@\nBYE@\n"
      (fun f () ->
         if Tags.is_taged "use_count" then
           Format.fprintf f ": cnt { a } a 1 cells - @@ ;@\n"
      ) ()
      (fun f () ->
         if Tags.is_taged "__internal__div" then
           Format.fprintf f ": // { a b } a b / a 0 < b 0 < XOR IF 1 + THEN ;@\n") ()
      (fun f () ->
         if Tags.is_taged "__internal__mod" then
           Format.fprintf f ": %% { a b } a b MOD a 0 < b 0 < XOR IF b - THEN ;@\n" ) ()
      (fun f () -> if need then
          print_list (fun f s -> if need then Format.fprintf f "%s@\n" s) nosep f
            ["VARIABLE buffer-index";
             "1000 buffer-index !";
             "VARIABLE NEOF";
             "1 NEOF !";
             "VARIABLE buffer-max";
             "0 buffer-max !";
             "create bufferc 128 allot";
             ": next-char";
             "  buffer-index @ 1 + buffer-index !";
             "  buffer-index @ buffer-max @ > IF";
             "    0 buffer-index !";
             "    bufferc 128 stdin read-line DROP -1 = NEOF ! buffer-max !";
             "    10 bufferc buffer-max @ + !";
             "  THEN ;";
             ": current-char";
             "  buffer-index @ buffer-max @ > IF next-char THEN";
             "  bufferc buffer-index @ + c@ ;"
            ]
      ) ()
      (fun f () -> if need_stdinsep then print_list (fun f s -> Format.fprintf f "%s@\n" s) nosep f
            [": skipspaces";
             "  BEGIN NEOF @ current-char 13 = current-char 32 = OR current-char 10 = OR AND";
             "  WHILE next-char REPEAT ;"]) ()
      (fun f () -> if need_readint then print_list (fun f s -> Format.fprintf f "%s@\n" s) nosep f
            [ ": read-int";
              "  [char] - current-char = IF -1 next-char ELSE 1 THEN";
              "  0 BEGIN current-char [char] 0 >= current-char [char] 9 <= AND";
              "  WHILE 10 * current-char [char] 0 - + next-char REPEAT * ;"
            ]) ()
      (fun f () -> if need_readchar then Format.fprintf f ": read-char current-char next-char ;@\n") ()
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f main -> Format.fprintf f "@[<v 2>: main@\n%a@\n;@]" (instructions macros) main))
      prog.Prog.main



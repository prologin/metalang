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


(** Evaluation module
    This module is used for :
    - macro evaluation / inlining (code generation)
    - standalone programm evaluation
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ast
open Ext
open Warner

(** The environment functions used by evaluator.
    it's a parameter for evaluator. There is now two kind of
    parameters : a console environement and a javascript environment.
*)
module type EvalIO = sig
  (** show an integer*)
  val print_int : int -> unit
  (** show a char *)
  val print_char : char -> unit
  (** show a string *)
  val print_string : string -> unit
  (** show a boolean *)
  val print_bool : bool -> unit
  (** read an integer from stdin *)
  val read_int : unit -> int
  (** skip spaces in stdin *)
  val skip : unit -> unit
  (** read a char from stdin *)
  val read_char : unit -> char
end


(*
  module StringMap = struct
  module H = Hashtbl.Make (struct
  type t = string
  let equal = ( = )
  let hash = Hashtbl.hash
  end)

  type 'a t = 'a H.t
  let empty () = H.create 0
  let add x v h = H.add h x v ; h
  let find x h = H.find h x
  end
*)

(** the kind of values manipulated by the evaluator *)
type result =
  | Integer of int
  | Bool of bool
  | Char of char
  | String of string
  | Record of result array
  | Array of result array
  | Option of result option
  | Lexems of Parser.token list
  | Tuple of result array
  | Nil

(** we return a value *)
exception Return of result

(** show the type of a value *)
let typeof = function
  | Integer _ -> "int"
  | Bool _ -> "bool"
  | Char _ -> "char"
  | String _ -> "string"
  | Record _ -> "record"
  | Option _ -> "option"
  | Array _ -> "array"
  | Nil -> "Nil"
  | Lexems _ -> "Lexems"
  | Tuple _ -> "Tuple"

(** extract an ocaml array from a value *)
let get_tuple = function
  | Tuple a -> a
  | x -> raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected tuple" (typeof x)))

(** extract an ocaml array from a value *)
let get_array = function
  | Array a -> a
  | x -> raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected array" (typeof x)))

(** extract an ocaml integer from a value *)
let get_integer = function
  | Integer a -> a
  | x ->
    raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected int" (typeof x)))

(** extract an ocaml char from a value *)
let get_char = function
  | Char a -> a
  | x ->
    raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected char" (typeof x)))

(** extract an ocaml string from a value *)
let get_string = function
  | String a -> a
  | x ->
    raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected string" (typeof x)))

(** extract an ocaml boolean from a vlaue *)
let get_bool = function
  | Bool a -> a
  | x -> raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected bool" (typeof x)))

let err_token_expected x = raise (Warner.Error (fun f -> Format.fprintf f "Got %s expected token list" (typeof x)))

let err_bad_arg_number s n1 n2 = raise (Warner.Error (fun f -> Format.fprintf f "Bad number of arguments %S : %d vs %d@\n" s n1 n2))

let pvar f = function
  | UserName n -> Format.fprintf f "%S" n
  | InternalName i -> Format.fprintf f "internal(%d)" i

(** extract an ocaml token list from a value *)
let get_tokens = function
  | Lexems a -> a
  | Bool false -> [ Parser.FALSE ]
  | Bool true -> [ Parser.TRUE ]
  | Integer i -> [ Parser.INT i ]
  | Char c -> [ Parser.CHAR c ]
  | x -> err_token_expected x

(** execution environment *)
type execenv = result array

(** compilation environment *)
type  env = {
  nvars : int;
  vars : int BindingMap.t;
  functions :
    (int * (execenv -> unit) ) ref
      StringMap.t;
  tyenv : Typer.env;
}

(** precompiled expression *)
and precompiledExpr =
  | Result of result
  | WithEnv of (execenv -> result)

(** get a list of lexems *)
let flatten_lexems li =
  List.fold_left (fun acc li ->
      match (acc, li) with
      | Result r1, Result r2 ->
        let l1 = get_tokens r1
        and l2 = get_tokens r2 in Result (Lexems (List.append l1 l2))
      | WithEnv f, Result r2 ->
        let li2 = get_tokens r2 in
        WithEnv (fun execenv ->
            let li1 = f execenv |> get_tokens in
            Lexems (List.append li1 li2)
          )
      | Result r1, WithEnv f ->
        let li1 = get_tokens r1 in
        WithEnv (fun execenv ->
            let li2 = f execenv |> get_tokens in
            Lexems (List.append li1 li2)
          )
      | WithEnv f1, WithEnv f2 ->
        WithEnv (fun execenv ->
            let li1 = f1 execenv |> get_tokens in
            let li2 = f2 execenv |> get_tokens in
            Lexems (List.append li1 li2)
          )
    ) (Result (Lexems []))  li

(** returns an empty environment
    @param te : the typer environment
*)
let empty_env te =
  {
    tyenv = te;
    nvars = 0;
    vars = BindingMap.empty;
    functions = StringMap.empty;
  }

(** eval an expression *)
let eval_expr execenv (e : precompiledExpr) :  result = match e with
  | Result r -> r
  | WithEnv f -> f execenv

(** throw a type error*)
let tyerr loc =
  raise (Error (fun f -> Format.fprintf f "Type error %a\n%!" Ast.Location.pp loc))

(** numeric operator process *)
let num_op loc ( + ) ( +. ) a b =
  match a, b with
  | Result a, Result b ->
    Result begin match a, b with
      | Integer i, Integer j -> Integer (i + j)
      | _ -> tyerr loc
    end
  | WithEnv a, Result b ->
    begin match b with
      | Integer j -> WithEnv (fun execenv ->
          Integer ((get_integer (a execenv)) + j))
      | _ -> tyerr loc
    end
  | Result b, WithEnv a ->
    begin match b with
      | Integer i -> WithEnv (fun execenv ->
          Integer (i + (get_integer (a execenv))))
      | _ -> tyerr loc
    end
  | WithEnv a, WithEnv b ->
    WithEnv (fun execenv ->
        match a execenv, b execenv with
        | Integer i, Integer j -> Integer (i + j)
        | _ -> tyerr loc
      )
(** integer operator *)
let int_op loc f a b = num_op loc f (fun _ _ -> tyerr loc) a b

(** comparaison type : powerfull for forall *)
type compare = { cmp : 'a . 'a -> 'a -> bool }

(** value comparaison *)
let num_cmp f =
  let (<) = f.cmp in
  fun loc a b ->
    match a, b with
    | Result ra, Result rb ->
      Result
        (match ra, rb with
         | Integer i, Integer j -> Bool (i < j)
         | Bool i, Bool j -> Bool ( i < j)
         | Char i, Char j -> Bool ( i < j)
         | _ -> tyerr loc)
    | WithEnv fa, WithEnv fb ->
      WithEnv (fun execenv ->
          let a = fa execenv in
          let b = fb execenv in
          match a, b with
          | Integer i, Integer j -> Bool (i < j)
          | Bool i, Bool j -> Bool ( i < j)
          | Char i, Char j -> Bool ( i < j)
          | _ -> tyerr loc)
    | WithEnv fa, Result rb ->
      begin match rb with
        | Integer j -> WithEnv (fun execenv ->
            match fa execenv with
            | Integer i -> Bool (i < j)
            | _ -> tyerr loc
          )
        | Bool j -> WithEnv (fun execenv ->
            match fa execenv with
            | Bool i -> Bool (i < j)
            | _ -> tyerr loc
          )
        | Char j -> WithEnv (fun execenv ->
            match fa execenv with
            | Char i -> Bool (i < j)
            | _ -> tyerr loc
          )
        | _ -> tyerr loc
      end
    | Result ra, WithEnv fb ->
      begin match ra with
        | Integer i -> WithEnv (fun execenv ->
            match fb execenv with
            | Integer j -> Bool (i < j)
            | _ -> tyerr loc
          )
        | Bool i -> WithEnv (fun execenv ->
            match fb execenv with
            | Bool j -> Bool (i < j)
            | _ -> tyerr loc
          )
        | Char i -> WithEnv (fun execenv ->
            match fb execenv with
            | Char j -> Bool (i < j)
            | _ -> tyerr loc
          )
        | _ -> tyerr loc
      end

(** binary operations *)
let binop =
  let leq = num_cmp { cmp = ( <= ) }  in
  let le = num_cmp { cmp = ( < ) } in
  let heq = num_cmp { cmp = ( >= ) } in
  let he = num_cmp { cmp = ( > ) } in
  let eq = num_cmp { cmp = ( = ) } in
  let diff = num_cmp { cmp = ( <> ) } in
  fun loc op a b -> match op with
    | Expr.Add -> num_op loc ( + ) ( +. ) a b
    | Expr.Sub -> num_op loc ( - ) ( -. ) a b
    | Expr.Mul -> num_op loc ( * ) ( *. ) a b
    | Expr.Div -> num_op loc ( / ) ( /. ) a b
    | Expr.Mod -> int_op loc ( mod ) a b
    | Expr.LowerEq -> leq loc a b
    | Expr.Lower -> le loc a b
    | Expr.HigherEq -> heq loc a b
    | Expr.Higher -> he loc a b
    | Expr.Eq -> eq loc a b
    | Expr.Diff -> diff loc a b
    | Expr.Or ->
      begin match a with
        | Result r -> if get_bool r then a else b
        | WithEnv f -> WithEnv (fun execenv ->
            let r = f execenv in
            if get_bool r
            then r
            else eval_expr execenv b)
      end
    | Expr.And ->
      begin match a with
        | Result r -> if get_bool r then b else a
        | WithEnv f -> WithEnv (fun execenv ->
            let r = f execenv in
            if get_bool r
            then eval_expr execenv b
            else r)
      end

(** environment factory *)
let init_eenv nvars = Array.make nvars Nil

(** find a variable position in the environment *)
let find_in_env (env:env) v : int =
  BindingMap.find v env.vars

(** add a variable in the environment *)
let add_in_env (env:env) v : env * int =
  let out = env.nvars in
  {
    env with
    nvars = out + 1;
    vars = BindingMap.add v out env.vars
  }, out

(** find the index of a field in a record value *)
let index_for_field env field loc =
  match Type.unfix (Typer.type_of_field env.tyenv field loc) with
  | Type.Struct li ->
    let li = List.map fst li |> List.sort String.compare in
    List.indexof field li
  | _ -> raise (Error (fun f ->
      Format.fprintf f "type error : waiting for field %s" field
    ))

(** return a constructed structure from a token list *)
let of_lexems_list rule_ f (li:Parser.token list) =
  let lexbuf = ref li in
  try
    f (fun _ ->
        match !lexbuf with
        | [] -> Parser.EOF
        | hd::tl ->
          let () = lexbuf := tl in
          hd
      ) (Lexing.from_string "")
  with Parser.Error ->
    raise (Error (fun f ->
        Format.fprintf f "parser error (%s) : %a@\n" rule_ Utils.string_of_lexems li
      ))

(** returns an expression from a token list *)
let expr_of_lexems_list (li:Parser.token list) : Utils.expr =
  of_lexems_list "expr" Parser.toplvl_expr li

(** returns a toplvl expression from a token list *)
let prog_list_of_lexems_list (li:Parser.token list) : Utils.t_fun list =
  of_lexems_list "prog" Parser.toplvls li

(** returns an instruction from a token list *)
let instrs_of_lexems_list (li:Parser.token list) : Utils.instr list =
  of_lexems_list "instrs" Parser.toplvl_instrs li

(** Evaluation factor *)
module EvalF (IO : EvalIO) = struct

  let precompile_lief env = function
    | Expr.Char c -> Char c
    | Expr.String s -> String s
    | Expr.Integer i -> Integer i
    | Expr.Bool b -> Bool b
    | Expr.Nil -> Option None
    | Expr.Enum e ->
      let t = Typer.type_for_enum e env.tyenv in
      begin match Type.unfix t with
        | Type.Enum li ->
          let rec f n = function
            | [] -> assert false
            | hd::tl -> if String.equals hd e then n else
                f (n + 1) tl in
          let v = f 0 li in
          Integer v
        | _ -> assert false
      end

  (** execute a call *)
  let eval_call env name params : execenv -> result =
    try
      let r = StringMap.find name env.functions in
      let params = Array.of_list params in
      let nparams = Array.length params - 1 in
      (fun ex_execenv ->
         let (nvars, instrs) = !r in
         if nvars < (Array.length params) then
           err_bad_arg_number name nvars (Array.length params);
         let eenv:execenv = init_eenv nvars in
         let () = for i = 0 to nparams do
             eenv.(i) <- eval_expr ex_execenv params.(i)
           done
         in try
           instrs eenv; Nil
         with Return e -> e
      )
    with Not_found ->
      (fun execenv ->
         match name, (List.map (eval_expr execenv) params) with
         | "int_of_char", [param] ->
           Integer (int_of_char (get_char param))
         | "char_of_int", [param] ->
           Char (char_of_int (get_integer param))
         | "sqrt_", [param] ->
           Integer (int_of_float (sqrt (float_of_int (get_integer param))))
         | "count_", [param] ->
           Integer (Array.length (get_array param))
         | _ -> failwith ("The Macro "^name^" cannot be evaluated with"
                          ^(string_of_int (List.length params))^" arguments")
      )

  let mut_val (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result =
    let loc = Ast.PosMap.get (Mutable.Fixed.annot mut) in
    Mutable.Fixed.Deep.fold (function
        | Mutable.Var v ->
          begin try
              let out = BindingMap.find v env.vars in fun execenv ->
                execenv.(out)
            with Not_found ->
              let loc = Ast.PosMap.get (Mutable.Fixed.annot mut) in
              raise (Error (fun f -> Format.fprintf f "Cannot find var %a %a\n" pvar v Ast.Location.pp loc))
          end
        | Mutable.Array (m, li) ->
          List.fold_left
            (fun m index execenv ->
               (get_array (m execenv)).(get_integer (eval_expr execenv index))
            )
            m
            li
        | Mutable.Dot (m, field) ->
          let index = index_for_field env field loc in
          (fun execenv ->
             match m execenv with
             | Record map ->
               map.(index)
             | x ->
               raise (Error (fun f -> Format.fprintf f "Got %s expected Record\n" (typeof x)))
          )) mut

  (** precompile an expression *)
  let rec precompile_expr (t:Utils.expr) (env:env): precompiledExpr =
    let loc = PosMap.get (Expr.Fixed.annot t) in
    let res x = Result x in
    Expr.Fixed.Deep.fold (function
        | Expr.Just (Result r) -> Result (Option (Some r))
        | Expr.Just (WithEnv r) -> WithEnv (fun execenv -> Option (Some (r execenv)))
        | Expr.Lief l -> precompile_lief env l |> res
        | Expr.BinOp (a, op, b) ->
          binop loc op a b
        | Expr.UnOp (Result r, Expr.Neg) ->
          Integer (- (get_integer r  ) ) |>  res
        | Expr.UnOp (WithEnv f, Expr.Neg) ->
          WithEnv (fun execenv ->
              Integer (- (get_integer (f execenv)))
            )
        | Expr.UnOp (Result r, Expr.Not) ->
          Bool (not (get_bool r ) ) |> res
        | Expr.UnOp (WithEnv f, Expr.Not) ->
          WithEnv (fun execenv ->
              Bool (not (get_bool (f execenv)))
            )
        | Expr.Access mut ->
          let mut = mut_val env mut in
          WithEnv (fun execenv ->  mut execenv)
        | Expr.Tuple t ->
          WithEnv (fun execenv ->
              let t = List.map (function
                  | Result r -> r
                  | WithEnv f -> f execenv) t in
              (Tuple ( Array.of_list t ))
            )
        | Expr.Record fields ->
          let fields = List.map (fun (name, e) ->
              index_for_field env name loc, e) fields in
          let index, fields = List.unzip fields in
          let index = Array.of_list index in
          let fields = Array.of_list fields in
          let len = Array.length fields in
          let f execenv =
            let record = Array.make len Nil in
            let () = for i = 0 to len - 1 do
                let index = index.(i) in
                let e = fields.(i) in
                let e = eval_expr execenv e in
                record.(index) <- e
              done
            in Record record
          in WithEnv f
        | Expr.Call (name, params) ->
          let call = eval_call env name params  in
          WithEnv (fun execenv ->
              call execenv
            )
        | Expr.Lexems l -> precompiledExpr_of_lexems_list l env ) t
  (** precompile an expression from a token list *)
  and precompiledExpr_of_lexems_list li (env:env): precompiledExpr =
    let li = List.map (fun l -> match Lexems.unfix l with
        | Lexems.Expr e -> e
        | Lexems.Token t -> Result (Lexems [t])
        | Lexems.UnQuote e ->
          let li = precompiledExpr_of_lexems_list e env in
          match li with
          | Result r ->
            let li = get_tokens r in
            let e = expr_of_lexems_list li
            in precompile_expr e env
          | WithEnv f ->
            WithEnv (fun execenv ->
                let li = get_tokens (f execenv) in
                let e = expr_of_lexems_list li in
                let r = precompile_expr e env in
                eval_expr execenv r
              )
      ) li
    in flatten_lexems li

  let mut_setval (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result -> unit =
    let loc = Ast.PosMap.get (Mutable.Fixed.annot mut) in
    match Mutable.unfix mut with
    | Mutable.Var v ->
      begin try
          let out = BindingMap.find v env.vars in fun execenv v->
            execenv.(out) <- v
        with Not_found ->
          raise (Error (fun f ->
              let loc = Ast.PosMap.get (Mutable.Fixed.annot mut) in
              Format.fprintf f "Cannot find var %a %a\n" pvar v Ast.Location.pp loc ))
      end
    | Mutable.Array (m, li) ->
      let m, index = match List.rev li with
        | [] -> raise (Error (fun f ->
            Format.fprintf f "Cannot find array indexes\n"))
        | [index] -> mut_val env m, index
        | index::tl ->
          let tl = List.rev tl in
          let m = mut_val env (Mutable.fix (Mutable.Array (m, tl)) ) in
          m, index
      in
      (fun execenv v ->
         (get_array (m execenv)).
           (get_integer (eval_expr execenv index)) <- v)
    | Mutable.Dot (m, field) ->
      let index = index_for_field env field loc in
      let m = mut_val env m in
      (fun execenv v ->
         match m execenv with
         | Record map ->
           map.(index) <- v
         | x ->
           raise (Error (fun f -> Format.fprintf f "Got %s expected Record\n" (typeof x)))
      )

  (** instruction evaluator : returns a tuple (environment * execution
      lambda )
  *)
  let rec eval_instr env (instr: (env -> precompiledExpr) Instr.t) :
    (env * (execenv -> unit))
    =
    let loc = Ast.PosMap.get (Instr.Fixed.annot instr) in
    match Instr.unfix instr with
    | Instr.Untuple (li, e, _) ->
      let li = List.map snd li in
      let e = e env in
      let env, li = List.fold_left_map add_in_env env li in
      let f execenv =
        let e = get_tuple ( eval_expr execenv e ) in
        List.iteri (fun i r ->
            execenv.(r) <- e.(i)
          ) li
      in env, f
    | Instr.Declare (varname, _, e, _) ->
      let e = e env in
      let env, r = add_in_env env varname in
      let f execenv =
        execenv.(r) <- eval_expr execenv e
      in env, f
    | Instr.Affect (mutable_, e) ->
      let mutable_ = Mutable.Fixed.Deep.mapg (fun f -> f env) mutable_ in
      let mut = mut_setval env mutable_ in
      let e = e env in
      env, (fun execenv -> mut execenv (eval_expr execenv e))
    | Instr.SelfAffect (mutable_, op, e) ->
      let mutable_ = Mutable.Fixed.Deep.mapg (fun f -> f env) mutable_ in
      let setmut = mut_setval env mutable_ in
      let getmut = mut_val env mutable_ in
      let e = e env in
      let binop = binop loc op (WithEnv getmut) e in
      env, (fun execenv -> setmut execenv (eval_expr execenv binop))
    | Instr.Loop (varname, e1, e2, instrs) ->
      let e1 = e1 env in
      let e2 = e2 env in
      let env, mut = add_in_env env varname in
      let env, instrs = eval_instrs env instrs in
      let f execenv =
        let e1 = eval_expr execenv e1 in
        let e2 = eval_expr execenv e2 in
        let rec f e =
          let () = execenv.(mut) <- e in
          if (get_integer e) > (get_integer e2) then ()
          else
            let () = instrs execenv in
            f (Integer (1 + (get_integer e)))
        in f e1
      in env, f
    | Instr.While (e, instrs) ->
      let env, instrs = eval_instrs env instrs in
      let e = e env in
      let rec f execenv =
        let e = eval_expr execenv e in
        if get_bool e then
          let () = instrs execenv
          in f execenv
        else ()
      in env, f
    | Instr.Comment _ -> env, fun execenv -> ()
    | Instr.Return e ->
      let e = e env in
      env, fun execenv -> raise (Return (eval_expr execenv e))
    | Instr.AllocArrayConst (var, t, e, lief, _) ->
      let e = e env in
      let env, r = add_in_env env var in
      let l = precompile_lief env lief in
      env, (fun execenv ->
          let len = get_integer (eval_expr execenv e) in
          execenv.(r) <- Array (Array.make len l)
        )
    | Instr.AllocArray (var, t, e, opt, _) ->
      let e = e env in
      begin match opt with
        | None ->
          let env, r = add_in_env env var in
          env, (fun execenv ->
              let len = get_integer (eval_expr execenv e) in
              execenv.(r) <- Array (Array.make len Nil)
            )
        | Some ((name, lambda)) ->
          let env, rout = add_in_env env var in
          let env, rname = add_in_env env name in
          let env, instrs = eval_instrs env lambda in
          let f execenv =
            let len = get_integer (eval_expr execenv e) in
            execenv.(rout) <- Array (Array.init len (fun i ->
                let () = execenv.(rname) <- Integer i in
                try
                  instrs execenv; Nil
                with Return e -> e
              ))
          in env, f
      end
    | Instr.AllocRecord (var, t, fields, _) ->
      let fields = List.map (fun (name, e) ->
          index_for_field env name loc, e env) fields in
      let index, fields = List.unzip fields in
      let index = Array.of_list index in
      let fields = Array.of_list fields in
      let len = Array.length fields in
      let env, r = add_in_env env var in
      let f execenv =
        let record = Array.make len Nil in
        let () = for i = 0 to len - 1 do
            let index = index.(i) in
            let e = fields.(i) in
            let e = eval_expr execenv e in
            record.(index) <- e
          done
        in execenv.(r) <- (Record record)
      in env, f
    | Instr.If (e, l1, l2) ->
      let e = e env in
      let env, l1 = eval_instrs env l1 in
      let env, l2 = eval_instrs env l2 in
      let f execenv =
        if get_bool (eval_expr execenv e)
        then l1 execenv
        else l2 execenv
      in env, f
    | Instr.Call (funname, el) ->
      let el = List.map (fun f -> f env) el in
      let call = eval_call env funname el in
      let f execenv =
        let _ = call execenv in ()
      in env, f
    | Instr.Print li ->
      let env, f = List.fold_left (fun (env, f) -> function
          | Instr.StringConst str ->
            env, (fun execenv ->
                let () = f execenv in
                print Type.string (String str))
          | Instr.PrintExpr (t, e) ->
            let e = e env in
            let f execenv =
              let () = f execenv in
              let e = eval_expr execenv e in
              print t e
            in env, f) (env, (fun _ -> ())) li
      in env, f
    | Instr.Read li ->
      let env, f = List.fold_left (fun (env, f) -> function
          | Instr.Separation ->
            let f execenv = f execenv; IO.skip () in
            env, f
          | Instr.DeclRead (t, var, _) ->
            let env, r = add_in_env env var in
            env, (fun execenv -> read t (fun v -> execenv.(r) <- v))
          | Instr.ReadExpr (t, mut) ->
            let mut = Mutable.Fixed.Deep.mapg (fun f -> f env) mut in
            let mut = mut_setval env mut
            in env, (fun execenv ->
                f execenv;
                read t (fun value -> mut execenv value))) (env, (fun _ -> ())) li
      in env, f
    | Instr.Incr _ | Instr.Decr _ | Instr.ClikeLoop _ -> assert false
    | Instr.Tag _ -> env, (fun _ -> ())
    | Instr.Unquote li -> assert false
  and print ty e =
    (** show the value e. it has the type ty*)
    let () = match Type.unfix ty with
      | Type.Array(ty) ->
        let _ = Array.map (fun e -> print ty e) (get_array e) in ()
      | Type.Integer -> IO.print_int (get_integer e)
      | Type.Char -> IO.print_char (get_char e)
      | Type.Bool -> IO.print_bool (get_bool e)
      | Type.String -> IO.print_string (get_string e)
      | _ -> failwith ("cannot print type "^(Type.type_t_to_string ty))
    in ()
  and read ty k = match Type.unfix ty with
    (* read a value from the type ty and call the continuation k *)
    | Type.Integer -> k ( Integer (IO.read_int ()))
    | Type.Char -> k (Char (IO.read_char ()))
    | _ -> failwith ("cannot read type "^(Type.type_t_to_string ty))
  and eval_instrs env
      (** compute the instructions *)
      (instrs : (env -> precompiledExpr) Ast.Instr.t list)
    : env * (execenv -> unit) =
    let env, precompiled = List.fold_left_map
        (fun env instr ->
           eval_instr env instr
        )
        env instrs
    in let arr = Array.of_list precompiled
    in env, fun execenv ->
        Array.iter (fun f -> f execenv) arr

  (** precompile an instruction *)
  let precompile_instr i =
    Instr.Fixed.Deep.mapg precompile_expr i

  (** precompile a list of instructions*)
  let precompile_instrs li =
    List.map precompile_instr li

  (** compile a function into a lambda *)
  let compile_fun env var t li instrs =
    let nvars = List.length li in
    let thisfunc = ref (0, fun _ -> ()) in
    let env = {env with
               nvars = nvars + 1;
               vars = List.fold_left
                   (fun (f, i) (v, _) ->
                      (BindingMap.add v i f), i+1
                   )
                   (BindingMap.empty, 0) li |> fst;
               functions =
                 StringMap.add var
                   thisfunc
                   env.functions
              }
    in
    let env, instrs = eval_instrs env (precompile_instrs instrs) in
    let () = thisfunc := (env.nvars, instrs)
    in env

  (** precompile and eval an expression *)
  let precompile_eval_expr (env:env) (e:Utils.expr) : result =
    let precompiled = precompile_expr e env in
    let execenv = init_eenv 0 in
    eval_expr execenv precompiled

  (** main function of this module : it evalue a full programm *)
  let eval_prog (te : Typer.env) (p:Utils.prog) =
    let f env p = match p with
      | Prog.Unquote _ -> assert false
      | Prog.DeclarFun (var, t, li, instrs, _) ->
        compile_fun env var t li instrs
      | Prog.DeclareType _ -> env
      | Prog.Macro (varname, t, li, impls) -> env
      | Prog.Comment s -> env

    in let env = List.fold_left f (empty_env te) p.Prog.funs
    in match p.Prog.main with
    | Some instrs ->
      let env, f = eval_instrs {env with nvars = 0} (precompile_instrs instrs)
      in f (init_eenv ( env.nvars + 1 ))
    | None -> ()
end

(** module for evaluation in console environment (stdin and stdout
    reading) *)
module E = struct
  let print_int i =
    Printf.printf "%d%!" i
  let print_char c = Printf.printf "%c%!" c
  let print_bool b =
    if b
    then Printf.printf "True"
    else Printf.printf "False"
  let print_string s =
    Printf.printf "%s%!" s
  let read_int () =
    Scanf.scanf "%d" (fun x -> x )
  let skip () =
    Scanf.scanf "%[\n \010]" (fun _ -> ())
  let read_char () =
    Scanf.scanf "%c" (fun x -> x)
end

module EVAL = EvalF(E)

let eval_prog t p = EVAL.eval_prog t p

(** this is a compilation pass : it evalue constant expressions.
    it process expressions like instant(foo)
*)
module EvalConstantes = struct

  let process_expr e acc =
    let f e acc = match e with
      | Expr.Call ("instant", [param]) ->
        let new_expr = match EVAL.precompile_eval_expr acc param with
          | Integer x -> Expr.integer x
          | Bool x -> Expr.bool x
          | Char x -> Expr.char x
          | String x -> Expr.string x
          | _ -> raise (Error (fun f -> Format.fprintf f "type error...")) (* TODO *)
        in acc, (Expr.unfix new_expr)
      | e -> acc, e
    in Expr.Fixed.Deep.foldmap_topdown f e acc

  let collect_instr acc (i:Utils.instr) =
    let f (i:Utils.instr) :
      (Utils.instr list) =
      match Instr.unfix i with
      | Instr.Unquote e ->
        begin match Expr.unfix e with
          | Expr.Lexems li ->
            let li = List.map
                (Lexems.Fixed.Deep.mapg (fun x -> EVAL.precompile_expr x acc)
                ) li in
            let execenv = init_eenv 0 in
            EVAL.precompiledExpr_of_lexems_list li acc
            |> eval_expr execenv |> get_tokens |> instrs_of_lexems_list
          | _ ->
            let execenv = init_eenv 0 in
            EVAL.precompile_expr e acc
            |> eval_expr execenv |> get_tokens |> instrs_of_lexems_list
        end
      | _ -> [i]
    in
    let g li = List.collect f li in
    let i = Instr.deep_map_bloc g (Instr.unfix i) |> Instr.fixa
              (Instr.Fixed.annot i) in
    let li = f i in
    List.fold_left_map (fun acc x -> Instr.Fixed.Deep.foldmapg process_expr x acc) acc li

  let process_main acc m =
    let acc, m = List.fold_left_map collect_instr acc m
    in acc, List.flatten m

  let rec process acc p =
    match p with
    | Prog.DeclarFun (funname, t, params, instrs, opt) ->
      let acc, instrs = List.fold_left_map collect_instr acc instrs in
      let instrs = List.flatten instrs in
      let acc = EVAL.compile_fun acc funname t params instrs in
      acc, [Prog.DeclarFun (funname, t, params, instrs, opt)]
    | Prog.Unquote e ->
      let w li =
        let li = prog_list_of_lexems_list li in
        let p, li = List.fold_left_map process acc li
        in p, List.flatten li
      in
      begin match Expr.unfix e with
        | Expr.Lexems li ->
          let li = List.map
              (Lexems.Fixed.Deep.mapg (fun x -> EVAL.precompile_expr x acc)) li in
          let execenv = init_eenv 0 in
          EVAL.precompiledExpr_of_lexems_list li acc
          |> eval_expr execenv |> get_tokens |> w
        | _ ->
          let execenv = init_eenv 0 in
          EVAL.precompile_expr e acc
          |> eval_expr execenv |> get_tokens |> w
      end
    | _ -> acc, [p]

  let process acc p =
    let acc, p = process acc p in
    let tyenv = List.fold_left Typer.process_tfun acc.tyenv p in
    let acc = { acc with tyenv = tyenv }
    in acc, p

  let apply_prog acc p =
    let acc, p = List.fold_left_map process acc p
    in acc, List.flatten p

  let apply ( prog : Utils.prog ) : Utils.prog  =
    let typerEnv = Typer.empty in
    let acc =  empty_env typerEnv in
    let acc, p = apply_prog acc prog.Prog.funs in
    let acc, m = match prog.Prog.main with
      | None -> acc, None
      | Some m -> let (a, b) = process_main acc m
        in a, Some b
    in
    {prog with
     Prog.main = m;
     Prog.funs = p;
    }

end

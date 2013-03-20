open Ast
open Stdlib
open Warner

module type EvalIO = sig
  val print_int : int -> unit
  val print_char : char -> unit
  val print_string : string -> unit
  val print_bool : bool -> unit
  val read_int : unit -> int
  val skip : unit -> unit
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

type result =
  | Integer of int
  | Float of float
  | Bool of bool
  | Char of char
  | String of string
  | Record of result array
  | Array of result array
  | Lexems of Parser.token list
  | Nil

exception Return of result

let typeof = function
  | Integer _ -> "int"
  | Float _ -> "float"
  | Bool _ -> "bool"
  | Char _ -> "char"
  | String _ -> "string"
  | Record _ -> "record"
  | Array _ -> "array"
  | Nil _ -> "Nil"

let get_array = function
  | Array a -> a
  | x ->
    Printf.printf "Got %s expected array" (typeof x); assert false

let get_integer = function
  | Integer a -> a
  | x ->
    Printf.printf "Got %s expected int" (typeof x); assert false

let get_float = function
  | Float a -> a
  | x ->
    Printf.printf "Got %s expected float" (typeof x); assert false

let get_char = function
  | Char a -> a
  | x ->
    Printf.printf "Got %s expected char" (typeof x); assert false

let get_string = function
  | String a -> a
  | x ->
    Printf.printf "Got %s expected string" (typeof x); assert false

let get_bool = function
  | Bool a -> a
  | x ->
    Printf.printf "Got %s expected bool" (typeof x); assert false

let get_tokens = function
  | Lexems a -> a
  | Bool false -> [ Parser.FALSE ]
  | Bool true -> [ Parser.TRUE ]
  | Integer i -> [ Parser.INT i ]
  | x ->
    Printf.printf "Got %s expected token list" (typeof x); assert false

type execenv = result array

type  env = {
  nvars : int;
  vars : int StringMap.t;
  functions :
    (int * (execenv -> unit) ) ref
    StringMap.t;
  tyenv : Typer.env;
}

and precompiledExpr =
  | Result of result
  | WithEnv of (execenv -> result)

let flatten_lexems li =
  List.fold_left (fun acc li ->
    match (acc, li) with
      | Result (Lexems li1), Result (Lexems li2) ->
        Result (Lexems (List.append li1 li2) )
      | WithEnv f, Result (Lexems li2) ->
        WithEnv (fun execenv ->
          let li1 = f execenv |> get_tokens in
          Lexems (List.append li1 li2)
        )
      | Result  (Lexems li1), WithEnv f ->
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

let empty_env te =
  {
    tyenv = te;
    nvars = 0;
    vars = StringMap.empty;
    functions = StringMap.empty;
  }

let eval_expr execenv (e : precompiledExpr) :  result = match e with
  | Result r -> r
  | WithEnv f -> f execenv

let tyerr loc =
  raise (Error (fun f -> Format.fprintf f "Type error %a\n%!"
    ploc loc))

let num_op loc ( + ) ( +. ) a b =
  match a, b with
    | Result a, Result b ->
      Result begin match a, b with
        | Float i, Float j -> Float (i +. j)
        | Integer i, Integer j -> Integer (i + j)
        | _ -> tyerr loc
      end
    | WithEnv a, Result b ->
      begin match b with
        | Float j -> WithEnv (fun execenv ->
          Float ((get_float (a execenv)) +. j))
        | Integer j -> WithEnv (fun execenv ->
          Integer ((get_integer (a execenv)) + j))
        | _ -> tyerr loc
      end
      | Result b, WithEnv a ->
        begin match b with
          | Float i -> WithEnv (fun execenv ->
            Float (i +. (get_float (a execenv))))
          | Integer i -> WithEnv (fun execenv ->
            Integer (i + (get_integer (a execenv))))
          | _ -> tyerr loc
        end
      | WithEnv a, WithEnv b ->
        WithEnv (fun execenv ->
          match a execenv, b execenv with
            | Float i, Float j -> Float (i +. j)
            | Integer i, Integer j -> Integer (i + j)
            | _ -> tyerr loc
        )
let int_op loc f a b = num_op loc f (fun _ _ -> tyerr loc) a b

type compare = { cmp : 'a . 'a -> 'a -> bool }

let num_cmp f =
  let (<) = f.cmp in
  fun loc a b ->
  match a, b with
    | Result ra, Result rb ->
      Result
        (match ra, rb with
          | Float i, Float j -> Bool (i < j)
          | Integer i, Integer j -> Bool (i < j)
          | Bool i, Bool j -> Bool ( i < j)
          | Char i, Char j -> Bool ( i < j)
          | _ -> tyerr loc)
    | WithEnv fa, WithEnv fb ->
      WithEnv (fun execenv ->
        let a = fa execenv in
        let b = fb execenv in
        match a, b with
          | Float i, Float j -> Bool (i < j)
          | Integer i, Integer j -> Bool (i < j)
          | Bool i, Bool j -> Bool ( i < j)
          | Char i, Char j -> Bool ( i < j)
          | _ -> tyerr loc)
    | WithEnv fa, Result rb ->
      begin match rb with
        | Float j -> WithEnv (fun execenv ->
          match fa execenv with
            | Float i -> Bool (i < j)
            | _ -> tyerr loc
        )
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
        | Float i -> WithEnv (fun execenv ->
          match fb execenv with
            | Float j -> Bool (i < j)
            | _ -> tyerr loc
        )
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
  | Expr.BinOr -> int_op loc ( lor ) a b
  | Expr.BinAnd -> int_op loc ( land ) a b
  | Expr.RShift -> int_op loc ( lsr ) a b
  | Expr.LShift -> int_op loc ( lsl ) a b
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

let init_eenv nvars = Array.make nvars Nil

let find_in_env (env:env) v : int =
  StringMap.find v env.vars

let add_in_env (env:env) v : env * int =
  let out = env.nvars in
  {
    env with
      nvars = out + 1;
      vars = StringMap.add v out env.vars
  }, out

let index_for_field env field =
  match Type.unfix (Typer.type_of_field env.tyenv field) with
    | Type.Struct (li, _) ->
      let li = List.map fst li |> List.sort String.compare in
      List.indexof field li
    | _ -> raise (Error (fun f ->
      Format.fprintf f "type error : waiting for field %s" field
    ))

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

let expr_of_lexems_list (li:Parser.token list) : Parser.token Expr.t =
  of_lexems_list "expr" Parser.toplvl_expr li

let prog_list_of_lexems_list (li:Parser.token list) : Parser.token Prog.t_fun list =
  of_lexems_list "prog" Parser.toplvls li

let instrs_of_lexems_list (li:Parser.token list) : Parser.token Expr.t Instr.t list =
  of_lexems_list "instrs" Parser.toplvl_instrs li

module EvalF (IO : EvalIO) = struct

let rec precompile_expr (t:Parser.token Expr.t) (env:env): precompiledExpr =
  let loc = PosMap.get (Expr.Fixed.annot t) in
  let res x = Result x in
  match Expr.Fixed.map (fun e -> precompile_expr e env)
    (Expr.Fixed.unfix t) with
      | Expr.Char c -> Char c |> res
      | Expr.String s -> String s |> res
      | Expr.Integer i -> Integer i |> res
      | Expr.Float f -> Float f |> res
      | Expr.Bool b -> Bool b |> res
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
      | Expr.Call (name, params) ->
        let call = eval_call env name params  in
        WithEnv (fun execenv ->
  (* Printf.printf "Call %s\n" name; *)
          call execenv
        )
      (*| Expr.UnOp (Integer i, Expr.BNot) -> Integer (lnot )
        | Expr.UnOp (Float i, Expr.Neg) -> Float (-. i) *)
      | Expr.UnOp (_, _) -> assert false
      | Expr.Enum e ->
        let t = Typer.type_for_enum e env.tyenv in
        begin match Type.unfix t with
          | Type.Enum li ->
            let rec f n = function
              | [] -> assert false
              | hd::tl -> if String.equals hd e then n else
                  f (n + 1) tl in
            Integer (f 0 li) |> res
          | _ -> assert false
        end
      | Expr.Lexems l -> precompiledExpr_of_lexems_list l env
and precompiledExpr_of_lexems_list li (env:env): precompiledExpr =
  let li = List.map (fun l -> match l with
    | Lexems.Expr e -> e
    | Lexems.Token t -> Result (Lexems [t])
    | Lexems.UnQuote e ->
      let li = precompiledExpr_of_lexems_list e env in
      match li with
        | Result (Lexems li) ->
          let e = expr_of_lexems_list li
          in precompile_expr e env
        | WithEnv f ->
          WithEnv (fun execenv ->
            match f execenv with
              | Lexems li ->
                let e = expr_of_lexems_list li in
                let r = precompile_expr e env in
                eval_expr execenv r
          )
  ) li
  in flatten_lexems li



and mut_setval (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result -> unit =
  match Mutable.unfix mut with
    | Mutable.Var v ->
      begin try
              let out = StringMap.find v env.vars in fun execenv v->
                execenv.(out) <- v
        with Not_found ->
          raise (Error (fun f ->
            Format.fprintf f "Cannot find var %s\n" v))
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
      let index = index_for_field env field in
      let m = mut_val env m in
      (fun execenv v ->
        match m execenv with
          | Record map ->
            map.(index) <- v
          | x ->
            raise (Error (fun f -> Format.fprintf f "Got %s expected Record\n" (typeof x)))
      )
and mut_val (env:env) (mut : precompiledExpr Mutable.t)
    : execenv -> result =
  match Mutable.unfix mut with
    | Mutable.Var v ->
      begin try
              let out = StringMap.find v env.vars in fun execenv ->
                execenv.(out)
        with Not_found ->
          raise (Error (fun f -> Format.fprintf f "Cannot find var %s\n" v))
      end
    | Mutable.Array (m, li) ->
      let m = mut_val env m in
      List.fold_left
        (fun m index execenv ->
          (get_array (m execenv)).(get_integer (eval_expr execenv index))
        )
        m
        li
    | Mutable.Dot (m, field) ->
      let index = index_for_field env field in
      let m = mut_val env m in
      (fun execenv ->
        match m execenv with
          | Record map ->
            map.(index)
          | x ->
            raise (Error (fun f -> Format.fprintf f "Got %s expected Record\n" (typeof x)))
      )
and eval_call env name params : execenv -> result =
  try
    let r = StringMap.find name env.functions in
    let params = Array.of_list params in
    let nparams = Array.length params - 1 in
    (fun ex_execenv ->
      let (nvars, instrs) = !r in
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
        | "float_of_int", [param] ->
          Float (float_of_int (get_integer param))
        | _ -> failwith ("The Macro "^name^" cannot be evaluated with
    "^(string_of_int (List.length params))^" arguments")
      )
and eval_instr env (instr: (env -> precompiledExpr) Instr.t) :
    (env * (execenv -> unit))
    = match Instr.unfix instr with
  | Instr.Declare (varname, _, e) ->
    let e = e env in
    let env, r = add_in_env env varname in
    let f execenv =
  (* Printf.printf "Declare %s\n" varname; *)
      execenv.(r) <- eval_expr execenv e
    in env, f
  | Instr.Affect (mutable_, e) ->
    let mutable_ = Mutable.map_expr (fun f -> f env) mutable_ in
    let mut = mut_setval env mutable_ in
    let e = e env in
    env, (fun execenv -> mut execenv (eval_expr execenv e))
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
  | Instr.AllocArray (var, t, e, opt) ->
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
  | Instr.AllocRecord (var, t, fields) ->
    let fields = List.map (fun (name, e) ->
      index_for_field env name, e env) fields in
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
  | Instr.Print (t, e) ->
    let e = e env in
    let f execenv =
      let e = eval_expr execenv e in
      print t e
    in env, f
  | Instr.Read (t, mut) ->
    let mut = Mutable.map_expr (fun f -> f env) mut in
    let mut = mut_setval env mut
    in env, (fun execenv ->
      read t (fun value -> mut execenv value))
  | Instr.DeclRead (t, var) ->
    let env, r = add_in_env env var in
    env, (fun execenv -> read t (fun v -> execenv.(r) <- v))
  | Instr.StdinSep _ ->
    let f execenv = IO.skip () in
    env, f
  | Instr.Unquote li -> assert false
and print ty e =
  let () = match Type.unfix ty with
    | Type.Array(ty) ->
      begin
        Array.map (fun e -> print ty e) (get_array e);
        ()
      end
    | Type.Integer -> IO.print_int (get_integer e)
    | Type.Char -> IO.print_char (get_char e)
    | Type.Bool -> IO.print_bool (get_bool e)
    | Type.String -> IO.print_string (get_string e)
    | _ -> failwith ("cannot print type "^(Type.type_t_to_string ty))
  in ()
and read ty k = match Type.unfix ty with
  | Type.Integer -> k ( Integer (IO.read_int ()))
  | Type.Char -> k (Char (IO.read_char ()))
  | _ -> failwith ("cannot read type "^(Type.type_t_to_string ty))
and eval_instrs env
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

let rec precompile_instrs li =
  List.map precompile_instr li
and precompile_instr i =
  let i = match Instr.unfix i with
    | Instr.Declare (v, t, e) -> Instr.Declare (v, t, precompile_expr e)
    | Instr.Affect (mut, e) -> Instr.Affect (Mutable.map_expr precompile_expr
                                               mut, precompile_expr e)
    | Instr.Loop (v, e1, e2, li) ->
      Instr.Loop (v,
                  precompile_expr e1,
                  precompile_expr e2,
                  precompile_instrs li)
    | Instr.While (e, li) ->
      Instr.While (precompile_expr e, precompile_instrs li)
    | Instr.Comment s -> Instr.Comment s
    | Instr.Return e -> Instr.Return (precompile_expr e)
    | Instr.AllocArray (v, t, e, opt) ->
      let opt = match opt with
        | None -> None
        | Some ((v, li)) -> Some (v, precompile_instrs li)
      in Instr.AllocArray(v, t, precompile_expr e, opt)
    | Instr.AllocRecord (v, t, li) ->
      let li = List.map
        (fun (name, e) -> (name, precompile_expr e)) li
      in Instr.AllocRecord (v, t, li)
    | Instr.If (e, l1, l2) ->
      Instr.If (precompile_expr e, precompile_instrs l1, precompile_instrs l2)
    | Instr.Call (name, li) -> Instr.Call (name, List.map precompile_expr li)
    | Instr.Print (t, e) -> Instr.Print (t, precompile_expr e)
    | Instr.Read (t, mut) -> Instr.Read (t, Mutable.map_expr precompile_expr mut)
    | Instr.DeclRead (t, v) -> Instr.DeclRead (t, v)
    | Instr.StdinSep -> Instr.StdinSep
    | Instr.Unquote li -> assert false
  in Instr.Fixed.fix i

let compile_fun env var t li instrs =
  let nvars = List.length li in
  let thisfunc = ref (0, fun _ -> ()) in
  let env = {env with
    nvars = nvars + 1;
    vars = List.fold_left
      (fun (f, i) (v, _) ->
        (StringMap.add v i f), i+1
      )
      (StringMap.empty, 0) li |> fst;
    functions =
      StringMap.add var
        thisfunc
        env.functions
  }
  in
      (*      let () = Printf.printf "Precompiling %s\n" var in *)
  let env, instrs = eval_instrs env (precompile_instrs instrs) in
      (*      let () = Printf.printf "the function %s need %d vars" var env.nvars
              in *)
  let () = thisfunc := (env.nvars, instrs)
  in env

let precompile_eval_expr (env:env) (e:Parser.token Expr.t) : result =
  let precompiled = precompile_expr e env in
  let execenv = init_eenv 0 in
  eval_expr execenv precompiled

let eval_prog (te : Typer.env) (p:Parser.token Prog.t) =
  let f env p = match p with
    | Prog.DeclarFun (var, t, li, instrs) ->
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


module EvalConstantes = struct

  let process_expr acc e =
    let f acc e = match Expr.Fixed.unfix e with
      | Expr.Call ("instant", [param]) ->
        let new_expr = match EVAL.precompile_eval_expr acc param with
          | Integer x -> Expr.integer x
          | Float x -> Expr.float x
          | Bool x -> Expr.bool x
          | Char x -> Expr.char x
          | String x -> Expr.string x
          | _ -> raise (Error (fun f -> Format.fprintf f "type error...")) (* TODO *)
        in acc, new_expr
      | _ -> acc, e
    in Expr.Writer.Deep.foldmap f acc e

  let collect_instr acc (i:Parser.token Expr.t Instr.t) =
    let f (i:Parser.token Expr.t Instr.t) :
        (Parser.token Expr.t Instr.t list) =
      match Instr.unfix i with
      | Instr.Unquote e ->
        begin match Expr.unfix e with
          | Expr.Lexems li ->
            let li = List.map
              (Lexems.map_expr (fun x -> EVAL.precompile_expr x acc)
              ) li in
            let execenv = init_eenv 0 in
            begin match EVAL.precompiledExpr_of_lexems_list li acc
                |> eval_expr execenv with
                  | Lexems li -> instrs_of_lexems_list li
            end
          | _ ->
            let execenv = init_eenv 0 in
            begin match EVAL.precompile_expr e acc
                |> eval_expr execenv with
                    | Lexems li -> instrs_of_lexems_list li
            end
        end
      | _ -> [i]
    in
    let g li = List.collect f li in
    let i = Instr.deep_map_bloc g (Instr.unfix i) |> Instr.fixa
        (Instr.Fixed.annot i) in
    let li = f i in
    List.fold_left_map (Instr.foldmap_expr process_expr) acc li

  let process_main acc m =
    let acc, m = List.fold_left_map collect_instr acc m
    in acc, List.flatten m

  let rec process acc p =
    match p with
      | Prog.DeclarFun (funname, t, params, instrs) ->
        let acc, instrs = List.fold_left_map collect_instr acc instrs in
        let instrs = List.flatten instrs in
        let acc = EVAL.compile_fun acc funname t params instrs in
        acc, [Prog.DeclarFun (funname, t, params, instrs)]
      | Prog.Unquote e ->
        let w li =
          let li = prog_list_of_lexems_list li in
          let p, li = List.fold_left_map process acc li
          in p, List.flatten li
        in
        begin match Expr.unfix e with
          | Expr.Lexems li ->
            let li = List.map
              (Lexems.map_expr (fun x -> EVAL.precompile_expr x acc)
              ) li in
            let execenv = init_eenv 0 in
            begin match EVAL.precompiledExpr_of_lexems_list li acc
                |> eval_expr execenv with
                    | Lexems li -> w li
            end
          | _ ->
            let execenv = init_eenv 0 in
            begin match EVAL.precompile_expr e acc
                |> eval_expr execenv with
                    | Lexems li -> w li
            end
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

  let apply ( prog : Parser.token Prog.t ) : Parser.token Prog.t  =
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
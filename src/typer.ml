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


(** Typer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Ast
open Warner

(** {2 Types} *)
type typeContrainte =
  | Unknown of Ast.Location.t
  | PreTyped of typeContrainte ref Type.tofix * Ast.Location.t
  | Typed of Type.t * Ast.Location.t

type varType = typeContrainte ref

type functionType = Type.t list * varType

let rec is_typed (t : typeContrainte ref) : bool =
  match !t with
  | Unknown _ -> false
  | PreTyped (t, _) ->
    let out = ref true in
    let _ = Type.Fixed.Surface.map (fun t -> if not (is_typed t) then out := false) t in !out
  | Typed (t, _) -> true


let rec extract_typed (t : typeContrainte ref) : Type.t =
  match !t with
  | Unknown loc -> assert false
  | PreTyped (t, loc) ->
    let t = Type.Fixed.Surface.map extract_typed t |> Type.Fixed.fix in
    PosMap.add ( Type.Fixed.annot t ) loc;
    t
  | Typed (t, _) -> t

type env =
  {
    automap : typeContrainte ref IntMap.t;
    contrainteMap : typeContrainte ref IntMap.t;
    fields : (Type.t * Type.t * string) StringMap.t;
    enum : (Type.t * string) StringMap.t;
    gamma : Type.t StringMap.t;
    functions : functionType StringMap.t;
    locales : varType BindingMap.t;
    contraintes : (typeContrainte ref * typeContrainte ref) list;
  }

let type_of_field env field loc =
  try
    let (_, t, _) = StringMap.find field env.fields in t
  with Not_found ->
    raise ( Error (fun f ->
        Format.fprintf f "Field %s is undefined %a\n%!" field Ast.Location.pp loc
      ))
let ty2typeContrainte (env : env) (t : Type.t) (loc : Ast.Location.t)
  : (env * typeContrainte ref) =

  let fold env t = match Type.Fixed.unfix t with
    | Type.Auto ->
      let out = ref (Unknown loc) in
      let env = {env with automap = IntMap.add (Type.Fixed.annot t)
                              out env.automap }
      in env
    | _ -> env
  in
  let env = Type.Fixed.Deep.fold_acc fold env t
  in
  let rec f t = match Type.Fixed.unfix t with
    | Type.Auto -> IntMap.find (Type.Fixed.annot t) env.automap
    | t -> ref ( PreTyped ( (Type.Fixed.Surface.map f t ), loc) )
  in let t = f t in env, t

(** {2 Printers} *)
let rec contr2str t =
  match t with
  | Unknown _ -> "*"
  | PreTyped (ty, _) -> "P_"^
                        (Type.type2String (Type.Fixed.Surface.map (fun t -> contr2str !t) ty))
  | Typed (ty, _) -> "T_" ^ (Type.type_t_to_string ty)

(** {2 Error reporters} *)

let error_no_auto_type map annot ty =
  raise ( Error (fun f ->
      Format.fprintf f
        "Cannot find type of auto in %s (%d)\n%!"
        (Type.type_t_to_string ty) annot;
      IntMap.iter (fun k v ->
          Format.fprintf f "annot %d : %s@\n" k
            (contr2str !v)
        ) map
    ))

let error_no_contraintes li =
  raise ( Error (fun f ->
      List.iter
        (fun (a, b) ->
           Format.fprintf f "No contrainte to unify %s and %s\n%!"
             (contr2str !a) (contr2str !b)
        ) li
    ))

let error_field_not_found loc name t =
  raise ( Error (fun f ->
      Format.fprintf f "Field %s is not found in %s %a\n%!"
        name
        (Type.type_t_to_string t)
        Ast.Location.pp loc))

let error_function_not_found loc name =
  raise (Error (fun f -> Format.fprintf f "Function %s is not found in %a\n%!"
                   name
                   Ast.Location.pp loc))

let rec plistring f li =
  match li with
  | hd::tl ->
    Format.fprintf f "  %s\n%a" hd plistring tl
  | [] -> ()

let error_record_types lval lt loc =
  raise (Error (fun f -> Format.fprintf f "Fields does not match in %a\n%aagainst\n%a%!"
                   (* TODO show lists & diff *)
                   Ast.Location.pp loc
                   plistring lval
                   plistring lt))

let error_arrity funname l1 l2 loc =
  raise (Error (fun f ->
      Format.fprintf f "The function %s expects %d arguments, %d given %a.\n%!"
        funname l1 l2
        Ast.Location.pp loc))

let error_ty t1 t2 loc1 loc2 =
  raise (Error (fun f  -> Format.fprintf f "Cannot unify %s %a and %s %a\n%!"
                   (Type.type_t_to_string t1)
                   Ast.Location.pp loc1
                   (Type.type_t_to_string t2)
                   Ast.Location.pp loc2))

let not_found name loc =
  raise (Error (fun f -> Format.fprintf f "Cannot find variable %a %a \n%!"
                   (fun f -> function
                      | UserName u -> Format.fprintf f "%s" u
                      | InternalName i -> Format.fprintf f "internal(%d)" i
                   ) name
                   Ast.Location.pp loc))

let not_found_ty name loc =
  raise (Error (fun f -> Format.fprintf f "Cannot find type %s %a \n%!"
                   name
                   Ast.Location.pp loc))
    
let not_found_enum name loc =
  raise (Error (fun f -> Format.fprintf f "Cannot find enum type with field %s %a \n%!"
                   name
                   Ast.Location.pp loc))

let error_cty t1 t2 loc1 loc2 =
  raise (Error (fun f -> Format.fprintf f "Cannot unify %s %a and %s %a\n%!"
                   (contr2str t1)
                   Ast.Location.pp loc1
                   (contr2str t2)
                   Ast.Location.pp loc2))

(** {2 Types anti alias-ing}*)
let expand env ty loc =
  let rec f ty =
    match Type.Fixed.unfix ty with
    | Type.Named name ->
      (try
         StringMap.find name env.gamma
       with Not_found ->
         not_found_ty name loc)
    | x -> Type.Fixed.F (Type.Fixed.annot ty, (Type.Fixed.Surface.map f x))
  in f ty

let child_type_of_field env field loc =
  try
    let (_, t, _) = StringMap.find field env.fields in match Type.unfix (expand env t loc) with
    | Type.Struct li -> List.assoc field li
    | _ -> raise Not_found
  with Not_found ->
    raise ( Error (fun f ->
        Format.fprintf f "Field %s is undefined %a\n%!" field Ast.Location.pp loc
      ))

(** {2 Unify} *)
let rec check_types env (t1:Type.t) (t2:Type.t) loc1 loc2 =
  match (Type.Fixed.unfix t1), (Type.Fixed.unfix t2) with
  | Type.Integer, Type.Integer -> ()
  | Type.Lexems, Type.Lexems -> ()
  | Type.Integer, _ -> error_ty t1 t2 loc1 loc2
  | Type.Bool, Type.Bool -> ()
  | Type.Bool, _ -> error_ty t1 t2 loc1 loc2
  | Type.String, Type.String -> ()
  | Type.String, _ -> error_ty t1 t2 loc1 loc2
  | Type.Char, Type.Char -> ()
  | Type.Char, _ -> error_ty t1 t2 loc1 loc2
  | Type.Void, Type.Void -> ()
  | Type.Void, _ -> error_ty t1 t2 loc1 loc2
  | Type.Named n, Type.Named n2 ->
    if String.equals n n2 then () else error_ty t1 t2 loc1 loc2
  | _, Type.Named n ->
    check_types env t1 (expand env t2 loc2) loc1 loc2
  | Type.Named n, _ ->
    check_types env (expand env t1 loc1) t2 loc1 loc2
  | Type.Array t, Type.Array t2 -> check_types env t t2 loc1 loc2
  | Type.Option t, Type.Option t2 -> check_types env t t2 loc1 loc2
  | Type.Tuple li1, Type.Tuple li2 ->
    let len1 = List.length li1
    and len2 = List.length li2 in
    if len1 = len2 then
      List.iter (fun (ty1, ty2) -> check_types env ty1 ty2 loc1 loc2) (List.zip li1 li2)
    else error_ty t1 t2 loc1 loc2
  | Type.Struct li, Type.Struct li2 ->
    List.iter
      (fun (name, ty) ->
         let (_, ty2) =
           try
             List.find ((String.equals name) @* fst) li2
           with Not_found ->
             error_field_not_found loc1 name t2
         in
         check_types env ty ty2 loc1 loc2
      ) li
  | Type.Enum li, Type.Enum li2 ->
    List.iter
      (fun name ->
         (try
            let _ = List.find (String.equals name) li2 in ()
          with Not_found ->
            error_field_not_found loc1 name t2
         ); ()
      ) li
  | _ -> error_ty t1 t2 loc1 loc2

let rec tyall t = match !t with
  | PreTyped ( Type.Integer, loc ) -> t := Typed ((Type.Fixed.fix Type.Integer), loc); true
  | PreTyped ( Type.String, loc ) -> t := Typed ((Type.Fixed.fix Type.String), loc); true
  | PreTyped ( Type.Char, loc ) -> t := Typed ((Type.Fixed.fix Type.Char), loc); true
  | PreTyped ( Type.Void, loc ) -> t := Typed ((Type.Fixed.fix Type.Void), loc); true
  | PreTyped ( Type.Bool, loc ) -> t := Typed ((Type.Fixed.fix Type.Bool), loc); true
  | PreTyped ( Type.Lexems, loc ) -> t := Typed ((Type.Fixed.fix Type.Lexems), loc); true
  | PreTyped ( Type.Enum li, loc ) -> t := Typed ((Type.Fixed.fix (Type.Enum li)), loc); true
  | PreTyped ( Type.Named n, loc ) -> t := Typed ((Type.named n), loc); true
  | PreTyped ( Type.Array a1, loc ) -> if tyall a1 then begin t := Typed (extract_typed t, loc); true end else false
  | PreTyped ( Type.Option a1, loc ) -> if tyall a1 then begin t := Typed (extract_typed t, loc); true end else false
  | PreTyped ( Type.Struct li, loc) ->
    let all = List.fold_left (fun acc (_, t) -> (tyall t) && acc) true li in
    if all then begin t := Typed (extract_typed t, loc); true end else false
  | PreTyped ( Type.Tuple li, loc) ->
    let all = List.fold_left (fun acc t -> (tyall t) && acc) true li in
    if all then begin t := Typed (extract_typed t, loc); true end else false
  | Typed _ -> true
  | Unknown _ -> false
  | PreTyped ( Type.Auto , _ ) -> assert false
      
let rec unify env (t1 : typeContrainte ref) (t2 : typeContrainte ref) : bool =
  let _ = tyall t1 in
  let _ = tyall t2 in
  match !t1, !t2 with
  | PreTyped (Type.Integer, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.Integer), loc); true end
  | PreTyped (Type.String, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.String) , loc); true end
  | PreTyped (Type.Char, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.Char) , loc); true end
  | PreTyped (Type.Void, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.Void) , loc); true end
  | PreTyped (Type.Bool, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.Bool) , loc); true end
  | PreTyped (Type.Lexems, loc), _ -> begin t1 := Typed ((Type.Fixed.fix Type.Lexems) , loc); true end
  | PreTyped (Type.Enum li, loc), _ -> begin t1 := Typed ((Type.Fixed.fix (Type.Enum li)) , loc); true end
  | PreTyped (Type.Named n, loc), _ -> begin t1 := Typed ((Type.named n), loc); true end
  | Typed (tt1, loc1), Typed (tt2, loc2) -> begin check_types env tt1 tt2 loc1 loc2; false end
  | Unknown _, Unknown _-> false
  | Unknown _, _ -> begin t1 := !t2; true end
  | _, Unknown _ -> begin t2 := !t1; true end
  | Typed _, PreTyped _ -> unify env t2 t1
  | PreTyped (Type.Tuple li1, loc1), Typed ( Type.Fixed.F (_, Type.Tuple li2), loc2) ->
    let len1 = List.length li1 in
    let len2 = List.length li2 in
    if len1 = len2 then
      List.fold_left (fun acc (t1, t2_) ->
          let t2 = ref (Typed (t2_, loc2)) in
          unify env t1 t2 || acc
        ) false (List.combine li1 li2)
    else  error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Tuple li1, loc1), PreTyped (Type.Tuple li2, loc2) ->
    let len1 = List.length li1 in
    let len2 = List.length li2 in
    if len1 = len2 then
      List.fold_left (fun acc (t1, t2) ->
          unify env t1 t2 || acc
        ) false (List.combine li1 li2)
    else  error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Array a1, loc1), PreTyped (Type.Array a2, loc2) ->
    begin match !a1, !a2 with
      | Typed (t, loc), _ -> begin t1 := Typed ((Type.Fixed.fix (Type.Array t)) , loc); true end
      | _, Typed (t, loc) -> begin t2 := Typed ((Type.Fixed.fix (Type.Array t)) , loc); true end
      | _ -> unify env a1 a2
    end
  | PreTyped (Type.Array _, loc1), PreTyped (_, loc2) -> error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Array r1, loc1), Typed (Type.Fixed.F (_, Type.Array ty), loc2) ->
    begin
      match !r1 with
      | Typed _ -> t1 := !t2; true
      | _ -> unify env r1 (ref (Typed (ty, loc1)))
    end
  | PreTyped ((Type.Array r1), loc1), Typed (_, loc2) -> error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Option _, loc1), PreTyped (_, loc2) -> error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Option r1, loc1), Typed (Type.Fixed.F (_, Type.Option ty), loc2) ->
    begin
      match !r1 with
      | Typed _ -> t1 := !t2; true
      | _ -> unify env r1 (ref (Typed (ty, loc1)))
    end
  | PreTyped ((Type.Option r1), loc1), Typed (_, loc2) -> error_cty !t1 !t2 loc1 loc2
  | PreTyped (Type.Struct li, loc1), Typed (Type.Fixed.F (_, Type.Struct li2), loc2) ->
    let all = List.fold_left
        (fun all (name, t) ->
           let self_typed = match !t with
             | Typed _ -> true
             | _ -> false
           in all && self_typed) true li
    in if all then
      begin t1 := Typed (extract_typed t1, loc1); true end
    else
      let one = List.fold_left
          (fun one (name, t) ->
             let (_, t2) = List.find ((String.equals name) @* fst) li2 in
             let next = unify env t (ref (Typed (t2, loc2))) in one || next
          ) false li
      in one
  | PreTyped (Type.Struct li, loc1),
    PreTyped (Type.Struct li2, loc2) ->
    let one, all = List.fold_left
        (fun (one, all) (name, t) ->
           let (_, t2) = List.find
               ((String.equals name) @* fst)
               li2 in
           let next = unify env t t2 in
           let self_typed = match !t with
             | Typed _ -> true
             | _ -> false
           in
           (one || next, all && self_typed)
        ) (false, true) li
    in if all then
      begin
        t1 := Typed (extract_typed t1, loc1)
      end; one

  |  PreTyped (Type.Struct _, loc1), PreTyped (_, loc2) -> error_cty !t1 !t2 loc1 loc2
  | _, Typed (((Type.Fixed.F (_, Type.Named _)) as t), loc) -> begin t2 := Typed ((expand env t loc), loc); true end
  | PreTyped (Type.Struct _, loc1), Typed (_, loc2) -> error_cty !t1 !t2 loc1 loc2

  | _ -> raise (Error (fun f -> Format.fprintf f "FAIL %S %S" (contr2str !t1) (contr2str !t2)))

(** {2 Accessors}*)

let get_type_a env a =
  match !(IntMap.find a env.contrainteMap) with
  | Typed (t, _) -> t
  | c -> raise (Error (fun f -> Format.fprintf f "@\nNo type : %s@\n%!"
                          (contr2str c)))

let is_int_a env a = Type.Integer = Type.unfix (get_type_a env a)
let is_bool_a env a = Type.Bool = Type.unfix (get_type_a env a)

let is_int env expr = Expr.Fixed.annot expr |> is_int_a env
let is_bool env expr = Expr.Fixed.annot expr |> is_bool_a env


let get_type env expr = Expr.Fixed.annot expr |> get_type_a env

let typed env expr =
  try
    match !(IntMap.find (Expr.Fixed.annot expr) env.contrainteMap) with
    | Typed (_, _) -> true
    | _ -> false
  with Not_found -> false


let exprloc e = Ast.PosMap.get (Expr.Fixed.annot e)

let add_contrainte env c1 c2 =
  { env with
    contraintes = (c1, c2) :: env.contraintes
  }

let contrainte_of_lief loc env = function
  | Expr.Char _ ->
    ref (Typed (Type.char, loc))
  | Expr.String _ ->
    ref (Typed (Type.string, loc))
  | Expr.Integer _ ->
    ref (Typed (Type.integer, loc))
  | Expr.Bool _ ->
    ref (Typed (Type.bool, loc))
  | Expr.Enum en ->
    let (t, _) = try StringMap.find en env.enum
      with Not_found -> not_found_enum en loc
    in
    ref (Typed (t, loc) )
  | Expr.Nil ->
    let contrainte = ref (Unknown loc) in
    ref (PreTyped (Type.Option contrainte, loc) )



let collect_contraintes_mutable mapg mut =
  Mutable.Fixed.Deep.foldmap2i_topdown
    (fun i mut env ->
       let tloc = Ast.PosMap.get i in
       match mut with
       | Mutable.Var name ->
         let ty = try
             BindingMap.find name env.locales
           with Not_found ->
             not_found name tloc
         in let env = { env with
                        contrainteMap = IntMap.add i ty env.contrainteMap
                      } in
         env, ty
       | Mutable.Array (contrainte_mut, eli) ->
         let env = List.fold_left (fun env contrainte_expr ->
             let integer_contrainte = ref (Typed (Type.integer, tloc)) in
             add_contrainte env integer_contrainte contrainte_expr
           ) env eli in
         let contrainte = ref (Unknown tloc) in
         let contrainte_mut2 = ref (PreTyped (Type.Array contrainte, tloc) ) in
         let env = { env with contraintes =
                                (contrainte_mut, contrainte_mut2) :: env.contraintes;
                              contrainteMap = IntMap.add i contrainte env.contrainteMap
                   } in
         env, contrainte
       | Mutable.Dot (contrainte, name) ->
         let (ty_dot, ty_mut, _) =
           try StringMap.find name env.fields
           with Not_found ->
             raise ( Error (fun f ->
                 Format.fprintf f "Field %s is undefined %a\n%!" name Ast.Location.pp tloc
               ))
         in
         let env, contrainte2 = ty2typeContrainte env ty_mut tloc in
         let env, ty_dot = ty2typeContrainte env ty_dot tloc in
         let env = {env with
                    contraintes = (contrainte, contrainte2) :: env.contraintes;
                    contrainteMap = IntMap.add i ty_dot env.contrainteMap} in
         env, ty_dot
    ) mapg mut


(** {2 Collect contraintes functions} *)
let collect_contraintes_expr e env =
  Expr.Fixed.Deep.folda (fun i e env ->
      let loc = Ast.PosMap.get i in
      let env, e = Expr.Fixed.Surface.foldmap (fun e env -> e env) e env in
      let env, contrainte = match e with
        | Expr.BinOp (acontrainte, Expr.Mod, bcontrainte) ->
          let env = add_contrainte env acontrainte
              (ref (Typed (Type.integer, loc))) in
          let env = add_contrainte env bcontrainte
              (ref (Typed (Type.integer, loc))) in
          env, ref (Typed (Type.integer, loc))

        | Expr.BinOp (acontrainte, (Expr.Or | Expr.And), bcontrainte) ->
          let env = add_contrainte env acontrainte
              (ref (Typed (Type.bool, loc))) in
          let env = add_contrainte env bcontrainte
              (ref (Typed (Type.bool, loc))) in
          env, ref (Typed (Type.bool, loc))
        | Expr.BinOp (acontrainte, (Expr.Lower | Expr.LowerEq | Expr.Higher | Expr.HigherEq
                                   | Expr.Eq | Expr.Diff), bcontrainte) ->
          let contrainte = ref (Typed (Type.bool, loc)) in
          let env = add_contrainte env acontrainte bcontrainte in
          env, contrainte

        (* Pour les autres cas, on suppose 'a -> 'a -> 'a*)
        | Expr.BinOp (acontrainte,_, bcontrainte) ->
          let contrainte = ref (Unknown (loc)) in
          let env = add_contrainte env acontrainte contrainte in
          let env = add_contrainte env bcontrainte contrainte in
          env, contrainte

        | Expr.UnOp (acontrainte, Expr.Neg) ->
          let contrainte = (ref (Typed (Type.integer, loc))) in
          let env = add_contrainte env acontrainte contrainte in
          env, contrainte
        | Expr.UnOp (acontrainte, Expr.Not) ->
          let contrainte = (ref (Typed (Type.bool, loc))) in
          let env = add_contrainte env acontrainte contrainte in
          env, contrainte
        | Expr.Just econtrainte ->
          let contrainte = (ref (PreTyped (Type.Option econtrainte, loc))) in
          env, contrainte
        | Expr.Lief l -> let c = contrainte_of_lief loc env l in  env, c
        | Expr.Lexems li -> (* TODO typer les insertions *)
          env, ref (Typed (Type.lexems, loc))
        | Expr.Access mut -> collect_contraintes_mutable (fun e acc -> acc, e) mut env
        | Expr.Call ("instant", [param]) -> env, param
        | Expr.Call (name, li) ->
          let (args_ty, out_ty) =
            try
              StringMap.find name env.functions
            with Not_found ->
              error_function_not_found loc name
          in
          let len1 = List.length args_ty in
          let len2 = List.length li in
          let () = if len1 != len2
            then error_arrity name len1 len2 loc
          in
          let env = List.fold_left
              (fun env (ty1, contrainte) ->
                 let env, contrainte2 = ty2typeContrainte env ty1 loc in
                 let env = {env with contraintes = (contrainte, contrainte2) ::
                                                   env.contraintes} in env
              ) env (List.zip args_ty li) in
          env, out_ty
        | Expr.Tuple contraintes ->
          let tuple_contrainte = ref (PreTyped (Type.Tuple contraintes, loc)) in
          env, tuple_contrainte
        | Expr.Record contraintes ->
          let tuple_contrainte = ref (PreTyped (Type.Struct (contraintes), loc)) in
          env, tuple_contrainte
      in
      let env = { env with
                  contrainteMap = IntMap.add i contrainte env.contrainteMap }
      in env, contrainte
    ) e env

let collect_contraintes_instruction env instruction =
  Instr.Fixed.Deep.fold2i_bottomup
    (fun i instruction env ty_ret ->
       let loc = Ast.PosMap.get i in
       match instruction with
       | Instr.Tag _ -> env
       | Instr.Incr m | Instr.Decr m ->
         let env, contrainte_mut = collect_contraintes_mutable (fun e acc -> e env) m env
         in add_contrainte env contrainte_mut (ref (Typed (Type.integer, loc)))
       | Instr.Declare (var, ty, contrainte_expr, _) ->
         let ty = expand env ty loc in
         let env, contrainte_expr = contrainte_expr env in
         let env, contrainte_ty = ty2typeContrainte env ty loc in
         let env =
           { env with locales =
                        BindingMap.add var contrainte_ty env.locales } in
         {env with
          contraintes = (contrainte_ty, contrainte_expr) ::
                        env.contraintes}
       | Instr.SelfAffect (mut, _, contrainte_expr) (* TODO operator constraint *)
       | Instr.Affect (mut, contrainte_expr) ->
         let env, contrainte_expr = contrainte_expr env in
         let env, contrainte_mut = collect_contraintes_mutable (fun e env -> e env) mut env in
         {env with
          contraintes = (contrainte_mut, contrainte_expr) ::
                        env.contraintes}

       | Instr.Loop (var, contrainte_e1, contrainte_e2, li) ->
         let env, contrainte_e1 = contrainte_e1 env in
         let env, contrainte_e2 = contrainte_e2 env in

         let contrainte_integer = ref (Typed (Type.integer, loc) ) in
         let env = {env with locales = BindingMap.add var contrainte_integer
                                 env.locales } in
         let env = {env with
                    contraintes =
                      (contrainte_integer, contrainte_e1) ::
                      (contrainte_integer, contrainte_e2) ::
                      env.contraintes}
         in List.fold_left(fun env f -> f env ty_ret) env li

       | Instr.ClikeLoop (init, cond, incr, li) ->
         let env, contrainte_cond = cond env in
         let env = add_contrainte env contrainte_cond (ref (Typed (Type.bool, loc))) in
         let env = List.fold_left(fun env f -> f env ty_ret) env init in
         let env = List.fold_left(fun env f -> f env ty_ret) env incr in
         let env = List.fold_left(fun env f -> f env ty_ret) env li in
         env
       | Instr.While (contrainte_e, li) ->
         let env, contrainte_e = contrainte_e env in
         let contrainte_bool = ref (Typed (Type.bool, loc)) in
         let env = {env with
                    contraintes = (contrainte_bool, contrainte_e) ::
                                  env.contraintes}
         in List.fold_left(fun env f -> f env ty_ret) env li
       | Instr.Comment _ -> env
       | Instr.Return contrainte_expr ->
         let env, contrainte_expr = contrainte_expr env in
         {env with
          contraintes = (ty_ret, contrainte_expr) ::
                        env.contraintes}
       | Instr.AllocArray (var, ty, contrainte_e, instrsopt, _) ->
         let env, contrainte_e = contrainte_e env in
         let ty = expand env ty loc in
         let env, ty = ty2typeContrainte env ty loc in
         let contrainte_integer = ref (Typed (Type.integer, loc) ) in
         let env = {env with
                    contraintes =
                      (contrainte_integer, contrainte_e) ::
                      env.contraintes}
         in
         let env = match instrsopt with
           | None -> env
           | Some (var, instrs) ->
             let env = {env with
                        locales = BindingMap.add var contrainte_integer env.locales}
             in List.fold_left(fun env f -> f env ty) env instrs
         in
         let env = {env with
                    locales = BindingMap.add var
                        (ref (PreTyped (Type.Array ty, loc)))
                        env.locales}
         in env
       | Instr.AllocArrayConst (var, ty, contrainte_len, e, opt) ->
         let env, contrainte_len = contrainte_len env in
         let c = contrainte_of_lief loc env e in
         let ty = expand env ty loc in
         let contrainte_integer = ref (Typed (Type.integer, loc) ) in
         let env, ty = ty2typeContrainte env ty loc in
         let env = {env with
                    locales = BindingMap.add var
                        (ref (PreTyped (Type.Array ty, loc)))
                        env.locales;
                    contraintes = 
                      (contrainte_integer, contrainte_len) :: (c, ty) :: env.contraintes
                   }
         in env
       | Instr.AllocRecord (var, ty, li, _) ->
         let ty = expand env ty loc in
         let li_type = match li with
           | (name, _) :: _ ->
             begin try match StringMap.find name env.fields with
               | (_, Type.Fixed.F (_, Type.Struct li), _) -> li
               | _ -> assert false
               with Not_found ->
                 error_field_not_found loc name ty
             end
           | _ -> assert false
         in
         let () =
           let fields1 = List.map fst li |> List.sort String.compare in
           let fields2 = List.map fst li_type |> List.sort String.compare in
           if fields1 <> fields2 then
             error_record_types fields1 fields2 loc
         in
         let env = List.fold_left
             (fun env (name, c2) ->
                let env, c2 = c2 env in
                let c1 = ref ( Typed( snd (List.find
                                             ((String.equals name) @* fst) li_type
                                          ), loc)) in
                {env with contraintes = (c1, c2) :: env.contraintes }
             ) env li
         in
         let env, ty = ty2typeContrainte env ty loc in
         let env = {env with
                    locales = BindingMap.add var
                        ty env.locales}
         in env
       | Instr.If (contrainte_expr, instrs1, instrs2) ->
         let contrainte_ty = ref (Typed (Type.bool, loc)) in
         let env, contrainte_expr = contrainte_expr env in
         let env = {env with
                    contraintes = (contrainte_ty, contrainte_expr) ::
                                  env.contraintes} in
         let env =List.fold_left(fun env f -> f env ty_ret) env instrs1 in
         let env =List.fold_left(fun env f -> f env ty_ret) env instrs2 in
         env
       | Instr.Call (f, eli) ->
         let (args, out_contraint) =
           try
             StringMap.find f env.functions
           with Not_found ->
             error_function_not_found loc f
         in
         let len1 = List.length args in
         let len2 = List.length eli in
         let () = if len1 != len2
           then error_arrity f len1 len2 loc
         in
         let void_contraint = ref (Typed (Type.void, loc)) in
         let env = List.fold_left
             (fun (env:env) (arg_ty, contrainte_e) ->
                let env, contrainte_e = contrainte_e env in
                let env, contrainte_ty = ty2typeContrainte env arg_ty loc in
                {env with
                 contraintes = (contrainte_e, contrainte_ty) ::
                               env.contraintes}
             ) env (List.zip args eli) in
         {env with
          contraintes = (void_contraint, out_contraint) ::
                        env.contraintes}
       | Instr.Print li ->
         List.fold_left (fun env -> function
             | Instr.PrintExpr (ty, contrainte_expr) ->
               let ty = expand env ty loc in
               let env, contrainte_expr = contrainte_expr env in
               let env, contrainte_ty = ty2typeContrainte env ty loc in
               {env with
                contraintes = (contrainte_ty, contrainte_expr) ::
                              env.contraintes}
             | Instr.StringConst _ -> env) env li
       | Instr.Untuple (li, contrainte_expr, _) ->
         let env, contrainte_expr = contrainte_expr env in
         let env, li_contraintes =
           List.fold_left_map (fun env (ty, variable) ->
               let ty = expand env ty loc in
               let env, contrainte = ty2typeContrainte env ty loc in
               env, (contrainte, variable)) env li in
         let env = List.fold_left (fun env (contrainte, variable) ->
             { env with locales = BindingMap.add variable contrainte env.locales })
             env li_contraintes in
         let tuple_contrainte = ref (PreTyped (Type.Tuple (List.map fst li_contraintes), loc)) in
         {env with contraintes = (tuple_contrainte, contrainte_expr) :: env.contraintes}
       | Instr.Read li ->
         List.fold_left (fun env -> function
             | Instr.Separation -> env
             | Instr.DeclRead (ty, var, _) ->
               let ty = expand env ty loc in
               let env, ty = ty2typeContrainte env ty loc in
               let env =
                 { env with locales =
                              BindingMap.add var ty env.locales }
               in env
             | Instr.ReadExpr (ty, mut) ->
               let ty = expand env ty loc in
               let env, contrainte_mut = collect_contraintes_mutable (fun e env -> e env) mut env in
               let env, contrainte_expr = ty2typeContrainte env ty loc in
               {env with
                contraintes = (contrainte_mut, contrainte_expr) ::
                              env.contraintes}) env li
       | Instr.Unquote li ->
         raise (Error (fun f -> Format.fprintf f "There is still unquote near %a" Ast.Location.pp loc ))
    )
    collect_contraintes_expr instruction env

let collect_contraintes e
    (funname, ty, params, instructions ) =
  let tyloc = Ast.PosMap.get (Type.Fixed.annot ty) in
  let ty = expand e ty tyloc in
  let e, ty = ty2typeContrainte e ty tyloc in
  let function_type = (List.map ((fun x ->
      let loc = Ast.PosMap.get (Type.Fixed.annot x) in
      expand e x loc) @*snd) params), ty in
  let e = { e with
            functions = StringMap.add funname function_type e.functions;
            locales = BindingMap.empty
          } in
  let e = List.fold_left (fun e (name, ty) ->
      let tyloc = Ast.PosMap.get (Type.Fixed.annot ty) in
      let ty = expand e ty tyloc in
      let e, ty = ty2typeContrainte e ty tyloc in
      {e with locales = BindingMap.add name ty e.locales}
    ) e params
  in
  let e = List.fold_left (fun env i -> collect_contraintes_instruction env i ty) e instructions in
  e

let empty = {
  automap = IntMap.empty;
  gamma = StringMap.empty;
  contrainteMap = IntMap.empty;
  fields = StringMap.empty;
  enum = StringMap.empty;
  functions = StringMap.empty;
  locales = BindingMap.empty;
  contraintes = [];
}

let map_ty env prog =
  let map_ty ty =
    let rec f t = match Type.Fixed.unfix t with
      | Type.Auto ->
        let annot = Type.Fixed.annot t in
        let contrainte =
          try IntMap.find annot env.automap
          with Not_found ->
            error_no_auto_type env.automap annot t
        in let ty = extract_typed contrainte in f ty
      | Type.Enum ( name:: _) ->
        let (_, name) = StringMap.find name env.enum in
        Type.named name
      | Type.Struct ( (name, _ ):: _) ->
        let (_, _, name) =StringMap.find name env.fields in
        Type.named name
      | _ -> t
    in Type.Fixed.Deep.map f ty
  in
  let f instr =
    let a = Instr.Fixed.annot instr in
    match Instr.unfix instr with
    | Instr.Declare (p1, ty, p2, opt) ->
      let ty = map_ty ty in Instr.fixa a (Instr.Declare (p1, ty, p2, opt) )
    | Instr.AllocArray (p1, ty, p2, p3, opt) ->
      let ty = map_ty ty in Instr.fixa a (Instr.AllocArray (p1, ty, p2, p3, opt) )
    | Instr.AllocRecord (p1, ty, p2, opt) ->
      let ty = map_ty ty in Instr.fixa a (Instr.AllocRecord (p1, ty, p2, opt) )
    | Instr.Print li ->
      let li = List.map (function
          | Instr.PrintExpr (ty, p1) ->
            let ty = map_ty ty in Instr.PrintExpr (ty, p1)
          | Instr.StringConst str -> Instr.StringConst str) li
      in Instr.fixa a (Instr.Print li)
    | Instr.Read li ->
      let li = List.map (function
          | Instr.DeclRead (ty, p1, opt) ->
            let ty = map_ty ty in Instr.DeclRead (ty, p1, opt)
          | Instr.ReadExpr (ty, p1) ->
            let ty = map_ty ty in Instr.ReadExpr (ty, p1)
          | Instr.Separation -> Instr.Separation) li
      in Instr.fixa a (Instr.Read li )
    | Instr.Untuple (li, e, opt) ->
      let li = List.map (fun (t, name) -> map_ty t, name) li
      in Instr.fixa a (Instr.Untuple (li, e, opt) )
    | _ -> instr
  in
  let map_instrs instrs =
    List.map (fun i ->
        Instr.Writer.Deep.map f ( f i)
      ) instrs
  in
  let toplvl = function
    | Prog.DeclarFun (var, ty, params, instrs, opt) ->
      let ty = map_ty ty in
      let params = List.map
          (fun (a, b) -> a, map_ty b) params
      in
      let instrs = map_instrs instrs in
      Prog.DeclarFun (var, ty, params, instrs, opt)
    | x -> x
  in
  { prog with
    Prog.funs = List.map toplvl prog.Prog.funs;
    Prog.main = Option.map map_instrs prog.Prog.main;
  }


let not_done
    (env:env)
    ((t1 : typeContrainte ref), (t2 : typeContrainte ref)) : bool=
  match !t1, !t2 with
  | Typed (t1, loc1), Typed (t2, loc2) ->
    check_types env t1 t2 loc1 loc2;
    false
  | _ -> true

let unify_once env =
  let modified = List.fold_left (fun acc (a, b) ->
      unify env a b || acc) false env.contraintes in
  (modified ,
   {env with
    contraintes = List.filter (not_done env) env.contraintes
   }
  )

let rec unify_contraintes env =
  let modified, env = unify_once env in
  if modified
  then unify_contraintes env
  else
    match env.contraintes with
    | [] -> env
    | li ->
      begin
        error_no_contraintes li
      end

let process_fundecl e ((funname, ty, params, instructions) as tuple) =
  let e = collect_contraintes e tuple in
  unify_contraintes e

let process_tfun env p = match p with
  | Prog.Unquote _ -> assert false
  | Prog.DeclarFun (varname, ty, li, instrs, _) ->
    process_fundecl env (varname, ty, li, instrs)
  | Prog.DeclareType (name, ty) ->
    { env with
      gamma = StringMap.add name ty env.gamma;
      fields = (match (Type.Fixed.unfix ty) with
          | Type.Struct li ->
            List.fold_left
              (fun acc (fieldname, ty_field) ->
                 StringMap.add fieldname (ty_field, ty, name) acc
              ) env.fields li
          | _ -> env.fields);
      enum = (match (Type.Fixed.unfix ty) with
          | Type.Enum li ->
            List.fold_left
              (fun acc fname ->
                 StringMap.add fname (ty, name) acc
              ) env.enum li
          | _ -> env.enum
        )
    }
  | Prog.Macro (name, ty, params, _) ->
    let tyloc = Ast.PosMap.get (Type.Fixed.annot ty) in
    let ty = expand env ty tyloc in
    let env, ty = ty2typeContrainte env ty tyloc in
    let function_type = (List.map ((fun x ->
        let tyloc = Ast.PosMap.get (Type.Fixed.annot x) in
        expand env x tyloc) @* snd) params), ty in
    { env with functions = StringMap.add name function_type env.functions}
  | Prog.Comment _ -> env

(** {2 Main function} *)
let process (prog: 'lex Prog.t) =
  let env = List.fold_left process_tfun empty prog.Prog.funs
  in
  let env = match prog.Prog.main with
    | Some main -> process_fundecl env ("main", Type.void, [], main)
    | None -> env
  in
  let prog = map_ty env prog
  in env, prog

let type_for_enum en env =
  try
    let (t, _) = StringMap.find en env.enum in
    t
  with Not_found ->
    raise ( Error (fun f ->
        Format.fprintf f "Cannot find type for enum field %s\n" en))

let typename_for_enum en env =
  try
    let (_, name) = StringMap.find en env.enum in
    name
  with Not_found ->
    raise ( Error (fun f ->
        Format.fprintf f "Cannot find typename for enum %s\n" en))

let typename_for_field en env =
  try
    let (_, _, name) = StringMap.find en env.fields in
    name
  with Not_found ->
    raise ( Error (fun f ->
        Format.fprintf f "Cannot find typename for field %s\n" en))

let byname name env = StringMap.find name env.gamma

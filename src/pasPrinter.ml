(*
 * Copyright (c) 2012 - 2016, Prologin
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

(** Pascal Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Ast
open Helper

let config macros =
  let open Format in
  let open Expr in
  let prio_binop op = match op with
    | Mul -> assoc 5
    | Div
    | Mod -> nonassocr 7
    | And -> assoc 9
    | Add -> assoc 11
    | Sub -> nonassocr 11
    | Or -> assoc 13
    | Eq -> nonassocl 15
    | Diff -> nonassocl 15
    | Lower
    | LowerEq
    | Higher
    | HigherEq -> assoc 17
  in
  let print_lief prio f = function
    | Char c -> fprintf f "#%d" (int_of_char c)
    | Nil -> fprintf f "Nil"
    | String i ->
      fprintf f "'";
      String.fold_left (fun () c ->
          let ns = 
            if is_printable c then String.of_char c
            else "'#"^(string_of_int (int_of_char c))^"'"
          in fprintf f "%s" ns ) () i;
      fprintf f "'"
    | x -> print_lief prio f x in
  let print_op f op = fprintf f (match op with
      | Add -> "+"
      | Sub -> "-"
      | Mul -> "*"
      | Div -> "Div"
      | Mod -> "Mod"
      | Or -> "or"
      | And -> "and"
      | Lower -> "<"
      | LowerEq -> "<="
      | Higher -> ">"
      | HigherEq -> ">="
      | Eq -> "="
      | Diff -> "<>") in
  let print_mut conf prio f m = Mutable.Fixed.Deep.fold
      (print_mut0 "%a%a" "[%a]" "%a^.%s" conf) m f prio in
  {
    prio_binop;
    prio_unop;
    print_varname;
    print_lief;
    print_op;
    print_unop;
    print_mut;
    macros
  }

let print_expr macros e f p =
  let open Format in
  let open Expr in
  let print_expr0 config e f prio_parent = match e with
    | UnOp (a, Not) -> fprintf f "not(%a)" a nop
    | _ -> print_expr0 config e f prio_parent
  in
  let config = config macros in
  Fixed.Deep.fold (print_expr0 config) e f p

let print_instr macros i =
  let open Ast.Instr in
  let open Format in
  let config = config macros in
  let instructions f instrs = print_list (fun f i -> i.p f ()) sep_nl f instrs in
  let bloc f li = fprintf f "@[<v 2>begin@\n%a@]@\nend" instructions li in
  let def_fields name f li =
    print_list
      (fun f (fieldname, expr) ->
         Format.fprintf f "%a^.%s := %a;"
           print_varname name
           fieldname
           expr nop
      ) sep_nl f li in
  let print f t expr = fprintf f "@[<h>Write(%a);@]" expr nop in
  let read t pp f =
    match Type.unfix t with
    | Type.Integer -> fprintf f "@[<h>%a := read_int_();@]" pp ()
    | Type.Char -> fprintf f "@[<h>%a := read_char_();@]" pp ()
    | _ -> assert false (* type non géré*) in
  let p f () = match i with
      Tag _ | Untuple _ | SelfAffect _ | Unquote _-> assert false
    | Declare (var, _, expr, _) -> fprintf f "@[<h>%a@ :=@ %a;@]" print_varname var expr nop
    | Affect (mutable_, expr) ->
      fprintf f "@[<h>%a@ :=@ %a;@]" (config.print_mut config nop) mutable_ expr nop
    | ClikeLoop (init, cond, incr, li) -> assert false
    | Loop (varname, expr1, expr2, li) -> fprintf f "@[<h>for@ %a@ :=@ %a@ to @ %a do@\n@]%a;"
                                            print_varname varname expr1 nop expr2 nop bloc li
    | While (expr, li) ->
      fprintf f "@[<hov>while %a do@]@\n%a;" expr nop bloc li
    | Comment s -> fprintf f "{%s}" s
    | Return e -> fprintf f "@[<hov>exit(%a);@]" e nop
    | AllocRecord (name, t, el, _) ->
      fprintf f "new(%a);@\n%a" print_varname name (def_fields name) el
    | AllocArray (binding, type_, len, None, u) ->
      fprintf f "@[<hov>SetLength(%a, %a);@]" print_varname binding len nop
    | AllocArray (binding, type_, len, Some ( (b, l) ), u) -> assert false
    | AllocArrayConst (b, t, len, e, opt) -> assert false
    | If (e, ifcase, elsecase) -> begin
        match elsecase with
        | [] -> fprintf f "@[<h>if@ %a@]@\nthen@\n@[<v2>  %a;@]" e nop bloc ifcase
        | [instr] when instr.is_if ->
          fprintf f "@[<h>if@ %a@] then@\n@[<v 2>  %a@]@\nelse %a;"
            e nop bloc ifcase instr.p ()
        | _ -> fprintf f "@[<h>if@ %a@]@\nthen@\n@[<v 2>  %a@]@\nelse@\n@[<v 2>  %a;@]"
                 e nop bloc ifcase bloc elsecase
      end
    | Call (var, li) -> begin match StringMap.find_opt var macros with
        | Some ( (t, params, code) ) -> pmacros f "%s;" t params code li nop
        | None ->
          if li = [] then fprintf f "%s;" var
          else fprintf f "%s(%a);" var (print_list (fun f expr -> expr f nop) sep_c) li
      end
    | Read li ->
      let li = List.map (function
          | Separation -> fun f -> fprintf f "@[<hov>skip();@]"
          | DeclRead (t, var, _option) -> read t (fun f () -> print_varname f var)
          | ReadExpr (t, m) -> read t (fun f () -> config.print_mut config nop f m)) li
      in print_list (fun f e -> e f) sep_nl f li
    | Print li ->
      let li = List.map (function
          | StringConst str -> fun f -> print f Type.string (fun f prio -> config.print_lief prio f (Expr.String str))
          | PrintExpr (t, expr) -> fun f -> print f t expr ) li
      in print_list (fun f e -> e f) sep_nl f li
    | Incr _ | Decr _ -> assert false
  in
  {
    is_multi_instr = false;
    is_if=is_if i;
    is_if_noelse=is_if_noelse i;
    is_comment=is_comment i;
    p=p;
    default=();
    print_lief = print_lief;
  }

let print_instr macros i =
  let open Ast.Instr.Fixed.Deep in
  fold (print_instr macros) (mapg (print_expr macros) i)

let rec ptype declared_types options f t =
  match TypeMap.find_opt t declared_types with
  | Some s -> Format.fprintf f (if options then "^%s" else"%s") s
  | None ->
    match Type.unfix t with
    | Type.Integer -> Format.fprintf f (if options then "^Longint" else "Longint")
    | Type.String -> Format.fprintf f (if options then "^string" else "string")
    | Type.Array a -> Format.fprintf f "array of %a"  (ptype declared_types false) a
    | Type.Option a -> ptype declared_types true f a
    | Type.Void ->  Format.fprintf f "void"
    | Type.Bool -> Format.fprintf f (if options then "^boolean" else "boolean")
    | Type.Char -> Format.fprintf f (if options then "^char" else "char")
    | Type.Named n -> Format.fprintf f "%s" n
    | Type.Struct li -> Format.fprintf f "a struct"
    | Type.Enum _ -> Format.fprintf f "an enum"
    | Type.Lexems | Type.Auto | Type.Tuple _ -> assert false
      
let ptype declared_types f t = ptype declared_types false f t

let declaredvars bindings instrs =
    List.fold_left
      (Instr.Writer.Deep.fold
         (fun bindings i ->
            match Instr.Fixed.unfix i with
            | Instr.Loop (b, _, _, _) ->
              BindingMap.add b Type.integer bindings

            | Instr.Read li ->
              List.fold_left (fun bindings -> function
                  | Instr.DeclRead (t, b, _) -> BindingMap.add b t bindings
                  | _ -> bindings) bindings li
            | Instr.Declare (b, t, _, _) ->
              BindingMap.add b t bindings
            | Instr.AllocArray (b, t, _, _, _) ->
              BindingMap.add b (Type.array t) bindings
            | Instr.AllocRecord (b, t, _, _) ->
              BindingMap.add b t bindings
            | _ -> bindings
         )
      )
      bindings
      instrs


let declarevars declared_types f instrs =
  let bindings = declaredvars BindingMap.empty instrs
  in
  if bindings = BindingMap.empty then ()
  else
    Format.fprintf f "@\n@[<v 2>var%a@]"
      (BindingMap.fold
         (fun key value next f () ->
            Format.fprintf f "%a@\n%a : %a;"
              next () print_varname key (ptype declared_types) value
         )
         bindings
         (fun f () -> ())
      )
      ()

let out_declare_type prefix f a c =
  List.iter (function
      | DeclArray (name, t, name2, decl) ->
        Format.fprintf f (if prefix then "type %s = %a;@\n"  else "%s = %a;@\n") name (ptype decl) t
      | DeclPtr (name, t, decl) ->
        Format.fprintf f (if prefix then "type %s = %a;@\n" else "%s = %a;@\n") name (ptype decl) t
    ) (List.rev c)

let declare_type declared_types t =
  let a, b, c = pas_declare_type (fun n -> n) StringMap.empty declared_types [] t
  in (fun f prefix -> out_declare_type prefix f a c), b

let declare_types declared_types instrs =
  let a, b, c = pas_declare_types (fun n -> n) instrs StringMap.empty declared_types
  in (fun f prefix -> out_declare_type prefix f a c), b

let prog f prog =
    let instructions macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "pas" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> (print_instr macros t).p f ()) sep_nl f li in
    let macros, items, declared_types = List.fold_left
        (fun (macros, li, declared_types) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li, declared_types
           | Prog.Comment s -> macros, (fun f -> Format.fprintf f "{%s}" s) :: li, declared_types
           | Prog.DeclarFun (funname, t, vars, instrs, _opt) ->
             let pr0, declared_types = declare_type declared_types t in
             let pr1, declared_types = declare_types declared_types instrs in
             let pr, declared_types = List.fold_left
                 (fun (pr, declared_types) (_, t) ->
                    let pr', declared_types = declare_type declared_types t
                    in (fun f () -> Format.fprintf f "%a%a" pr () pr' true), declared_types
                 )
                 ((fun f () ->
                     (* TODO chercher à merger pr0 et pr1 en évitant de réécrire "type"*)
                     Format.fprintf f "%a%a" pr0 true pr1 true), declared_types) vars in
             macros, (fun f ->
                 Format.fprintf f "%a%a%a@\nbegin@\n@[<v 2>  %a@]@\nend;@\n"
                   pr ()
                   (fun f () ->
                      match Type.unfix t with
                      | Type.Void -> Format.fprintf f "@[<h>procedure %s(%a);@]"  funname
                                       (print_list
                                          (fun t (binding, type_) ->
                                             Format.fprintf t "%a : %a" print_varname binding
                                               (ptype declared_types) type_
                                          )
                                          sep_dc
                                       ) vars
                      | _ -> Format.fprintf f "@[<h>function %s(%a) : %a;@]" funname
                               (print_list
                                  (fun t (binding, type_) ->
                                     Format.fprintf t "%a : %a" print_varname binding
                                       (ptype declared_types) type_
                                  )
                                  sep_dc
                               ) vars
                               (ptype declared_types) t
                   ) ()
                   (declarevars declared_types) instrs
                   (instructions macros) instrs
               ) :: li, declared_types
           | Prog.DeclareType (name, t) ->
             let pr, declared_types = declare_type declared_types t in
             macros, (fun f ->
               match (Type.unfix t) with
                 Type.Struct li ->
                 Format.fprintf f "@[<v2>type %s=^%s_r;@\n%a%s_r = record@\n@[<v 2>  %a@]@\nend;@]@\n"
                   name name
                   pr false
                   name
                   (print_list
                      (fun t (name, type_) ->
                         Format.fprintf t "%s : %a;" name (ptype declared_types) type_
                      ) sep_nl
                   ) li
               | Type.Enum li ->
                 Format.fprintf f "Type %s = (@\n@[<v2>  %a@]);@\n" name
                   (print_list (fun t name -> Format.fprintf t "%s" name) sep_c) li
               | _ -> assert false) :: li, declared_types
           | _ -> macros, li, declared_types
        ) (StringMap.empty, [], TypeMap.empty) prog.Prog.funs in
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    Format.fprintf f "program %s;@\n%a%s%s%s%s%s@\n%a@\n%a.@\n@\n"
      (String.concat "" ["prog"; prog.Prog.progname])
      (fun f () ->
         if Tags.is_taged "use_math" ||
            Tags.is_taged "use_pascal_math"
         then Format.fprintf f "Uses math;@\n"
      ) ()
      (if need then "
var global_char : char;
var global_has_char : boolean;

procedure skip_char();
begin
   global_has_char := true;
   read(global_char);
end; " else "")
      ( if need_stdinsep then "
procedure skip();
var
   n : char;
   t : char;
   s : char;
begin
   n := #13;
   t := #10;
   s := #32;
   if not( global_has_char ) then
      skip_char();
   while (global_char = s) or (global_char = n) or (global_char = t) do
   begin
      skip_char();
   end;
end;" else "")
      (if need_readint || need_readchar then "
function read_char_aux() : char;
begin
   if global_has_char then
      read_char_aux := global_char
   else
   begin
      skip_char();
      read_char_aux := global_char;
   end
end;" else "")
      (if need_readchar then "
function read_char_() : char;
var
   c : char;
begin
   c := read_char_aux();
   skip_char();
   read_char_ := c;
end;" else "")
      (if need_readint then "
function read_int_() : Longint;
var
   c    : char;
   i    : Longint;
   sign :  Longint;
begin
   i := 0;
   c := read_char_aux();
   if c = '-' then begin
      skip_char();
      sign := -1;
   end
   else
      sign := 1;

   repeat
      c := read_char_aux();
      if (ord(c) <=57) and (ord(c) >= 48) then
      begin
         i := i * 10 + ord(c) - 48;
         skip_char();
      end
      else
         exit(i * sign);
   until false;
end;
" else "")
    (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f main ->
           let pr, declared_types = declare_types declared_types main in
           Format.fprintf f "%a%a@\nbegin@\n@[<v 2>  %a@]@\nend" pr true
           (declarevars declared_types) main
           (instructions macros) main
         )) prog.Prog.main

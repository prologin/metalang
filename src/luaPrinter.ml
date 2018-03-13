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

(** LUA Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Helper
open Ast
let print_op f op = 
  let open Ast.Expr in Format.fprintf f (match op with
      | Add -> "+"
      | Sub -> "-"
      | Mul -> "*"
      | Div -> "/"
      | Mod -> "%%"
      | Or -> "or"
      | And -> "and"
      | Lower -> "<"
      | LowerEq -> "<="
      | Higher -> ">"
      | HigherEq -> ">="
      | Eq -> "=="
      | Diff -> "~=")

let print_lief prio f = function
  | Ast.Expr.Char c -> Format.fprintf f "%d" (int_of_char c)
  | x -> print_lief prio f x

let print_mut conf prio f m = Mutable.Fixed.Deep.fold
    (print_mut0 "%a%a" "[%a]" "%a.%s" conf) m f prio

let config macros = {
  prio_binop;
  prio_unop;
  print_varname;
  print_lief;
  print_op;
  print_unop;
  print_mut;
  macros
}

let print_expr config e f p =
  let open Format in
  let open Ast.Expr in
  let print_expr0 config e f prio_parent = match e with
    | BinOp (a, (Div as op), b) ->
      let _, priol, prior = prio_binop op in
      fprintf f "trunc(%a %a %a)" a priol print_op op b prior
    | BinOp (a, Mod, b) -> fprintf f "math.mod(%a, %a)" a nop b nop
    | UnOp (a, Not) -> fprintf f "not(%a)" a nop
    | Tuple li -> fprintf f "{%a}" (print_list (fun f x -> x f nop) sep_c) li
    | Record li -> fprintf f "{%a}" (print_list (fun f (name, x) ->
        fprintf f "%s=%a" name x nop) sep_c) li
    | _ -> print_expr0 config e f prio_parent
  in Fixed.Deep.fold (print_expr0 config) e f p

let print_instr c i =
  let open Ast.Instr in
  let open Format in
  let block f li = fprintf f "@\n%a" (print_list (fun f i -> i.p f false) sep_nl) li in
  let p f inelseif = match i with
    | Incr _
    | Decr _ -> assert false
    | Declare (var, ty, e, _) -> fprintf f "local %a = %a" c.print_varname var e nop
    | SelfAffect (mut, op, e) -> assert false
    | Affect (mut, e) -> fprintf f "%a = %a" (c.print_mut c nop) mut e nop
    | ClikeLoop (init, cond, incr, li) -> assert false
    | Loop (var, e1, e2, li) -> fprintf f "@[<v 4>for @[<h>%a = %a, %a@] do%a@]@\nend"
                                  c.print_varname var e1 nop e2 nop
                                  block li
    | While (e, li) -> fprintf f "@[<v 4>while @[<h>%a@] do%a@]@\nend" e nop block li
    | Comment s -> fprintf f "--[[%s--]]" s
    | Tag s -> assert false
    | Return e -> fprintf f "return %a" e nop
    | AllocArray (name, t, e, None, opt) -> fprintf f "@[<h>local %a@ =@ {}@]" c.print_varname name
    | AllocArray (name, t, e, Some (var, lambda), opt) -> assert false
    | AllocArrayConst (name, ty, len, lief, opt) -> assert false
    | AllocRecord (name, ty, list, opt) ->
      fprintf f "@[<v 4>%a = {%a}@\n@]" c.print_varname name
        (print_list (fun f (field, x) -> fprintf f "%s:%a" field x nop) sep_nl) list
    | If (e, listif, []) when inelseif ->
      fprintf f "if %a then%a@]@\nend" e nop block listif
    | If (e, listif, [elsecase]) when inelseif && elsecase.is_if ->
      fprintf f "if %a then%a@]@\n@[<v 4>else%a" e nop block listif elsecase.p true   
    | If (e, listif, listelse)  when inelseif ->
      fprintf f "if %a then%a@]@\n@[<v 4>else %a@]@\nend" e nop block listif block listelse
    | If (e, listif, []) ->
      fprintf f "@[<v 4>if %a then%a@]@\nend" e nop block listif
    | If (e, listif, [elsecase]) when elsecase.is_if ->
      fprintf f "@[<v 4>if %a then%a@]@\n@[<v 4>else%a" e nop block listif elsecase.p true
    | If (e, listif, listelse) ->
      fprintf f "@[<v 4>if %a then%a@]@\n@[<v 4>else %a@]@\nend" e nop block listif block listelse
    | Call (func, li) ->  begin match StringMap.find_opt func c.macros with
        | Some ( (t, params, code) ) -> pmacros f "%s" t params code li nop
        | None -> fprintf f "%s(%a)" func (print_list (fun f x -> x f nop) sep_c) li
      end
    | Print [PrintExpr ( Ast.Type.Fixed.F(_, Ast.Type.Integer) , expr)] -> fprintf f "io.write(%a)" expr nop
    | Print [StringConst s] -> fprintf f "io.write(%a)" (print_lief nop) (Expr.String s)
    | Print li->
      let li = List.pack 50 li in
      let li = List.map (fun li f ->
          let format, exprs = extract_multi_print clike_noformat format_type li in
          match exprs with
          | [] -> fprintf f "io.write(\"%s\")" format
          | _ -> fprintf f "io.write(string.format(\"%s\", %a))" format
                   (print_list (fun f (t, e) -> e f nop) sep_c) exprs) li
      in print_list (fun f g -> g f) sep_nl f li
    | Read li ->
      let li = List.map (fun i f -> match i with
          | Separation -> fprintf f "stdinsep()"
          | DeclRead (ty, name, _) -> fprintf f "local %a = read%a()" c.print_varname name
                                        (fun f ty -> match Type.unfix ty with
                                           | Type.Integer -> fprintf f "int"
                                           | Type.Char -> fprintf f "char"
                                           | _ -> assert false) ty
          | ReadExpr (ty, mut) ->fprintf f "%a = read%a()" (c.print_mut c nop) mut
                                   (fun f ty -> match Type.unfix ty with
                                      | Type.Integer -> fprintf f "int"
                                      | Type.Char -> fprintf f "char"
                                      | _ -> assert false) ty) li
      in
      fprintf f "%a" (print_list (fun f g -> g f) sep_nl) li
    | Untuple (li, expr, opt) -> fprintf f "%a = unpack(%a)" (print_list c.print_varname sep_c) (List.map snd li) expr nop
    | Unquote e -> assert false in
  let is_multi_instr = match i with
    | Read (hd::tl) -> true
    | _ -> false in
  {
    is_multi_instr = is_multi_instr;
    is_if=is_if i;
    is_if_noelse=is_if_noelse i;
    is_comment=is_comment i;
    p=p;
    default = false;
    print_lief = c.print_lief;
  }

let print_instr macros i =
  let open Ast.Instr.Fixed.Deep in
  let c = config macros in
  let i = (fold (print_instr c) (mapg (print_expr c) i))
  in fun f -> i.p f i.default

let prog f prog =
    let instructions macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "lua" li
          with Not_found -> List.assoc "" li) macros in
      print_list (fun f i -> print_instr macros i f) sep_nl f li in
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Comment s -> macros, (fun f -> Format.fprintf f "--[[%s--]]@\n" s) :: li
           | Prog.DeclarFun (funname, t, vars, instrs, _opt) ->
             macros, (fun f -> Format.fprintf f "@[<v 2>@[function@ %s (%a)@]@\n%a@]@\nend@\n"
                         funname
                         (print_list print_varname sep_c) (List.map fst vars)
                         (instructions macros) instrs) :: li
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    Format.fprintf f "%a%a%a%a%a%a%a%a@\n%a"
      (fun f () -> if Tags.is_taged "use_readintline" then
          Format.fprintf f "
function readintline()
  local tab = {}
  for a in string.gmatch(io.read(\"*l\"), \"-?%%d+\") do
    table.insert(tab, tonumber(a))
  end
  return tab
end@\n") ()
      (fun f () -> if Tags.is_taged "use_readcharline" then
          Format.fprintf f "
function readcharline()
  local tab = {}
  local i = 0
  for a in string.gmatch(io.read(\"*l\"), \".\") do
    table.insert(tab, string.byte(a))
  end
  return tab
end@\n") ()
      (fun f () -> if Tags.is_taged "__internal__div" then Format.fprintf f "
function trunc(x)
  return x>=0 and math.floor(x) or math.ceil(x)
end@\n") ()
      (fun f () -> if need then Format.fprintf f "buffer =  \"\"@\n") ()
      (fun f () -> if need_readint then Format.fprintf f "function readint()
    if buffer == \"\" then buffer = io.read(\"*line\") end
    local num, buffer0 = string.match(buffer, '^([\\-0-9]*)(.*)')
    buffer = buffer0
    return tonumber(num)
end@\n") ()
      (fun f () -> if need_readchar then Format.fprintf f "function readchar()
    if buffer == \"\" then buffer = io.read(\"*line\") end
    local c = string.byte(buffer)
    buffer = string.sub(buffer, 2, -1)
    return c
end@\n") ()
      (fun f () -> if need_stdinsep then Format.fprintf f "
function stdinsep()
    if buffer == \"\" then buffer = io.read(\"*line\") end
    if buffer ~= nil then buffer = string.gsub(buffer, '^%%s*', \"\") end
end@\n") ()
    (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (instructions macros)) prog.Prog.main

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


(** Visual Basic .NET Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Helper
open Ast

let print_op f op =
  Format.fprintf f
    "%s"
    (match op with
     | Expr.Add -> "+"
     | Expr.Sub -> "-"
     | Expr.Mul -> "*"
     | Expr.Div -> "\\"
     | Expr.Mod -> "Mod"
     | Expr.Or -> "OrElse"
     | Expr.And -> "AndAlso"
     | Expr.Lower -> "<"
     | Expr.LowerEq -> "<="
     | Expr.Higher -> ">"
     | Expr.HigherEq -> ">="
     | Expr.Eq -> "="
     | Expr.Diff -> "<>"
    )

let print_unop f op =
  let open Ast.Expr in
  Format.fprintf f (match op with
      | Neg -> "-"
      | Not -> "Not ")

let prio_unop op =
  let open Ast.Expr in match op with
  | Neg -> 1
  | Not -> 0

let pchar f c =
  if (c >= 'A' && c <= 'Z' ) ||
     (c >= 'a' && c <= 'z' ) ||
     (c >= '0' && c <= '9' ) ||
     (c = '-' || c = '_' )
  then Format.fprintf f "\"%c\"C" c
  else Format.fprintf f "Chr(%d)" (int_of_char c)

let print_lief tyenv prio f = function
  | Ast.Expr.Char c -> pchar f c
  | Ast.Expr.String s -> string_noprintable pchar false f s
  | Ast.Expr.Enum e ->
    let t = Typer.typename_for_enum e tyenv in
    Format.fprintf f "%s.%s" t e
  | Ast.Expr.Nil -> Format.fprintf f "Nothing"
  | x -> Helper.print_lief prio f x

let print_mut conf priority f m = Ast.Mutable.Fixed.Deep.fold
    (print_mut0 "%a%a" "(%a)" "%a.%s" conf) m f priority

let config tyenv macros = {
  prio_binop;
  prio_unop;
  print_varname;
  print_lief = print_lief tyenv;
  print_op;
  print_unop;
  print_mut;
  macros
}

let print_expr tyenv config e f p = Ast.Expr.Fixed.Deep.fold (print_expr0 config) e f p
let ptype f t =
  let open Type in let open Format in
  let ptype ty f option = match ty with
  | Integer -> fprintf f (if option then "Integer?" else "Integer")
  | String -> fprintf f "String"
  | Array a -> fprintf f "%a()" a false
  | Option a -> a f true
  | Void ->  fprintf f "Void"
  | Bool -> fprintf f (if option then "Boolean?" else "Boolean")
  | Char -> fprintf f (if option then "Char?" else "Char")
  | Named n -> fprintf f "%s" n
  | Struct li -> fprintf f "a struct"
  | Enum _ -> fprintf f "an enum"
  | Auto | Lexems | Tuple _ -> assert false
  in Fixed.Deep.fold ptype t f false

let print_instr tyenv c i =
  let open Ast.Instr in
  let open Format in
  let block value f li = fprintf f "@\n%a" (print_list (fun f i -> i.p f (false, value)) sep_nl) li in
  let pread f ty = match Type.unfix ty with
    | Type.Integer -> fprintf f "readInt"
    | Type.Char -> fprintf f "readChar"
    | _ -> assert false in
  let p f (inelseif, inlambda) =
    let block = block inlambda in match i with
    | Declare (var, ty, e, _) -> fprintf f "Dim %a As %a = %a" c.print_varname var
                                   ptype ty
                                   e nop
    | SelfAffect _ -> assert false
    | Affect (mut, e) -> fprintf f "%a = %a" (c.print_mut c nop) mut e nop
    | ClikeLoop (init, cond, incr, li) -> assert false
    | Loop (var, e1, e2, li) -> fprintf f "@[<v 4>@[<h>For %a As Integer = %a To %a@]%a@]@\nNext"
                                  c.print_varname var e1 nop e2 nop
                                  block li
    | While (e, li) -> fprintf f "@[<v 4>Do While @[<h>%a@]%a@]@\nLoop" e nop block li
    | Comment s -> let lic = String.split s '\n' in
      print_list (fun f s -> Format.fprintf f "'%s@\n" s) nosep f lic
    | Tag s -> assert false
    | Return e -> fprintf f "Return %a" e nop
    | AllocArray (name, t, e, None, opt) ->
      let rec g f t = match Type.unfix t with
        | Type.Array ty -> g (fun ff () -> Format.fprintf ff "%a()" f ()) ty
        | _ -> f, t
      in let parent, t = g (fun f () -> ()) t in
      fprintf f "@[<hov>Dim %a(%a)%a As %a"
        c.print_varname name
        e nop
        parent ()
        ptype t
    | AllocArray (name, t, e, Some (var, lambda), opt) -> assert false
    | AllocArrayConst (name, ty, len, lief, opt) -> assert false
    | AllocRecord (name, ty, list, opt) ->
      fprintf f "Dim %a As %a = new %a()@\n%a"
        c.print_varname name
        ptype ty
        ptype ty
        (print_list (fun f (field, x) -> fprintf f "%a.%s = %a" 
                        c.print_varname name field x nop) sep_nl) list
    | If (e, listif, []) when inelseif ->
      fprintf f "If %a Then%a@]@\nEnd If" e nop block listif
    | If (e, listif, [elsecase]) when inelseif && elsecase.is_if ->
      fprintf f "If %a Then%a@]@\n@[<v 4>Else%a" e nop block listif elsecase.p (true, inlambda)          
    | If (e, listif, listelse)  when inelseif ->
      fprintf f "If %a Then%a@]@\n@[<v 4>Else %a@]@\nEnd If" e nop block listif block listelse
    | If (e, listif, []) ->
      fprintf f "@[<v 4>If %a Then%a@]@\nEnd If" e nop block listif
    | If (e, listif, [elsecase]) when elsecase.is_if ->
      fprintf f "@[<v 4>If %a Then%a@]@\n@[<v 4>Else%a" e nop block listif elsecase.p (true, inlambda)          
    | If (e, listif, listelse) ->
      fprintf f "@[<v 4>If %a Then%a@]@\n@[<v 4>Else %a@]@\nEnd If" e nop block listif block listelse
    | Call (func, li) ->
      begin match StringMap.find_opt func c.macros with
        | Some ( (t, params, code) ) -> pmacros f "%s" t params code li nop
        | None -> fprintf f "%s(%a)" func (print_list (fun f x -> x f nop) sep_c) li
      end
    | Print [StringConst s] -> fprintf f "Console.Write(%a)" (c.print_lief jlike_prio_operator) (Expr.String s)
    | Print [PrintExpr (_, e)] -> fprintf f "Console.Write(%a)" e nop
    | Print li->
      fprintf f "Console.Write(%a)"
        (print_list
           (fun f e ->
              match e with
              | StringConst s -> c.print_lief jlike_prio_operator f (Expr.String s)
              | PrintExpr (_, e) -> e f jlike_prio_operator)
           (fun t f1 e1 f2 e2 -> Format.fprintf t "%a & %a" f1 e1 f2 e2)) li
    | Read li ->
      let li = List.map (function
          | Separation -> fun f -> fprintf f "@[stdin_sep@]"
          | DeclRead (t, name, _) -> fun f -> fprintf f "Dim %a As %a = %a"
              c.print_varname name ptype t pread t
          | ReadExpr (t, m) -> fun f -> fprintf f "%a = %a"
              (c.print_mut c nop) m pread t) li
      in
      fprintf f "%a" (print_list (fun f g -> g f) sep_nl) li
    | Untuple (li, expr, opt) -> assert false
    | Unquote _ | Incr _ | Decr _ -> assert false in
  let is_multi_instr = match i with
    | Read (hd::tl) -> true
    | _ -> false in
  {
    is_multi_instr = is_multi_instr;
    is_if=is_if i;
    is_if_noelse=is_if_noelse i;
    is_comment=is_comment i;
    p=p;
    default = (false, false);
    print_lief = c.print_lief;
  }

let print_instr tyenv macros i =
  let open Ast.Instr.Fixed.Deep in
  let c = config tyenv macros in
  let i = (fold (print_instr tyenv c) (mapg (print_expr tyenv c) i))
  in fun f -> i.p f i.default

let instrs typerEnv macros f (t:Utils.instr list) =
    let macros = StringMap.map (fun (ty, params, li) ->
        ty, params,
        try List.assoc "vb" li
        with Not_found -> List.assoc "" li) macros
    in print_list (fun f t -> print_instr typerEnv macros t f) sep_nl f t

let main typerEnv macros f main =
    Format.fprintf f "Sub Main()@\n  @[<v>%a@]@\nEnd Sub@\n"
      (instrs typerEnv macros) main


let val_or_ref f t = match Type.unfix t with
    | Type.Integer
    | Type.Void
    | Type.Bool
    | Type.Char
    | Type.Enum _ ->  Format.fprintf f "ByVal"
    | _ ->  Format.fprintf f "ByRef"

let print_proto f (funname, t, li) =
    Format.fprintf f "%s(%a)%a" funname
      (print_list
         (fun t (binding, type_) ->
            Format.fprintf t "%a %a@ as@ %a"
              val_or_ref type_ print_varname binding
              ptype type_
         ) sep_c
      ) li
      (fun f () -> match Type.unfix t with
         | Type.Void -> ()
         | _ ->
           Format.fprintf f " As %a" ptype t) ()

let prog typerEnv f (prog: Utils.prog) =
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment str -> let lic = String.split str '\n' in
             macros, (fun f -> print_list
               (fun f s -> Format.fprintf f "'%s@\n" s) nosep
               f
               lic) :: li
           | Prog.DeclarFun (funname, t, vars, liinstrs, _opt) ->
             macros, (fun f ->
               match Type.unfix t with
               | Type.Void ->
                 Format.fprintf f "Sub @[<h>%a@]@\n@[<v 2>  %a@]@\nEnd Sub"
                   print_proto (funname, t, vars)
                   (instrs typerEnv macros) liinstrs
               | _ ->
                 Format.fprintf f "Function @[<h>%a@]@\n@[<v 2>  %a@]@\nEnd Function"
                   print_proto (funname, t, vars)
                   (instrs typerEnv macros) liinstrs
             ) :: li
           | Prog.DeclareType (name, t) ->
             macros, (fun f ->
               match (Type.unfix t) with
                 Type.Struct li ->
                 Format.fprintf f "Public Class %s@\n  @[<v>%a@]@\nEnd Class" name
                   (print_list
                      (fun t (name, type_) ->
                         Format.fprintf t "Public %s As %a" name ptype type_ 
                      ) sep_nl
                   ) li
               | Type.Enum li ->
                 Format.fprintf f "Enum %s@\n  @[<v>%a@]@\nEnd Enum" name
                   (print_list (fun f name -> Format.fprintf f "%s" name) sep_nl) li
               | _ -> assert false
             ) :: li
         
           | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    Format.fprintf f
      "Imports System@\n%a@\nModule %s@\n@[<v 2>%s%s%s%s@\n%a@\n%a@]@\nEnd Module@\n"
      (fun f () ->
         if Tags.is_taged "use_readline"
         then Format.fprintf f "Imports System.Collections.Generic@\n"
      ) ()
      prog.Prog.progname
      (if need then "
Dim eof As Boolean
Dim buffer As String
Function readChar_() As Char
  If buffer Is Nothing OrElse buffer.Length = 0 Then
    Dim tmp As String = Console.ReadLine()
    eof = (tmp Is Nothing)
    buffer = tmp + Chr(10)
  End If
  Return buffer(0)
End Function

Sub consommeChar()
  readChar_()
  buffer = buffer.Substring(1)
End Sub" else "")

      (if need_readchar then "
Function readChar() As Char
  Dim out_ as Char = readChar_()
  consommeChar()
  Return out_
End Function" else "")

      (if need_stdinsep then "

Sub stdin_sep()
  Do
    If eof Then
      Return
    End If
    Dim c As Char = readChar_()
    If c = \" \"C Or c = Chr(13) Or c = Chr(9) Or c = Chr(10) Then
      consommeChar()
    Else
      Return
    End If
  Loop
End Sub" else "")
      (if need_readint then "

Function readInt() As Integer
  Dim i As Integer = 0
  Dim s as Char = readChar_()
  Dim sign As Integer = 1
  If s = \"-\"C Then
    sign = -1
    consommeChar()
  End If
  Do
    Dim c as Char = readChar_()
    If c <= \"9\"C And c >= \"0\"C Then
      i = i * 10 + Asc(c) - Asc(\"0\"C)
      consommeChar()
    Else
      return i * sign
    End If
  Loop
End Function" else "")
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (main typerEnv macros)) prog.Prog.main

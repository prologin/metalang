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


(** C# Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Helper
open Ast

let print_lief tyenv prio f = function
  | Expr.Char c ->
    if (c >= 'A' && c <= 'Z' ) ||
       (c >= 'a' && c <= 'z' ) ||
       (c >= '0' && c <= '9' ) ||
       (c = '-' || c = '_' )
    then Format.fprintf f "%C" c
    else Format.fprintf f "(char)%d" (int_of_char c)
  | Ast.Expr.Enum e ->
    let t = Typer.typename_for_enum e tyenv in
    Format.fprintf f "%s.%s" t e
  | x -> print_lief prio f x

let print_mut conf prio f m = Mutable.Fixed.Deep.fold
    (print_mut0 "%a%a" "[%a]" "%a.%s" conf) m f prio
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
let print_expr config e f p =
  Expr.Fixed.Deep.fold (print_expr0 config) e f p

let ptype t f opt =
  let open Type in let open Format in
  match t with
  | Integer -> fprintf f (if opt then "int?" else "int")
  | String -> fprintf f "String"
  | Array a -> fprintf f "%a[]" a false
  | Option t -> t f true
  | Void ->  fprintf f "void"
  | Bool -> fprintf f (if opt then "bool?" else "bool")
  | Char -> fprintf f (if opt then "char?" else "char")
  | Named n -> fprintf f "%s" n
  | Struct li -> fprintf f "a struct"
  | Enum _ -> fprintf f "an enum"
  | Auto | Tuple _ | Lexems -> assert false
    
let ptype f t = Ast.Type.Fixed.Deep.fold ptype t f false

let print_instr c i =
  let open Ast.Instr in
  let open Format in
  let pread f ty = match Ast.Type.unfix ty with
    | Ast.Type.Char -> fprintf f "readChar()"
    | Ast.Type.Integer -> fprintf f "readInt()"
    | _ -> raise (Warner.Error (fun f -> Format.fprintf f "Error : cannot read type %s"
                                   (Type.type_t_to_string ty)))
  in
  let p f pend = match i with
    | Declare (var, ty, e, _) -> fprintf f "%a %a = %a%a" ptype ty c.print_varname var e nop pend ()
    | AllocArrayConst (name, ty, len, lief, opt) -> assert false
    | AllocArray (name, t, e, Some (var, lambda), opt) -> assert false
    | AllocArray (name, t, e, None, opt) ->    
      begin match Type.unfix t with
        | Type.Array t2 ->
          fprintf f "@[<h>%a[] %a = new %a[%a]%a%a@]"
            ptype t
            c.print_varname name
            (jlike_prefix_type ptype) t2
            e nop
            jlike_suffix_type t pend ()
        | _ ->
          fprintf f "@[<h>%a[] %a = new %a[%a]%a@]"
            ptype t
            c.print_varname name
            ptype t
            e nop pend ()
      end
    | AllocRecord (name, ty, list, opt) ->
      fprintf f "%a %a = new %a()%a@\n%a"
        ptype ty c.print_varname name ptype ty pend ()
        (print_list (fun f (field, x) -> fprintf f "%a.%s = %a%a" 
                        c.print_varname name field x nop pend ()) sep_nl) list
    | Print [StringConst s] -> fprintf f "Console.Write(%a);" (c.print_lief jlike_prio_operator) (Expr.String s)
    | Print [PrintExpr (_, e)] -> fprintf f "Console.Write(%a);" e nop
    | Print li->
      fprintf f "Console.Write(%a%a);"
        (fun f () ->
           match li with
           | (PrintExpr (_, _))::(PrintExpr (_, _))::_ -> fprintf f "\"\" + "
           | _ -> ()
        ) ()
        (print_list
           (fun f e ->
              match e with
              | StringConst s -> c.print_lief jlike_prio_operator f (Expr.String s)
              | PrintExpr (_, e) -> e f jlike_prio_operator)
           (fun t f1 e1 f2 e2 -> Format.fprintf t "%a + %a" f1 e1 f2 e2)) li
    | Read li ->
      print_list
        (fun f -> function
           | Separation -> Format.fprintf f "@[stdin_sep()%a@]" pend ()
           | DeclRead (ty, v, opt) -> fprintf f "@[%a %a = %a%a@]" ptype ty c.print_varname v pread ty pend ()
           | ReadExpr (ty, mut) -> fprintf f "@[%a = %a%a@]" (c.print_mut c nop) mut pread ty pend ()
        ) sep_nl f li
    | Untuple (li, expr, opt) -> assert false
    | Unquote e -> assert false
    | _ -> clike_print_instr c i f pend
  in
  let is_multi_instr = match i with
    | Read (hd::tl) -> true
    | Declare _ -> true
    | _ -> false in
  {
    is_multi_instr = is_multi_instr;
    is_if=is_if i;
    is_if_noelse=is_if_noelse i;
    is_comment=is_comment i;
    p=p;
    default = seppt;
    print_lief = c.print_lief;
  }

let print_instr tyenv macros i =
  let open Ast.Instr.Fixed.Deep in
  let c = config tyenv macros in
  let i = (fold (print_instr c) (mapg (print_expr c) i))
  in fun f -> i.p f i.default
      
let prog typerEnv f (prog: Utils.prog) =
    let instrs macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "csharp" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> (print_instr typerEnv macros t) f) sep_nl f li in
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment str -> macros, (fun f -> clike_comment f str) :: li
           | Prog.DeclarFun (funname, t, vars, liinstrs, _opt) ->
             macros, (fun f -> Format.fprintf f "@[<h>static %a %s(%a)@]@\n@[<v 2>{@\n%a@]@\n}@\n"
               ptype t funname
               (print_list
                  (fun t (binding, type_) ->
                     Format.fprintf t "%a@ %a"
                       ptype type_ print_varname binding
                  ) sep_c
               ) vars
               (instrs macros) liinstrs) :: li
           | Prog.DeclareType (name, t) ->
             macros, (fun f -> match (Type.unfix t) with
                 Type.Struct li ->
                 Format.fprintf f "@[<v 2>public class %s {@\n%a@]@\n}" name
                   (print_list
                      (fun t (name, type_) -> Format.fprintf t "public %a %s;" ptype type_ name)
                      sep_nl
                   ) li
               | Type.Enum li ->
                 Format.fprintf f "enum %s { @\n@[<v2>  %a@]}@\n" name
                   (print_list (fun f s -> Format.fprintf f "%s" s) (sep "%a,@\n %a")
                   ) li
               | _ -> assert false
             ) :: li
    | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    Format.fprintf f
      "using System;@\n%a@\npublic class %s@\n@[<v 2>{%s%s%s%s@\n%a@\n%a@]@\n}@\n"
      (fun f () ->
         if Tags.is_taged "use_readline"
         then Format.fprintf f "using System.Collections.Generic;@\n"
      ) ()
      (String.concat "" [prog.Prog.progname; "Class"])
      (if need then "
static bool eof;
static String buffer;
static char readChar_(){
  if (buffer == null || buffer.Length == 0){
    String tmp = Console.ReadLine();
    eof = tmp == null;
    buffer = tmp + \"\\n\";
  }
  char c = buffer[0];
  return c;
}
static void consommeChar(){
       readChar_();
  buffer = buffer.Substring(1);
}" else "")
      (if need_readchar then "
static char readChar(){
  char out_ = readChar_();
  consommeChar();
  return out_;
}" else "")
      (if need_stdinsep then "
static void stdin_sep(){
  do{
    if (eof) return;
    char c = readChar_();
    if (c == ' ' || c == '\\n' || c == '\\t' || c == '\\r'){
      consommeChar();
    }else{
      return;
    }
  } while(true);
}" else "")
      (if need_readint then "
static int readInt(){
  int i = 0;
  char s = readChar_();
  int sign = 1;
  if (s == '-'){
    sign = -1;
    consommeChar();
  }
  do{
    char c = readChar_();
    if (c <= '9' && c >= '0'){
      i = i * 10 + c - '0';
      consommeChar();
    }else{
      return i * sign;
    }
  } while(true);
} " else "")
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f liinstrs ->
           Format.fprintf f "public static void Main(String[] args)@\n@[<v 2>{@\n%a@]@\n}@\n"
             (instrs macros) liinstrs)
         ) prog.Prog.main

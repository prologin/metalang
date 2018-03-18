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


(** C++ Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext
open Ast
open Helper

let print_lief prio f = function
  | Expr.Char c -> unicode f c
  | Expr.Nil -> Format.fprintf f "nullptr"
  | x -> print_lief prio f x

let config print_mut macros = {
  prio_binop;
  prio_unop;
  print_varname;
  print_lief;
  print_op;
  print_unop;
  print_mut;
  macros
}

let print_expr config e f p = Expr.Fixed.Deep.fold (print_expr0 config) e f p

let ptype star tyenv f t =
  let open Ast.Type in
  let open Format in
  let ptype ty f option = match ty with
  | Integer -> fprintf f (if option then "int*" else "int")
  | String -> fprintf f (if option then "std::string*" else "std::string")
  | Array a -> fprintf f (if star || option then "std::vector<%a> *" else "std::vector<%a>") a false
  | Void ->  fprintf f "void"
  | Option a -> a f true
  | Bool -> fprintf f (if option then "bool*" else "bool")
  | Char -> fprintf f (if option then "char*" else "char")
  | Named n -> if star || option then match Typer.expand tyenv (Typer.byname n tyenv)
                                    Ast.Location.default |> unfix with
    | Struct _ -> fprintf f "%s *" n
                    
    | Enum _ -> fprintf f (if option then "%s*" else "%s") n
    | _ -> assert false
    else fprintf f "%s" n
  | Enum _ -> fprintf f "an enum"
  | Struct li -> fprintf f "a struct"
  | Auto | Lexems | Tuple _ -> assert false
  in Fixed.Deep.fold ptype t f false
    
let rec ptypename f t =
  let open Ast.Type in match unfix t with
  | Named n -> Format.fprintf f "%s" n
  | _ -> assert false

let print_instr cc tyenv c i =
  let ptype = ptype cc tyenv in
  let open Ast.Instr in
  let open Format in
  let p f pend = match i with
    | Declare (var, ty, e, _) -> fprintf f "%a %a = %a%a"
                                   ptype ty c.print_varname var e nop pend ()
    | AllocArray (name, t, e, None, opt) ->
      if cc then fprintf f "@[<h>std::vector<%a> *%a = new std::vector<%a>( %a )%a@]" ptype t c.print_varname name ptype t e nop pend ()
      else fprintf f "@[<h>std::vector<%a> %a( %a )%a@]" ptype t c.print_varname name e nop pend ()
    | AllocArray (name, t, e, Some (var, lambda), opt) -> assert false
    | AllocArrayConst (name, ty, len, lief, opt) ->
      if cc then fprintf f "@[<h>std::vector<%a> *%a = new std::vector<%a>( %a );@\nstd::fill(%a->begin(), %a->end(), %a)%a@]"
          ptype ty
          c.print_varname name
          ptype ty
          len nop
          c.print_varname name
          c.print_varname name
          (c.print_lief nop) lief pend ()
      else fprintf f "@[<h>std::vector<%a> %a( %a, %a )%a@]" ptype ty
          c.print_varname name
          len nop
          (c.print_lief nop) lief pend ()
    | AllocRecord (name, ty, list, opt) ->
      fprintf f "@[<v 4>%a %a%a%a@\n%a%a@]"
        ptype ty c.print_varname name
        (fun f () -> if cc then fprintf f " = new %a()" ptypename ty) () pend ()
        (print_list (fun f (field, x) -> fprintf f (if cc then "%a->%s = %a%a" else "%a.%s = %a%a")
                        c.print_varname name field x nop pend ()) sep_nl) list
        pend ()
    | Print li->
      fprintf f "std::cout << %a%a"
        (print_list
           (fun f -> function
              | StringConst s -> c.print_lief nop f (Ast.Expr.String s)
              | PrintExpr (_, e) -> e f nop) (sep "%a << %a")) li
        pend ()
    | Read li ->
      let skipfirst, variables =
        List.fold_left (fun (skipfirst, variables) i -> match i with
            | Instr.ReadExpr (t, mutable_) -> skipfirst, (t, mutable_, false)::variables
            | Instr.DeclRead (t, var, _) ->
              let mutable_ = Mutable.var var in
              skipfirst, (t, mutable_, false)::variables
            | Instr.Separation -> begin match variables with
                | (t, m, s)::tl -> skipfirst, (t, m, true)::tl
                | [] -> true, []
              end
          ) (false, []) li
      in
      let lastSkip = ref true in
      Format.fprintf f "std::cin%a%a;"
        (fun f b -> if b then
            Format.fprintf f " >> std::skipws"
        ) skipfirst
        (print_list (fun f (t, x, b) ->
             if !lastSkip = b then
               Format.fprintf f " >> %a" (c.print_mut c nop) x
             else
               Format.fprintf f " >> %a >> std::%sskipws" (c.print_mut c nop) x
                 (if b then "" else "no");
             lastSkip := b;
           ) nosep )
        (List.rev variables)
    | Untuple (li, expr, opt) -> fprintf f "list(%a) = %a%a" (print_list c.print_varname sep_c) (List.map snd li) expr nop pend ()
    | Unquote e -> assert false
    | _ -> clike_print_instr c i f pend
  in
  let is_multi_instr = match i with
    | Read (hd::tl) -> true
    | _ -> false in
  {
    is_multi_instr=is_multi_instr;
    is_if=is_if i;
    is_if_noelse=is_if_noelse i;
    is_comment=is_comment i;
    p=p;
    default = seppt;
    print_lief = c.print_lief;
  }

let print_instr cc print_mut tyenv macros i =
  let open Ast.Instr.Fixed.Deep in
  let c = config print_mut macros in
  let i = (fold (print_instr cc tyenv c) (mapg (print_expr c) i))
  in fun f -> i.p f i.default

let cc_print_mut conf prio f m = Mutable.Fixed.Deep.fold
    (print_mut0 "%a%a" "->at(%a)" "%a->%s" conf) m f prio

let declare_for s f li =
  if li <> [] then Format.fprintf f "%s %a;@\n" s (print_list print_varname sep_c) li

let cppPrinter typerEnv f (prog: Utils.prog) =
    let instructions macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "cc" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> print_instr true cc_print_mut typerEnv macros t f) sep_nl f li in
let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment str -> macros, (fun f -> clike_comment f str)::li
           | Prog.DeclarFun (funname, t, vars, liinstrs, _opt) ->
             macros, (fun f -> let li_fori, li_forc = clike_collect_for liinstrs true in
             Format.fprintf f "@\n@[<h>%a %s(%a)@] {@\n@[<v 4>    %a%a%a@]@\n}@\n"
               (ptype true typerEnv) t funname
               (print_list
                  (fun t (binding, type_) ->
                     Format.fprintf t "%a@ %a" (ptype true typerEnv) type_ print_varname binding
                  ) sep_c
               ) vars
               (declare_for "int") li_fori
               (declare_for "char") li_forc
               (instructions macros) liinstrs)::li
           | Prog.DeclareType (name, t) -> macros, (fun f -> cclike_decltype (ptype true typerEnv) f name t)::li
           | _ -> macros, li
      ) (StringMap.empty, []) prog.Prog.funs in
    Format.fprintf f
      "#include <iostream>@\n#include <vector>@\n%a%a@\n%a\n"
      (fun f () ->
         if Tags.is_taged "use_math"
         then Format.fprintf f "#include<cmath>@\n";
         if Tags.is_taged "use_cpp_algorithm"
         then Format.fprintf f "#include <algorithm>@\n";
         if Tags.is_taged "use_cc_readline"
         then Format.fprintf f "std::vector<char> *getline() {
    if (std::cin.flags() & std::ios_base::skipws) {
        char c = std::cin.peek();
        if (c == '\\n' || c == ' ') std::cin.ignore();
        std::cin.unsetf(std::ios::skipws);
    }
    std::string line;
    std::getline(std::cin, line);
    std::vector<char> *c = new std::vector<char>(line.begin(), line.end());
    std::cin >> std::skipws;
    return c;
}@\n"
      ) ()
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f main ->
           let li_fori, li_forc = clike_collect_for main true in
           Format.fprintf f "@[<v 4>int main() {@\n%a%a%a@]@\n}"
             (declare_for "int") li_fori
             (declare_for "char") li_forc
             (instructions macros) main
         )) prog.Prog.main


let cpp_print_mut conf prio f m = Mutable.Fixed.Deep.fold
    (print_mut0 "%a%a" "[%a]" "%a.%s" conf) m f prio

let proloCppPrinter typerEnv f (prog: Utils.prog) =
    let prototype f t =
      match Type.unfix t with
      | Type.Array a -> Format.fprintf f "%a&" (ptype false typerEnv) t
      | Type.Named n -> begin match Typer.expand typerEnv t
                                      Ast.Location.default |> Type.unfix with
        | Type.Struct _ -> Format.fprintf f "%a&" (ptype false typerEnv) t
        | _ -> ptype false typerEnv f t
        end
      | _ -> ptype false typerEnv f t in
    let instructions macros f li =
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "cpp" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> print_instr false cpp_print_mut typerEnv macros t f) sep_nl f li in
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment str -> macros, (fun f -> clike_comment f str)::li
           | Prog.DeclarFun (funname, t, livars, liinstrs, _opt) ->
              macros, (fun f -> let li_fori, li_forc = clike_collect_for liinstrs true in
             Format.fprintf f "@\n@[<h>%a %s(%a)@] {@\n@[<v 4>    %a%a%a@]@\n}@\n"
               (ptype false typerEnv) t funname
               (print_list
                  (fun t (binding, type_) ->
                     Format.fprintf t "%a@ %a" prototype type_ print_varname binding
                  ) sep_c
               ) livars
               (declare_for "int") li_fori
               (declare_for "char") li_forc
               (instructions macros) liinstrs) :: li
           | Prog.DeclareType (name, t) ->
              macros, (fun f -> cclike_decltype (ptype false typerEnv) f name t) :: li
         | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    Format.fprintf f
      "#include <iostream>@\n#include <vector>@\n%a%a@\n%a\n"
      (fun f () ->
         if Tags.is_taged "use_math"
         then Format.fprintf f "#include<cmath>@\n";
         if Tags.is_taged "use_cpp_algorithm"
         then Format.fprintf f "#include <algorithm>@\n";
         if Tags.is_taged "use_cc_readline"
         then Format.fprintf f "std::vector<char> getline() {
    if (std::cin.flags() & std::ios_base::skipws) {
        char c = std::cin.peek();
        if (c == '\\n' || c == ' ') std::cin.ignore();
        std::cin.unsetf(std::ios::skipws);
    }
    std::string line;
    std::getline(std::cin, line);
    std::vector<char> c(line.begin(), line.end());
    std::cin >> std::skipws;
    return c;
}@\n";
         if Tags.is_taged "use_cpp_readmatrix"
         then Format.fprintf f "@\ntemplate <typename T> std::vector<std::vector<T>> read_matrix(int l, int c) {
    std::vector<std::vector<T>> matrix(l, std::vector<T>(c));
    for (std::vector<T>& line : matrix)
        for (T& elem : line)
            std::cin >> elem;
    return matrix;
}@\n"
      ) ()
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f main ->
           let li_fori, li_forc = clike_collect_for main true in
           Format.fprintf f "@[<v 4>int main() {@\n%a%a%a@]@\n}"
             (declare_for "int") li_fori
             (declare_for "char") li_forc
             (instructions macros) main
         )) prog.Prog.main

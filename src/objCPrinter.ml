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

(** Objective-C Printer
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ast
open Helper
open Ext

let ptype tyenv f t =
  let open Ast.Type in
  let open Format in 
  let ptype ty f option = match ty with
  | Integer -> fprintf f (if option then "int*" else "int")
  | String -> fprintf f "char*"
  | Array a -> fprintf f "%a*" a false
  | Void ->  fprintf f "void"
  | Bool -> fprintf f (if option then "int*" else "int")
  | Char -> fprintf f (if option then "char*" else "char")
  | Option a -> a f true
  | Named n -> begin match Typer.expand tyenv (Typer.byname n tyenv) Ast.Location.default |> Type.unfix with
    | Type.Struct _ -> Format.fprintf f "%s *" n
    | Type.Enum _ -> Format.fprintf f (if option then "%s*" else "%s") n
    | _ -> assert false
    end
  | Enum _ | Struct _ | Auto | Lexems | Tuple _ -> assert false
  in Fixed.Deep.fold ptype t f false
    
let print_instr0 alloc ptype c i f pend =
  let open Ast.Instr in
  let open Format in
  match i with
  | AllocRecord (name, ty, list, opt) -> fprintf f "%a %a = [%s alloc]%a@\n%a"
                                           ptype ty
                                           c.print_varname name
                                           (match Type.unfix ty with | Type.Named n -> n | _ -> assert false) pend ()
                                           (CPrinter.def_fields c name) list
  | _ -> CPrinter.print_instr0 alloc ptype c i f pend

let declare_for s f li =
  if li <> [] then Format.fprintf f "%s %a;@\n" s (print_list print_varname sep_c) li
        
let prog typerEnv f (prog: Utils.prog) =
    let alloc = if Tags.is_taged "use_count" then "alloc" else "calloc" in
    let instructions macros f li =
      let rewrite i = match Instr.unfix i with
        | Instr.ClikeLoop (init, cond, incr, li) ->
          let init = List.map (fun i -> match Instr.unfix i with
              | Instr.Declare (var, ty, e, _) ->
                let mut = Mutable.var var in
                Instr.affect mut e
              | _ -> i) init
          in Instr.ClikeLoop (init, cond, incr, li) |> Instr.fix
        | _ -> i
      in
      let li = List.map (Instr.Fixed.Deep.map rewrite) li in
      let macros = StringMap.map (fun (ty, params, li) ->
          ty, params,
          try List.assoc "objc" li
          with Not_found -> List.assoc "" li) macros
      in print_list (fun f t -> CPrinter.print_instr alloc print_instr0 (ptype typerEnv) macros t f) sep_nl f li in
    let macros, items = List.fold_left
        (fun (macros, li) item -> match item with
           | Prog.Macro (name, t, params, code) ->
             StringMap.add name (t, params, code) macros, li
           | Prog.Comment str -> macros, (fun f -> clike_comment f str) :: li
           | Prog.DeclarFun (funname, t, vars, liinstrs, _opt) ->
            macros, (fun f ->  let li_fori, li_forc = clike_collect_for liinstrs false in
             Format.fprintf f "@\n@[<h>%a %s(%a)@] {@\n@[<v 4>    %a%a%a@]@\n}@\n"
               (ptype typerEnv)t funname
               (print_list
                  (fun t (binding, type_) ->
                     Format.fprintf t "%a@ %a"
                       (ptype typerEnv) type_ print_varname binding
                  ) sep_c
               ) vars
               (declare_for "int") li_fori
               (declare_for "char") li_forc
               (instructions macros) liinstrs) :: li
           | Prog.DeclareType (name, t) ->
             macros, (fun f -> match (Type.unfix t) with
                 Type.Struct li ->
                 Format.fprintf f "@@interface %s : NSObject@\n{@\n@[<v 2>  %a@]@\n}@\n@@end@\n@@implementation %s @\n@@end@\n" name
                   (print_list
                      (fun t (name, type_) ->
                         Format.fprintf t "@@public %a %s;" (ptype typerEnv) type_ name
                      ) sep_nl
                   ) li name
               | Type.Enum li ->
                 Format.fprintf f "typedef enum %s {@\n@[<v2>  %a@]@\n} %s;" name
                   (print_list
                      (fun t name -> Format.fprintf t "%s" name)
                      (sep "%a,@\n%a")
                   ) li name
               | _ -> Format.fprintf f "typedef %a %s;" (ptype typerEnv) t name
               ) :: li
           | _ -> macros, li
        ) (StringMap.empty, []) prog.Prog.funs in
    Format.fprintf f "#import <Foundation/Foundation.h>@\n#include<stdio.h>@\n#include<stdlib.h>@\n%a@\n%a@\n%a@\n@\n"
      (fun f () ->
         if Tags.is_taged "use_math"
         then Format.fprintf f "#include<math.h>@\n";
         if Tags.is_taged "use_count"
         then Format.fprintf f "int count(void* a){ return ((int*)a)[-1]; }@\n
void* alloc(int a, int size){
  void *out_ = malloc( a * size + sizeof(int));
  ((int*)out_)[0]=a;
  return ((int*)out_)+1;
}@\n"
      ) ()
      (print_list (fun f g -> g f) sep_nl) (List.rev items)
      (print_option (fun f main ->
           let li_fori, li_forc = clike_collect_for main false in
           Format.fprintf f "@[<v 2>int main(void){@\nNSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];@\n%a%a%a@\n[pool drain];@\nreturn 0;@]@\n}"

             (declare_for "int") li_fori
             (declare_for "char") li_forc
             (instructions macros) main)) prog.Prog.main

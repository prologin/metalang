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


(**
   @see <http://prologin.org> Prologin
   @author Prologin (info\@prologin.org)
   @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext

open Ast
open PassesUtils

type acc0 = Typer.env
type 'lex acc = Typer.env;;
let init_acc env = env;;

let rec foldmapexpr tyenv acc e = match Expr.unfix e with
  | Expr.Record li ->
    let acc, li = List.fold_left_map (fun acc (name, e) ->
        let acc, e = process tyenv acc e in
        acc, (name, e) ) acc li in
    let t = Typer.get_type tyenv e in
    let varname = Fresh.fresh_internal () in
    let ni = Instr.alloc_record varname t li Instr.useless_declaration_option in
    let ne = Expr.access (Mutable.var varname) in
    ni::acc, ne
  | _ -> acc, e

and process tyenv acc e =
  let acc, e = foldmapexpr tyenv acc e in
  Expr.Writer.Deep.foldmap (foldmapexpr tyenv) acc e

let process_mut tyenv acc m = Mutable.Fixed.Deep.foldmapg (fun e acc -> process tyenv acc e) m acc

let expand tyenv i = match Instr.unfix i with
  | Instr.Declare (n, t, (Expr.Fixed.F (_, Expr.Record li) ), opt) ->
    let acc, li = List.fold_left_map (fun acc (name, e) ->
        let acc, e = process tyenv acc e in
        acc, (name, e) ) [] li in
    List.append acc [Instr.alloc_record n t li opt]
  | Instr.Declare (n, t, e, opt) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Declare (n, t, e, opt)) ) :: instrs)
  | Instr.Affect (mut, e) ->
    let instrs, e = process tyenv [] e in
    let instrs, mut = process_mut tyenv instrs mut in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Affect (mut, e))  ) :: instrs)
  | Instr.SelfAffect (mut, op, e) ->
    let instrs, e = process tyenv [] e in
    let instrs, mut = process_mut tyenv instrs mut in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.SelfAffect (mut, op, e))  ) :: instrs)
  | Instr.Loop (v, e1, e2, li) ->
    let instrs, e1 = process tyenv [] e1 in
    let instrs, e2 = process tyenv instrs e2 in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Loop (v, e1, e2, li))  ) :: instrs)
  | Instr.While (e, li) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.While (e, li))  ) :: instrs)
  | Instr.Return e ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Return e)  ) :: instrs)
  | Instr.AllocArrayConst (n, t, e, lief, opt2) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.AllocArrayConst (n, t, e, lief, opt2))  ) :: instrs)
  | Instr.AllocArray (n, t, e, opt, opt2) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.AllocArray (n, t, e, opt, opt2))  ) :: instrs)
  | Instr.AllocRecord (n, t, lie, opt) ->
    let instrs, lie = List.fold_left_map (fun acc (f, e) ->
        let acc, e = process tyenv acc e
        in acc, (f, e)) [] lie in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.AllocRecord (n, t, lie, opt))  ) :: instrs)
  | Instr.If (e, l1, l2) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.If (e, l1, l2))  ) :: instrs)
  | Instr.ClikeLoop (init, cond, incr, li) ->
    let instrs_cond, cond = process tyenv [] cond in
    [Instr.fixa (Instr.Fixed.annot i)
       (Instr.ClikeLoop (init, cond, incr, List.append instrs_cond li))]
  | Instr.Call (funname, lie) ->
    let instrs, lie = List.fold_left_map (process tyenv) [] lie in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Call (funname, lie))  ) :: instrs)
  | Instr.Print li ->
    let instrs, li = List.fold_left_map (fun instrs -> function
        | (Instr.StringConst _ ) as e-> instrs, e
        | Instr.PrintExpr (ty, e) ->
          let instrs, e = process tyenv instrs e in
          instrs, Instr.PrintExpr (ty, e)) [] li
    in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Print li)  ) :: instrs)
  | Instr.Read li ->
    let instrs, li = List.fold_left_map (fun instrs -> function
        | Instr.Separation -> instrs, Instr.Separation
        | (Instr.DeclRead _ ) as o -> instrs, o
        | Instr.ReadExpr (t, mut) ->
          let instrs, mut = process_mut tyenv instrs mut in
          instrs, Instr.ReadExpr (t, mut) ) [] li
    in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Read li)  ) :: instrs)
  | Instr.Incr mut ->
    let instrs, mut = process_mut tyenv [] mut in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Incr mut)  ) :: instrs)
  | Instr.Decr mut ->
    let instrs, mut = process_mut tyenv [] mut in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Decr mut)  ) :: instrs) 
  | Instr.Untuple(li, e, opt) ->
    let instrs, e = process tyenv [] e in
    List.rev ((Instr.fixa (Instr.Fixed.annot i) (Instr.Untuple (li, e, opt))  ) :: instrs)
  | Instr.Tag _ | Instr.Comment _ | Instr.Unquote _ -> [i]

let mapi tyenv i =
  Instr.deep_map_bloc
    (List.flatten @* (List.map (expand tyenv)) )
    (Instr.unfix i) |> Instr.fixa (Instr.Fixed.annot i)

let process tyenv is = tyenv, List.map (mapi tyenv) (List.flatten (List.map (expand tyenv) is))

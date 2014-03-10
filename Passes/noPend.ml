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


(** Some expantion passes
@see <http://prologin.org> Prologin
@author Prologin (info\@prologin.org)
@author Maxime Audouin (coucou747\@gmail.com)
*)


open Stdlib

open Ast
open Fresh
open PassesUtils

  type acc0 = unit
  type 'lex acc = unit

  let locate loc instr =
    PosMap.add (Instr.Fixed.annot instr) loc; instr

  let locatee loc e =
    PosMap.add (Expr.Fixed.annot e) loc; e

  let locatem loc m =
    PosMap.add (Mutable.Fixed.annot m) loc; m

  let rec process (acc:'lex acc) i =
    let rec inner_map t0 : 'lex Instr.t list =
      match Instr.unfix t0 with
        | Instr.AllocArray(
          _, _,
          Expr.Fixed.F (_, Expr.Access (
            Mutable.Fixed.F
              (_, Mutable.Var _))), _)
        | Instr.Print(_, Expr.Fixed.F
          (_,
           (Expr.Access ( Mutable.Fixed.F
                            (_, Mutable.Var _))
               | Expr.Char _
               | Expr.String _
               | Expr.Float _
               | Expr.Integer _
               | Expr.Bool _
           )
          )) ->
          [fixed_map t0]
        | Instr.Print(t, e) ->
	  let annot = Instr.Fixed.annot t0 in
          let loc = PosMap.get (Instr.Fixed.annot t0) in
          let b = fresh () in
          [
            Instr.Declare (b, t, e) |> Instr.fixa annot |> locate loc;
            Instr.Print(t, locatee loc (Expr.access (locatem loc (Mutable.var b))))
          |> Instr.fixa annot |> locate loc;
          ]
        | Instr.AllocArray(b0, t, e, lambdaopt) ->
	  let annot = Instr.Fixed.annot t0 in
          let lambdaopt = match lambdaopt with
            | None -> None
            | Some (name, li) ->
              let li = List.map inner_map li in
              let li = List.flatten li in
              Some (name, li)
          in
          let loc = PosMap.get (Instr.Fixed.annot t0) in
          let b = fresh () in
          [
            Instr.Declare (b, Type.integer, e) |> Instr.fixa annot;
            Instr.AllocArray(b0, t,
                             Expr.access (Mutable.var b),
                             lambdaopt) |> Instr.fixa annot  |> locate loc;
          ]
        | _ -> [fixed_map t0]
    and fixed_map (t:'lex Instr.t) =
      Instr.deep_map_bloc
        (List.flatten @* (List.map inner_map))
        (Instr.unfix t)
        |> Instr.fixa (Instr.Fixed.annot t)
    in acc, List.flatten (List.map inner_map i);;
  let init_acc _ = ();;
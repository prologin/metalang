(*
 * Copyright (c) 2017, Prologin
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


(** Cette passe permet de modifier la construction :
    def array<...> toto[len]
    en 
    def array<...> toto[len - 1]

    C'est une sorte de hack pour VB et ADA

    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext

open Ast
open Fresh
open PassesUtils

type acc0 = unit
type 'lex acc = unit
let init_acc b = ()

let locate loc e =
  PosMap.add (Expr.Fixed.annot e) loc; e

let locatm loc m =
  PosMap.add (Mutable.Fixed.annot m) loc; m

let locati loc instr =
  PosMap.add (Instr.Fixed.annot instr) loc; instr

let expand acc i = match Instr.unfix i with
  | Instr.AllocArray (b, t, len, lambda, opt) ->
    [ Instr.fixa (Instr.Fixed.annot i)
        (Instr.AllocArray (b, t, Expr.sub len (Expr.integer 1), lambda, opt)) ]
  | _ -> [i]

let mapi acc i =
  Instr.deep_map_bloc
    (List.flatten @* (List.map (expand acc)))
    (Instr.unfix i) |> Instr.fixa (Instr.Fixed.annot i)

let process acc is = acc, List.map (mapi acc) (List.flatten (List.map (expand acc) is))

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

(** Some passes
    @see <http://prologin.org> Prologin
    @author Prologin (info\@prologin.org)
    @author Maxime Audouin (coucou747\@gmail.com)
*)

open Ext

open Ast
open Fresh
open PassesUtils

module WalkCountNoPosition = WalkTop(CountNoPosition)
module WalkRemoveTags = WalkTop(RemoveTags)
module WalkCollectCalls = WalkTop(CollectCalls)
module WalkCollectTypes = WalkTop(CollectTypes)
module WalkNopend = Walk(NoPend)
module WalkExpandPrint = Walk(ExpandPrint)
module WalkIfMerge = Walk(IfMerge)
module WalkAllocArrayExpend = Walk(AllocArrayExpend)
module WalkAllocArraySubOne = Walk(AllocArraySubOne)
module WalkRecordExprToInstr = Walk(RecordExprToInstr)
module WalkCheckNaming = WalkTop(CheckNaming)
module WalkRename = WalkTop(Rename)
module WalkInternalTags = WalkTop(InternalTags)
module WalkExpandUnTuple = WalkTop(ExpandUnTuple)
module WalkInlineFuncs0 = WalkTop(InlineFuncs)
module WalkRemoveInternal = WalkTop(RemoveInternal)
module WalkInlineFuncs = struct
  let apply () p =
    let p = WalkInlineFuncs0.apply () p in
    {p with Prog.funs = List.filter (function
         | Prog.DeclarFun (name, t, params, instrs, {Prog.useless=true}) -> false
         | _ -> true) p.Prog.funs}
end
module WalkInlineVars = WalkTop(InlineVars)

module WalkDetectRecursion = WalkTop(DetectRecursion)

module WalkArrayReIndex = Walk(ArrayReIndex)
module WalkMergePrints = Walk(MergePrints)
module WalkMergeReads = Walk(MergeReads)
module WalkMakeSelfAffect = Walk(MakeSelfAffect)
module WalkMakeCLikeLoops = Walk(MakeCLikeLoops)
module WalkDecrLoopLimit = Walk(DecrLoopLimit)
module WalkSimplifyExpressions = Walk(SimplifyExpressions)

(* TODO rentrer dans la structure du type *)
let no_macro = function
  | Prog.DeclarFun (_, ty, li, instrs, opt) ->
    begin match Type.unfix ty with
      | Type.Lexems -> false
      | _ -> true
    end
  | _ -> true

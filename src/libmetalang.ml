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

(** Lib Main
    This file is a lib to make entry point of the compiler.
    @see <http://prologin.org> Prologin
    @see <http://eelte.megami.fr/metalang> Metalang
    @author Arthur Wendling (art.wendling@gmail.com)
    @author Maxime Audouin (coucou747@gmail.com)
    @author Prologin (info@prologin.org)
*)


open Ext
open Ast

let benchmark = false

(** Liste des mots clés à ne pas utiliser en metalang *)
let keywords lang=
  let li = [
    "abstract";"add";"alias";"as";"asm";"auto";"and";"assert";
    "base";"bool";"boolean";"break";"byte";"begin";
    "case";"catch";"char";"checked";"class";"const";"continue";"constraint";
    "decimal";"default";"delegate";"do";"double";"delete";"done";"downto";"def";"del";
    "else";"elif";"elsif";"enum";"event";"explicit";"extern";"explicit";"exp";"eval";"end";"exception";"external";"extends";"except";"ensure";
    "False";"false";"finally";"final";"fixed";"float";"for";"foreach";"friend";"from";"fun";"function";"functor";
    "get";"global";"goto";"go";
    "if";"implicit";"in";"int";"interface";"internal";"is";"inline";"init";"include";"inherit";"initializer";"implements";"import";"instanceof";
    "lock";"long";"lazy";"let";"lambda";
    "mutable";"min"; "max";"match";"method";"module";
    "namespace";"new";"null";"native";"None";"nonlocal";"not";"next"; "nil";
    "object";"operator";"out";"override";"or";"of";"open";
    "params";"partial";"private";"protected";"public";"package";"pass";
    "readonly";"ref";"remove";"return";"register";"rec";"raise";"redo";"rescue";"retry";
    "sig";"sbyte";"sealed";"set";"short";"sizeof";"stackalloc";"static";"string";"struct";"switch";"signed";"sizeof";"strictfp";"super";"synchronized";
    "this";"throw";"throws";"transient";"True";"true";"try";"typeof";"template";"typedef";"to";"then";"type";
    "uint";"ulong";"unchecked";"unsafe";"ushort";"using";"unsigned";"unless";"undef";"until";
    "value";"virtual";"void"; "volatile";"val";
    "where";"while";"when";"with";
    "yield";
    "read_int"; "read_char"; "skip";
    "qsort"
  ]
  in match lang with
    "pas" -> "div"::li
  | "ada" -> "abs"::li
  | "cl" -> "isqrt" :: "t" :: "mem" :: "nth" :: "cons" :: "find" :: li
  | "rkt" -> "isqrt" :: "t" :: "mem" :: "nth" :: "cons" :: "find" :: li
  | "php" -> "sqrt" :: "log10" :: li
  | "m" -> "log10" :: "id" :: li
  | "vb" -> "stop" :: li
  | "hs" -> "id" :: "show" :: "head" :: "tail" :: li
  | "fs" -> "find" :: "rot" :: "over" :: "dup" :: li
  | "fsscript" -> "process"::li
  | "js" -> "process"::li
  | _ -> li

let conf_rename lang prog =
  Fresh.fresh_init prog ;
  Rename.clear ();
  if lang = "adb" || lang = "scala" then begin
    StringSet.iter (fun name ->
      if '_' = String.get name ((String.length name) - 1) then
	      Rename.add name;
    ) !Fresh.bindings
  end;
  Rename.add prog.Prog.progname ;
  List.iter Rename.add (keywords lang);
  List.iter Fresh.add (keywords lang)

(** return unit : the default accumulator for a lot of passes *)
let funit a = ()

(** apply a pass with an accumulator computed for typer env *)
let typed name f acc (a, b) =
(*      let before = Passes.WalkCountNoPosition.fold () b in *)
  let startTime = Sys.time () in
  let b = f (acc a) b in
  if benchmark then begin let delta = Sys.time () -. startTime in
  Format.printf "%3.5f Pass : %s@\n%!" delta name end;

(*
                      let after = Passes.WalkCountNoPosition.fold () b in
                      Format.fprintf Format.std_formatter "Pass : %s lost %d positions (%d missing)@\n" name (after - before) after; *)
(*  base_print b; *)
  (a, b)

(** this function call the typer *)
let typer_process (a, b) =
  let startTime = Sys.time () in
  let o = Typer.process b in
  if benchmark then begin let delta = Sys.time () -. startTime in
  Format.printf "%3.5f Pass : Typer@\n%!" delta end;
  o

(** apply a pass without accumulator *)
let typed_ name f (a, b) =
  let startTime = Sys.time () in
  let b = f b in
  if benchmark then begin let delta = Sys.time () -. startTime in
  Format.printf "%3.5f Pass : %s@\n%!" delta name end;
  (a, b)

(** check if we use both read macros and skip or read keywords (it's forbiden) *)
(** this pass may assert in a language and fail in another language *)
let check_reads prog =
  if Tags.is_taged "use_readmacros" then
    let need_stdinsep = prog.Prog.hasSkip in
    let need_readint = TypeSet.mem (Type.integer) prog.Prog.reads in
    let need_readchar = TypeSet.mem (Type.char) prog.Prog.reads in
    let need = need_stdinsep || need_readint || need_readchar in
    if need then
      begin
        raise (Warner.Error (fun f -> Format.fprintf f "Cannot use macros like read_int, read_char_line, read_int_line and skip or read.\n"))
      end

(** passes applyed for all languages *)
let default_passes (prog : Typer.env * Utils.prog) =
  prog
  |> typed "check naming" Passes.WalkCheckNaming.apply funit
  |> CheckUseVoid.apply
  |> typed "check return" CheckReturn.apply funit
  |> typed "remove tags" Passes.WalkRemoveTags.apply funit
  |> typed "rename" Passes.WalkRename.apply funit
  |> typed "expand" Passes.WalkNopend.apply funit
  |> typed "expend print" Passes.WalkExpandPrint.apply funit
  |> typed "internal tags" Passes.WalkInternalTags.apply funit
  |> typed "inline functions" Passes.WalkInlineFuncs.apply funit
  |> typed "inline vars" Passes.WalkInlineVars.apply funit
  |> typed "walk merge prints" Passes.WalkMergePrints.apply funit
  |> typed "walk merge reads" Passes.WalkMergeReads.apply funit
  |> typer_process
  |> (fun (ty, p) ->
      let acc = Passes.WalkDetectRecursion.fold () p in
      acc, ty, p
     )

let justtype prog = prog |> typer_process |>
                    (fun (ty, p) -> StringSet.empty, ty, p)

(** passes for imperatives languages like C, C++, python, etc... *)
let clike_passes
    ~tuple
    ~record
    ~array
    ~mergeif
    ~arrayconst
    ~arrayindex1
    ~opselfaffect
    ?(arraysubone=false)
    ?(clikeloop=false)
    ?(decrlooplimit=0)
    prog =
  let rec_, ty, p = default_passes prog in
  let ty, p = if tuple then
    let tuples, p = DeclareTuples.apply ty p in
    let p = Passes.WalkExpandUnTuple.apply (ty, tuples) p in
    Typer.process p
  else ty, p
  in let ty, p = if record then
    Passes.WalkRecordExprToInstr.apply
      (Passes.WalkRecordExprToInstr.init_acc ty) p |> Typer.process
  else ty, p in
  let ty, p =
    if mergeif then Passes.WalkIfMerge.apply () p |> Typer.process
    else ty, p
  in let p = if array then Passes.WalkAllocArrayExpend.apply arrayconst p else p in
  let p = if arraysubone then Passes.WalkAllocArraySubOne.apply () p else p in
  let p = if arrayindex1 then Passes.WalkArrayReIndex.apply () p else p in
  let p = Passes.WalkInlineVars.apply () p in
  let ty, p = Typer.process p in
  let p = ReadAnalysis.apply p in
  let () = check_reads p in
  let p = Passes.WalkRemoveInternal.apply () p in
  let p = if clikeloop then Passes.WalkMakeCLikeLoops.apply () p else p in
  let p = Passes.WalkMakeSelfAffect.apply opselfaffect p in
  let p = if decrlooplimit <> 0 then Passes.WalkDecrLoopLimit.apply decrlooplimit p else p in
  let p = Passes.WalkSimplifyExpressions.apply () p in
  let () = check_reads p in
   (rec_, ty, p)

 (** passes for functional languages like ocaml, racket and haskell *)
let fun_passes
    ~rename
    ~fun_inline
    ~detect_effects
    ~curry ~macrotize prog =
  let rec_, ty, p = default_passes prog in
  let p = Passes.WalkInlineVars.apply () p in
  let p = ReadAnalysis.apply p in
  let () = check_reads p in
  let p = Passes.WalkRemoveInternal.apply () p in
  let p = Passes.WalkIfMerge.apply () p in
  let p = TransformFun.transform (ty, p) in
  let p = Makelet.apply curry p in
  let p = MergePrint.apply p in
  let p = if rename then RenameFun.apply p else p in
  let p = if fun_inline then FunInline.apply p else p in
  let p = RemoveInternalFun.apply p in
  let p = if detect_effects then DetectSideEffect.apply p else p in
  let p = if macrotize then MakeMacros.apply p else p in
  (rec_, ty, p)

let no_passes prog = prog

module L = StringMap
let languages, printers =
  let justprog pr _rec_ _typerEnv out processed = pr out processed in
  let typedp pr _rec_ typerEnv out processed = pr typerEnv out processed in
  let typedrecp pr rec_ typerEnv out processed = pr rec_ typerEnv out processed in
  let recp pr rec_ _typerEnv out processed = pr rec_ out processed in
  let ( => ) (cut, pa) pr out prog
    =
    (fun (err : ((Format.formatter -> unit) -> unit)) ->
      let rec_, typerEnv, processed = pa prog in
      begin
        if cut then begin
          Format.pp_set_margin out 81;
          Format.pp_set_max_indent out 80;
        end
        else begin
          Format.pp_set_margin out 16001;
          Format.pp_set_max_indent out 16000;
        end;
        pr rec_ typerEnv out processed
      end)
  in let opselfaffect = true, [Expr.Add; Expr.Mul; Expr.Div; Expr.Sub]
  in let noincr = false, [Expr.Add; Expr.Mul; Expr.Div; Expr.Sub]
  in let opselfaffecti = true, [Expr.Add; Expr.Mul; Expr.Sub]
  in let nselfaffect = false, []
  in let t = true and f = false
  in
  let ls = [
    "metalang",(t, justtype) => justprog Printer.prog ;
    "c",       (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp CPrinter.prog ;
    "fs",      (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => typedrecp ForthPrinter.prog ;
    "m",       (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp ObjCPrinter.prog ;
    "pas",     (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => justprog PasPrinter.prog ;
    "adb",     (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:t ~clikeloop:f ~decrlooplimit:0) => typedp AdaPrinter.prog;
    "cc",      (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:t ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp CppPrinter.cppPrinter ;
    "cpp",     (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:t ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp CppPrinter.proloCppPrinter ;
    "cs",      (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp CsharpPrinter.prog;
    "vb",      (f, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:t ~clikeloop:f ~decrlooplimit:0) => typedp VbDotNetPrinter.prog ;
    "java",    (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp JavaPrinter.prog ;
    "groovy",  (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp GroovyPrinter.prog ;
    "js",      (t, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:opselfaffecti ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => justprog JsPrinter.prog ;
    "st",      (f, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:t ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => justprog SmalltalkPrinter.prog ;
    "go",      (f, clike_passes ~tuple:t ~record:t ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect               ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => typedp GoPrinter.prog ;
    "cl",      (t, clike_passes ~tuple:t ~record:t ~array:f ~mergeif:t ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => typedp CommonLispPrinter.prog ;
    "php",     (t, clike_passes ~tuple:f ~record:t ~array:t ~mergeif:f ~arrayconst:t ~arrayindex1:f ~opselfaffect:opselfaffecti ~arraysubone:f ~clikeloop:t ~decrlooplimit:0) => justprog PhpPrinter.prog ;
    "scala",   (f, clike_passes ~tuple:f ~record:f ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => typedp ScalaPrinter.prog ;
    "lua",     (t, clike_passes ~tuple:f ~record:f ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:t ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => justprog LuaPrinter.prog ;
    "py",      (f, clike_passes ~tuple:f ~record:f ~array:t ~mergeif:f ~arrayconst:t ~arrayindex1:f ~opselfaffect:noincr        ~arraysubone:f ~clikeloop:f ~decrlooplimit:(-1)) => typedp PyPrinter.prog ;
    "pl",      (t, clike_passes ~tuple:f ~record:f ~array:t ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => justprog PerlPrinter.prog ;
    "ml",      (t, clike_passes ~tuple:f ~record:f ~array:f ~mergeif:t ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => recp OcamlPrinter.prog ;
    "fsscript",(t, clike_passes ~tuple:f ~record:f ~array:f ~mergeif:t ~arrayconst:f ~arrayindex1:f ~opselfaffect:nselfaffect   ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => recp FSharpPrinter.prog ;
    "rb",      (f, clike_passes ~tuple:f ~record:f ~array:f ~mergeif:f ~arrayconst:f ~arrayindex1:f ~opselfaffect:noincr        ~arraysubone:f ~clikeloop:f ~decrlooplimit:0) => justprog RbPrinter.prog ;
    "fun.ml",  (t, fun_passes ~rename:f ~fun_inline:f ~detect_effects:f ~curry:t  ~macrotize:t) => justprog OcamlFunPrinter.prog;
    "rkt",     (t, fun_passes ~rename:f ~fun_inline:f ~detect_effects:f ~curry:f ~macrotize:t ) => typedp RacketPrinter.prog;
    "hs",      (f, fun_passes ~rename:t  ~fun_inline:t  ~detect_effects:t  ~curry:t  ~macrotize:t) => typedp HaskellPrinter.prog
  ] in
  let langs : string list = List.map fst ls |> List.sort String.compare in
  let map = L.from_list ls
  in langs, map

let remove_unknown_languages =
  let go lang =
    L.mem lang printers
    || (Printf.fprintf stderr "unknown language %s\n" lang ; false)
  in List.filter go

let stdlib_file =
  try
    Sys.getenv "METALANG_STDLIB"
  with Not_found -> "Stdlib/stdlib.metalang"

(** {2 Command Line Arguments} *)

type config = {
  mutable languages : string list ;
  mutable output_dir : string ;
  mutable filenames : string list ;
  mutable quiet : bool;
  mutable stdlib : bool;
  mutable eval : bool;
}

let default_config () = {
  languages = languages ;
  output_dir = "." ;
  filenames = [] ;
  quiet = false ;
  stdlib = true;
  eval = false;
}

(** {2 Process} *)
let warn_error_of_parse_error filename lexbuf =
  raise (Warner.Error (fun f ->
    let curr = lexbuf.Lexing.lex_curr_p in
    let line = curr.Lexing.pos_lnum in
    let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol - 1 in
    let filecontent =
      try
        let i =
          open_in filename
        in
        let l = ref "" in
        try
          for j = 1 to line do
            l := input_line i
          done;
          !l
        with End_of_file -> !l
      with Sys_error s -> ""
    in
    let spaces = if cnum = -1 then "" else String.make cnum ' ' in
    let tok = Lexing.lexeme lexbuf in
    Format.fprintf f "file:%s@\nerror line %d char %d on token %s@\n%s@\n%s^@\n"
      filename line cnum tok filecontent spaces ;
  ))

let parse_file parse filename =
  Ast.Location.parsed_file := filename;
  let lexbuf = Lexing.from_channel (open_in filename) in
  try parse Lexer.token lexbuf
  with
  | Parser.Error -> warn_error_of_parse_error filename lexbuf
  | Failure s ->
    warn_error_of_parse_error filename lexbuf

let parse_string parse str =
  Ast.Location.parsed_file := "stdin";
  let lexbuf = Lexing.from_string str in
  try parse Lexer.token lexbuf
  with
  | Parser.Error -> warn_error_of_parse_error "string" lexbuf
  | Failure s -> warn_error_of_parse_error "string" lexbuf

let make_prog_helper progname (funs, main) stdlib =
  let prog = {
    Prog.hasSkip = false;
    Prog.reads = TypeSet.empty;
    Prog.progname = progname ;
    Prog.funs = stdlib @ funs;
    Prog.main = main ;
  } in
  (*
    debug_print prog;
    let before = Passes.WalkCountNoPosition.fold () prog in
    Format.fprintf Format.std_formatter "After parsing, %d positions missing@\n" before;
  *)
  let prog = Eval.EvalConstantes.apply prog in
  (*
    debug_print prog;
    let before = Passes.WalkCountNoPosition.fold () prog in
    Format.fprintf Format.std_formatter "After eval constantes, %d positions missing@\n" before; *)

  let tyenv, prog = Typer.process prog in
  (*
    let before = Passes.WalkCountNoPosition.fold () prog in
    Format.fprintf Format.std_formatter "After typer, %d positions missing@\n" before;
  *)
  let prog = RemoveUselessFunctions.apply prog
    (List.filter Passes.no_macro funs) in
  let prog = RemoveUselessTypes.apply prog
    prog.Prog.funs tyenv in
  tyenv, prog

(**
   this string is added at the beginning of the stdlib
   It should be used (eg in macros) to know what's the target language
*)
let stdlib_string lang = Printf.sprintf "

enum @target_language
  LANG_Adb
  LANG_C
  LANG_Cc
  LANG_Cpp
  LANG_Cl
  LANG_Cs
  LANG_Fsscript
  LANG_Fun_ml
  LANG_Fs
  LANG_Go
  LANG_Groovy
  LANG_Hs
  LANG_Java
  LANG_Js
  LANG_Lua
  LANG_M
  LANG_Ml
  LANG_Pas
  LANG_Php
  LANG_Pl
  LANG_Py
  LANG_Rb
  LANG_Rkt
  LANG_Scala
  LANG_St
  LANG_Vb
  LANG_Metalang
end
def @target_language current_language ()
  return LANG_%s
end

" (String.replace "." "_" (String.capitalize_ascii lang))

let make_prog stdlib filename lang =
  let progname = Filename.chop_extension $ Filename.basename filename in
  let funs, main = parse_file Parser.prog filename in
  let stdlib = if stdlib then parse_file Parser.toplvls stdlib_file else [] in
  let stdlib_addon = parse_string Parser.toplvls (stdlib_string lang) in
  let stdlib = List.append stdlib_addon stdlib in
  make_prog_helper progname (funs, main) stdlib

let process err c filename =
  try
    if c.eval then
      let env, prog = make_prog c.stdlib filename "metalang" in
      let _ = Eval.eval_prog env prog in ()
    else
      let go lang =
        try
          let env, prog = make_prog c.stdlib filename lang in
          let printer = L.find lang printers in
          let output = c.output_dir ^ "/" ^ prog.Prog.progname ^ "." ^
            lang in
          try
            if not c.quiet then Printf.printf "Generating %s\n%!" output ;
            conf_rename lang prog ;
            Tags.reset ();
            let chan = open_out output in
            let buf = Format.formatter_of_out_channel chan in
            Format.fprintf buf "%a@;%!" (fun f () -> printer f (env, prog) err) ();
            close_out chan
          with Warner.Error e ->
            Unix.unlink output;
            err e
        with Warner.Error e ->
          err e
      in List.iter go c.languages
  with Warner.Error e ->
    err e

let process_config err c =
  List.iter (process err c) c.filenames

let js_make_prog_helper lang (funs, main) stdlib =
  Tags.reset ();
  let progname = "js_magic" in
  let stdlib = (stdlib_string lang) ^ stdlib in
  let stdlib = parse_string Parser.toplvls stdlib in
  make_prog_helper progname (funs, main) stdlib

let js_process err (lang:string) txt stdlib =
  try
    let lexbuf = Lexing.from_string txt in
    let prog' =
      try
        Parser.prog Lexer.token lexbuf
      with Parser.Error -> warn_error_of_parse_error "metalang" lexbuf
    in
    let tyenv, prog = js_make_prog_helper lang prog' stdlib in
    conf_rename lang prog ;
    let printer = L.find lang printers in
    Fresh.fresh_init prog ;
    let buf = Format.stdbuf in
    let _ = Format.flush_str_formatter () in
    Format.fprintf Format.str_formatter "%a@;%!"
      (fun f () -> printer f (tyenv, prog) err) ();
    let txt = Buffer.contents buf in
    txt
  with Warner.Error e ->
    let () = err e in ""

(* utilisé pour faire du javascript *)
module E = struct
  let add_str = ref (fun s -> ())
  let b = ref (Scanf.Scanning.from_string "")
  let print_int i =
    let _ = Format.flush_str_formatter () in
    let () = Format.fprintf Format.str_formatter "%d" i in
    (!add_str) (Format.flush_str_formatter ())
  let print_char c =
    let _ = Format.flush_str_formatter () in
    let () = Format.fprintf Format.str_formatter "%c" c in
    (!add_str) (Format.flush_str_formatter ())
  let print_string s = (!add_str) s
  let print_bool b =  (!add_str) ( if b then "True" else "False")

  let read_int () = Scanf.bscanf (!b) "%d" (fun x -> x)
  let read_char () = Scanf.bscanf (!b) "%c" (fun x -> x)
  let skip () = Scanf.bscanf (!b) "%[\n \010]" (fun _ -> ())

end

module EVString = Eval.EvalF(E)
let eval_string code stdlib err stdin stdout =
  let () = E.b := Scanf.Scanning.from_string stdin in
  let () = E.add_str := stdout in
  try
    let lexbuf = Lexing.from_string code in
    let prog' =
      try
        Parser.prog Lexer.token lexbuf
      with Parser.Error -> warn_error_of_parse_error "metalang" lexbuf
    in
    let env, prog = js_make_prog_helper "metalang" prog' stdlib in
    EVString.eval_prog env prog
  with Warner.Error e ->
    err e

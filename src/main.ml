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

(** Main
    This file is the entry point of the compiler.
    This file read options, call all passes and all printers.
    @see <http://prologin.org> Prologin
    @author Prologin (info@prologin.org)
    @author Maxime Audouin (coucou747@gmail.com)
    @author Arthur Wendling (art.wendling@gmail.com)
*)


open Ext
open Ast
open Arg
open Libmetalang

(** argument parsing *)
let config () =
  let c = default_config () in
  let all = String.concat "," languages in
  let split ls = remove_unknown_languages
    $ String.split_on_char ',' ls in
  let descr = "metalang [-lang " ^ all ^ "] [-o directory] A.metalang B.metalang ..." in
  let spec = [
    "-lang", String (fun ls -> c.languages <- split ls),
    "List of target languages separated by commas"
    ^ " [default is " ^ all ^ "]" ;

    "-o", String (fun o -> c.output_dir <- o),
    "Output directory [default is .]" ;

    "-quiet", Unit (fun () -> c.quiet <- true),
    "Display error and warnings only";

    "-nostdlib", Unit (fun () -> c.stdlib <- false),
    "Don't use the standard library";

    "-eval", Unit (fun () -> c.eval <- true),
    "Eval this file";

    "-version", Unit (fun () ->
      Printf.printf "Metalang compiler, Version %s\nDate %s\n" Version.version Version.compile_time
    ), "show the version"
  ] in
  Arg.parse spec (fun f -> c.filenames <- f :: c.filenames) descr ;
  c

let () =
  process_config (fun e ->
    Format.fprintf Format.err_formatter "%a%!" (fun f () -> e f) ();
    exit 1
  ) $ config ()

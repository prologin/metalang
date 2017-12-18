module Html = Dom_html

let doc = Html.document

let get x = Js.Opt.get x (fun () -> assert false)
let element id = get (doc##getElementById(Js.string id))
let textarea id = match Html.tagged (element id) with Html.Textarea t -> t | _ -> assert false
let textarea_content id = Js.to_string ((textarea id)##.value)

let process_error e =
  let stderr = textarea "stderr"
  and copy = textarea "copy" in
  let () = begin
    ignore (Format.flush_str_formatter ());
    e Format.str_formatter;
  end in
  let se = Format.flush_str_formatter () in
  let () = stderr##.value := (Js.string se) in
  let () = copy##.value := (Js.string "") in
  ()

let clean () =
  (textarea "stderr")##.value := Js.string "";
  (textarea "stdout")##.value := Js.string "";
  (textarea "copy")##.value := Js.string ""

let stdlib () = textarea_content "stdlib"

let click_replicate _ =
  clean ();
  let txt = textarea_content "input_text" in
  let copy = textarea "copy" in
  let select_lang = match Html.tagged (element "language") with
    | Html.Select e -> e
    | _ -> assert false in
  let lang : Libmetalang.L.key = Obj.magic (Js.to_string select_lang##.value) in
  let output = Libmetalang.js_process
    process_error
    lang txt (stdlib ()) in
  let () = copy##.value := (Js.string output) in
  Js._true

let click_eval _ =
  clean ();
  let stdin =  textarea "stdin" in
  let stdout =  textarea "stdout" in
  let prog = textarea_content "input_text" in
  let stdin_b = Js.to_string stdin##.value in
  let stdout_f s =
    stdout##.value := Js.string ((Js.to_string stdout##.value) ^ s)
  in
  Libmetalang.eval_string prog (stdlib ()) process_error stdin_b stdout_f;
  Js._true

let run _ =
  try
    (element "eval_btn")##.onclick := Html.handler click_eval ;
    (element "replicate")##.onclick := Html.handler click_replicate ;
    Js._false
  with _ -> Js._false

let _ =
  Html.window##.onload := Html.handler (fun e -> run e)

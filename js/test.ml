module Html = Dom_html

let doc = Html.document

let get x = Js.Opt.get x (fun () -> assert false)
let element id = get (doc##getElementById(Js.string id))

let to_remove = ref None


let process_error e =
  let stderr = match Html.tagged (element "stderr") with
    | Html.Textarea t -> t
    | _ -> assert false  in
  let () = begin
    ignore (Format.flush_str_formatter ());
    e Format.str_formatter;
  end in
  let se = Format.flush_str_formatter () in
  let () = stderr##value <- (Js.string se) in
  ()

let txt () =
  let textarea = match Html.tagged (element "input_text") with
    | Html.Textarea t -> t
    | _ -> assert false  in
  let txt : Js.js_string Js.t = textarea##value
  in Js.to_string txt

let stdlib () =
  let textarea = match Html.tagged (element "stdlib") with
    | Html.Textarea t -> t
    | _ -> assert false  in
  let txt : Js.js_string Js.t = textarea##value
  in Js.to_string txt

let click_replicate _ =
  let txt = txt () in
  let copy = element "copy" in
  let select_lang = match Html.tagged (element "language") with
    | Html.Select e -> e
    | _ -> assert false in
  let lang : Libmetalang.L.key = Obj.magic (Js.to_string select_lang##value) in

  let output = Libmetalang.test_process
    process_error
    lang txt (stdlib ()) in
  begin match !to_remove with
  Some node -> Dom.removeChild copy node | _ -> () end ;
  let node = doc##createTextNode (Js.string output) in
  to_remove := Some node ;
  Dom.appendChild copy node ;
  Js._true

let click_eval _ =
  let stdin = match Html.tagged (element "stdin") with
    | Html.Textarea t -> t
    | _ -> assert false  in
  let stdout = match Html.tagged (element "stdout") with
    | Html.Textarea t -> t
    | _ -> assert false  in
  let prog = txt () in
  let stdin_b = Js.to_string stdin##value in
  let () = stdout##value <- Js.string "" in
  let stdout_f s =
    stdout##value <- Js.string ((Js.to_string stdout##value) ^ s)
  in
  Libmetalang.eval_string prog (stdlib ()) process_error stdin_b stdout_f;
  Js._true

let run _ =
  let eval_btn = element "eval_btn" in
  eval_btn##onclick <- Html.handler click_eval ;
  let replicate = element "replicate" in
  replicate##onclick <- Html.handler click_replicate ;
  begin match Html.tagged (element "language") with
    | Html.Select e -> e##onchange <- Html.handler click_replicate
    | _ -> () end ;
  Js._false

let _ = Html.window##onload <- Html.handler run

open Lwt.Infix

let arg_start = ref 0
let arg_n = ref 100

let argspec =
  [
    ("-s", Arg.Set_int arg_start, "start block height");
    ("-n", Arg.Set_int arg_n, "number of blocks");
  ]

let anon_args_fun _fn = ()

let rpcuser = Sys.getenv "RPCUSER"
let rpcsecret = Sys.getenv "RPCSECRET"
let rpcendpoint = Sys.getenv "RPCENDPOINT"

let config =
  Ezcurl_lwt.Config.default |>
  Ezcurl_lwt.Config.verbose false |> (* DEBUG: set verbose to true *)
  Ezcurl_lwt.Config.username rpcuser |>
  Ezcurl_lwt.Config.password rpcsecret

  (* curl --user myusername --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockhash", "params": [1000]}' -H 'content-type: text/plain;' http://127.0.0.1:8332/ *)

let get_string jsonvalue =
  match jsonvalue with
  | `String s -> s
  | _ -> failwith "cannot get string from json value\n"

let rec rec_list_blocks client bstart bn curn =
  if curn >= bn then
    Lwt.return_unit
  else
    let headers = [] in
    let url = rpcendpoint in
    let args = Printf.sprintf "{\"jsonrpc\": \"1.0\", \"id\": \"curling\", \"method\": \"getblockhash\", \"params\": [%d]}" (curn + bstart) in
    Ezcurl_lwt.post ~config:config ~client ~headers ~url ~content:(`String args) ~params:[] () >>= fun response ->
      match response with
      | Ok resp ->
        (* let _ = Lwt_io.printlf "ok %d : %s" resp.code resp.body in *)
        if resp.code = 200 then
          let json = Yojson.Basic.from_string resp.body in
          let blockhash = json |> Yojson.Basic.Util.member "result" |> (* Yojson.Basic.to_string *) get_string in
          let _ = Lwt_io.printlf "%d,%s" (curn + bstart) blockhash in
          rec_list_blocks client bstart bn (curn + 1)
        else
          let m = Printf.sprintf "bad query %d at blockheight %d" resp.code (curn + bstart) in
          Lwt.fail_with m
      | Error (code, msg) ->
        let _ = Lwt_io.eprintlf "error %d : %s     sleeping @ %d ..." (Curl.int_of_curlCode code) msg (curn + bstart) in
        let () = Unix.sleepf 9.5 in
        rec_list_blocks client bstart bn curn

let list_blocks bstart bn =
  (* let _ = Lwt_io.printlf "blockheight, blockhash     ;;listing %d blocks from %d to %d" bn bstart (bstart + bn - 1) in *)
  let client = Ezcurl_lwt.make ~set_opts:(fun c -> Curl.set_timeout c 30) () in
  rec_list_blocks client bstart bn 0

let main () = Arg.parse argspec anon_args_fun "list_blocks: sn";
  list_blocks !arg_start !arg_n

let () = Lwt_main.run (main ())

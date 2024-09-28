open Lwt.Infix

let rpcuser = Sys.getenv "RPCUSER"
let rpcsecret = Sys.getenv "RPCSECRET"
let rpcendpoint = Sys.getenv "RPCENDPOINT"

let config =
  Ezcurl_lwt.Config.default |>
  Ezcurl_lwt.Config.verbose false |> (* DEBUG: set verbose to true *)
  Ezcurl_lwt.Config.username rpcuser |>
  Ezcurl_lwt.Config.password rpcsecret

  (* curl --user myusername --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockhash", "params": [1000]}' -H 'content-type: text/plain;' http://127.0.0.1:8332/ *)

let rec get_chain_info client =
  let headers = [] in
  let url = rpcendpoint in
  let args = Printf.sprintf "{\"jsonrpc\": \"1.0\", \"id\": \"curling\", \"method\": \"getblockchaininfo\"}" in
  Ezcurl_lwt.post ~config:config ~client ~headers ~url ~content:(`String args) ~params:[] () >>= fun response ->
    match response with
    | Ok resp ->
      (* let _ = Lwt_io.printlf "ok %d : %s" resp.code resp.body in *)
      if resp.code = 200 then
        Lwt_io.printlf "%s" resp.body
      else
        let m = Printf.sprintf "bad query; code = %d" resp.code in
        Lwt.fail_with m
    | Error (code, msg) ->
      let _ = Lwt_io.eprintlf "error %d : %s     sleeping ..." (Curl.int_of_curlCode code) msg in
      let () = Unix.sleepf 9.5 in
      get_chain_info client

let chain_info () =
  let client = Ezcurl_lwt.make ~set_opts:(fun c -> Curl.set_timeout c 30) () in
  get_chain_info client

let main () =
  chain_info ()

let () = Lwt_main.run (main ())

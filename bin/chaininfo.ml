(* BCA-Index-Bitcoin
   Copyright (C) 2024  Alexander Diemand

   This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along with this program.  If not, see <https://www.gnu.org/licenses/>. *)

open Lwt.Infix

let rpcuser = Sys.getenv "RPCUSER"
let rpcsecret = Sys.getenv "RPCSECRET"
let rpcendpoint = Sys.getenv "RPCENDPOINT"

let config =
  Ezcurl_lwt.Config.default |>
  Ezcurl_lwt.Config.verbose false |> (* DEBUG: set verbose to true *)
  Ezcurl_lwt.Config.username rpcuser |>
  Ezcurl_lwt.Config.password rpcsecret

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

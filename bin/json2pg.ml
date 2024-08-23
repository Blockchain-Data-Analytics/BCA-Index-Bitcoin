open Lwt.Infix

let arg_fp = ref ""
let arg_bn = ref (-1)
let arg_bh = ref ""

let argspec =
  [
    ("-f", Arg.Set_string arg_fp, "json file path");
    ("-n", Arg.Set_int arg_bn, "blockheight");
    ("-s", Arg.Set_string arg_bh, "blockhash");
  ]

let anon_args_fun _fn = ()

let rpcuser = Sys.getenv "RPCUSER"
let rpcsecret = Sys.getenv "RPCSECRET"
let rpcendpoint = Sys.getenv "RPCENDPOINT"

let configuration =
  Ezcurl_lwt.Config.default |>
  Ezcurl_lwt.Config.verbose false |> (* DEBUG: set verbose to true *)
  Ezcurl_lwt.Config.username rpcuser |>
  Ezcurl_lwt.Config.password rpcsecret


let parse_tx jsontx blockhash blocktime =
  let open Yojson.Basic.Util in
  let txid = jsontx |> member "txid" |> to_string in
  let version = jsontx |> member "version" |> to_int in
  let size = jsontx |> member "size" |> to_int in
  let vsize = jsontx |> member "vsize" |> to_int in
  let weight = jsontx |> member "weight" |> to_int in
  let locktime = jsontx |> member "locktime" |> to_int in
  let fee = jsontx |> member "fee" |> to_float_option |> (fun opf -> match opf with None -> "NULL" | Some f -> string_of_float f) in
  let txins = jsontx |> member "vin" in
  let txouts = jsontx |> member "vout" in
  let sql_tx = Printf.sprintf "INSERT INTO btc_transaction (txid,blockhash,blocktime,version,size,vsize,weight,locktime,fee,vin,vout) VALUES (\n  decode('%s','hex'),\n  decode('%s','hex'),\n  to_timestamp(%d)::timestamp without time zone,\n  %d,\n  %d,\n  %d,\n  %d,\n  %d,\n  %s,\n  '%s',\n  '%s');\n"
             txid blockhash blocktime version size vsize weight locktime fee (Yojson.Basic.to_string txins) (Yojson.Basic.to_string txouts) in
  sql_tx ^ "\n"

let parse_block jsonblock =
  let open Yojson.Basic.Util in
  let blockhash = jsonblock |> member "hash" |> to_string in
  let confirmations = jsonblock |> member "confirmations" |> to_int in
  let height = jsonblock |> member "height" |> to_int in
  let version = jsonblock |> member "version" |> to_int in
  let merkleroot = jsonblock |> member "merkleroot" |> to_string in
  let time = jsonblock |> member "time" |> to_int in
  let mediantime = jsonblock |> member "mediantime" |> to_int in
  let nonce = jsonblock |> member "nonce" |> to_int in
  let bits = jsonblock |> member "bits" |> to_string in
  let difficulty =
      let m = member "difficulty" jsonblock in
      try to_float m with
      | _ -> to_int m |> float_of_int
    in
  let chainwork = jsonblock |> member "chainwork" |> to_string in
  let ntx = jsonblock |> member "nTx" |> to_int in
  let previousblockhash = jsonblock |> member "previousblockhash" |> to_string_option |> (fun o -> match o with None -> "" | Some h -> h) in
  let nextblockhash = jsonblock |> member "nextblockhash" |> to_string_option |> (fun o -> match o with None -> "" | Some h -> h) in
  let strippedsize = jsonblock |> member "strippedsize" |> to_int in
  let size = jsonblock |> member "size" |> to_int in
  let weight = jsonblock |> member "weight" |> to_int in
  let txs = jsonblock |> member "tx" in
  let sql_txs = convert_each (fun tx -> parse_tx tx blockhash time) txs in
  let sql_block = Printf.sprintf "INSERT INTO btc_block (hash,confirmations,height,version,merkleroot,\"time\",mediantime,nonce,bits,difficulty,chainwork,ntx,previousblockhash,nextblockhash,strippedsize,size,weight) VALUES (\n  decode('%s','hex'),\n  %d,\n  %d,\n  %d,\n  decode('%s','hex'),\n  to_timestamp(%d)::timestamp without time zone,\n  to_timestamp(%d)::timestamp without time zone,\n  %d,\n  '%s',\n  %f,\n  decode('%s','hex'),\n  %d,\n  decode('%s','hex'),\n  decode('%s','hex'),\n  %d,\n  %d,\n  %d );\n"
             blockhash confirmations height version merkleroot time mediantime nonce bits difficulty chainwork ntx previousblockhash nextblockhash strippedsize size weight in
  (String.concat "\n" sql_txs) ^ "\n" ^ sql_block

let parse_json_file fp =
  let json = Yojson.Basic.from_file fp in
  let open Yojson.Basic.Util in
  let jsonblock = json |> member "result" in
  "BEGIN;\n" ^ parse_block jsonblock ^ "\nCOMMIT;\n"

let parse_json_request blockheight blockhash =
  let client = Ezcurl_lwt.make ~set_opts:(fun c -> Curl.set_timeout c 30) () in
  let config = configuration in
  let headers = [] in
  let url = rpcendpoint in
  let args = Printf.sprintf "{\"jsonrpc\": \"1.0\", \"id\": \"curling\", \"method\": \"getblock\", \"params\": [\"%s\", 2]}" blockhash in
  Ezcurl_lwt.post ~config ~client ~headers ~url ~content:(`String args) ~params:[] () >>= fun response ->
    match response with
    | Ok resp ->
      if resp.code = 200 then
        let json = Yojson.Basic.from_string resp.body in
        let jsonblock = json |> Yojson.Basic.Util.member "result" in
        Lwt.return ("BEGIN;\n" ^ parse_block jsonblock ^ "\nCOMMIT;\n")
      else
        let m = Printf.sprintf "bad query %d at blockheight %d for blockhash %s" resp.code blockheight blockhash in
        Lwt.fail_with m
    | Error (code, msg) ->
      let m = Printf.sprintf "error %d : %s" (Curl.int_of_curlCode code) msg in
      Lwt.fail_with m

let main () = Arg.parse argspec anon_args_fun "json2pg: fns";
  if !arg_fp != ""
  then Lwt_io.printl (parse_json_file !arg_fp)
  else
    if !arg_bn >= 0 && !arg_bh != ""
    then parse_json_request !arg_bn !arg_bh >>= Lwt_io.printl
    else Lwt_io.printl "nothing."

let () = Lwt_main.run (main ())


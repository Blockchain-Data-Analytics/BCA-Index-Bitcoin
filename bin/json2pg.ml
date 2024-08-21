
let arg_fp = ref ""

let argspec =
  [
    ("-f", Arg.Set_string arg_fp, "json file path");
  ]

let anon_args_fun _fn = ()

let parse_txout jsontxout txid =
  let open Yojson.Basic.Util in
  let value = jsontxout |> member "value" |> to_float in
  let vout = jsontxout |> member "n" |> to_int in
  let scriptpubkey = jsontxout |> member "scriptPubKey" in
  let address = scriptpubkey |> member "address" |> to_string_option |>
                   (fun oad -> match oad with
                               | None -> member "hex" scriptpubkey |> to_string_option |>
                                         (fun ohex -> match ohex with None -> "" | Some h -> h)
                               | Some ad -> ad) in
  Printf.sprintf "INSERT INTO btc_txout (txid,n,value,address) VALUES (\n  decode('%s','hex'),\n  %d,\n  %f,\n  '%s' );\n"
             txid vout value address

let parse_txin jsontxin txid =
  let open Yojson.Basic.Util in
  let txoutid = jsontxin |> member "txid" |> to_string_option |> (fun otxout -> match otxout with None -> txid | Some tx -> tx) in
  let coinbase = jsontxin |> member "coinbase" |> to_string_option |> (fun o -> match o with None -> "NULL" | Some h -> "'" ^ h ^ "'") in 
  let vout = jsontxin |> member "vout" |> to_int_option |> (fun ovout -> match ovout with None -> -1 | Some vout -> vout) in
  let sequence = jsontxin |> member "sequence" |> to_int in
  Printf.sprintf "INSERT INTO btc_txin (txid,txoutid,vout,sequence,coinbase) VALUES (\n  decode('%s','hex'),\n  decode('%s','hex'),\n  %d,\n  %d,\n  %s );\n"
             txid txoutid vout sequence coinbase

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
  let sql_txins = convert_each (fun txin -> parse_txin txin txid) txins in
  let sql_txouts = convert_each (fun txout -> parse_txout txout txid) txouts in
  let sql_tx = Printf.sprintf "INSERT INTO btc_transaction (txid,blockhash,blocktime,version,size,vsize,weight,locktime,fee) VALUES (\n  decode('%s','hex'),\n  decode('%s','hex'),\n  to_timestamp(%d)::timestamp without time zone,\n  %d,\n  %d,\n  %d,\n  %d,\n  %d,\n  %s );\n"
             txid blockhash blocktime version size vsize weight locktime fee in
  (String.concat "\n" sql_txins) ^ "\n" ^ (String.concat "\n" sql_txouts) ^ "\n" ^ sql_tx

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
  let difficulty = jsonblock |> member "difficulty" |> to_int in
  let chainwork = jsonblock |> member "chainwork" |> to_string in
  let ntx = jsonblock |> member "nTx" |> to_int in
  let previousblockhash = jsonblock |> member "previousblockhash" |> to_string_option |> (fun o -> match o with None -> "" | Some h -> h) in
  let nextblockhash = jsonblock |> member "nextblockhash" |> to_string_option |> (fun o -> match o with None -> "" | Some h -> h) in
  let strippedsize = jsonblock |> member "strippedsize" |> to_int in
  let size = jsonblock |> member "size" |> to_int in
  let weight = jsonblock |> member "weight" |> to_int in
  let txs = jsonblock |> member "tx" in
  let sql_txs = convert_each (fun tx -> parse_tx tx blockhash time) txs in
  let sql_block = Printf.sprintf "INSERT INTO btc_block (hash,confirmations,height,version,merkleroot,\"time\",mediantime,nonce,bits,difficulty,chainwork,ntx,previousblockhash,nextblockhash,strippedsize,size,weight) VALUES (\n  decode('%s','hex'),\n  %d,\n  %d,\n  %d,\n  decode('%s','hex'),\n  to_timestamp(%d)::timestamp without time zone,\n  to_timestamp(%d)::timestamp without time zone,\n  %d,\n  '%s',\n  %d,\n  decode('%s','hex'),\n  %d,\n  decode('%s','hex'),\n  decode('%s','hex'),\n  %d,\n  %d,\n  %d );\n"
             blockhash confirmations height version merkleroot time mediantime nonce bits difficulty chainwork ntx previousblockhash nextblockhash strippedsize size weight in
  (String.concat "\n" sql_txs) ^ "\n" ^ sql_block

let parse_json fp =
  let json = Yojson.Basic.from_file fp in
  let open Yojson.Basic.Util in
  let jsonblock = json |> member "result" in
  "BEGIN;\n" ^ parse_block jsonblock ^ "\nCOMMIT;\n"

let main () = Arg.parse argspec anon_args_fun "json2pg: f";
  if !arg_fp != ""
  then Lwt_io.printl (parse_json !arg_fp)
  else Lwt_io.printl "nothing."

let () = Lwt_main.run (main ())


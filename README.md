# Chain index of Bitcoin (BTC)

## Overview

The workflow consists of getting the block hashes for given block height:

`bitcoin-cli getblockhash 100000`

```json
000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506
```

and then, a dump of the block identified by its hash:

`bitcoin-cli getblock "000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506" 2`

(the 2 at the end returns the block info and all its transactions)

<details>
<summary>dump of a block in JSON</summary>

```json
{
  "hash": "000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506",
  "confirmations": 757497,
  "height": 100000,
  "version": 1,
  "versionHex": "00000001",
  "merkleroot": "f3e94742aca4b5ef85488dc37c06c3282295ffec960994b2c0d5ac2a25a95766",
  "time": 1293623863,
  "mediantime": 1293622620,
  "nonce": 274148111,
  "bits": "1b04864c",
  "difficulty": 14484.1623612254,
  "chainwork": "0000000000000000000000000000000000000000000000000644cb7f5234089e",
  "nTx": 4,
  "previousblockhash": "000000000002d01c1fccc21636b607dfd930d31d01c3a62104612a1719011250",
  "nextblockhash": "00000000000080b66c911bd5ba14a74260057311eaeb1982802f7010f1a9f090",
  "strippedsize": 957,
  "size": 957,
  "weight": 3828,
  "tx": [
    {
      "txid": "8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87",
      "hash": "8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87",
      "version": 1,
      "size": 135,
      "vsize": 135,
      "weight": 540,
      "locktime": 0,
      "vin": [
        {
          "coinbase": "044c86041b020602",
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 50.00000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84 OP_CHECKSIG",
            "desc": "pk(041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84)#40d2kraw",
            "hex": "41041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84ac",
            "type": "pubkey"
          }
        }
      ],
      "hex": "01000000010000000000000000000000000000000000000000000000000000000000000000ffffffff08044c86041b020602ffffffff0100f2052a010000004341041b0e8c2567c12536aa13357b79a073dc4444acb83c4ec7a0e2f99dd7457516c5817242da796924ca4e99947d087fedf9ce467cb9f7c6287078f801df276fdf84ac00000000"
    },
    {
      "txid": "fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4",
      "hash": "fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4",
      "version": 1,
      "size": 259,
      "vsize": 259,
      "weight": 1036,
      "locktime": 0,
      "vin": [
        {
          "txid": "87a157f3fd88ac7907c05fc55e271dc4acdc5605d187d646604ca8c0e9382e03",
          "vout": 0,
          "scriptSig": {
            "asm": "3046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1ebcc6028d9cdb1c3af7748[ALL] 04f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f25f87c161bc6f8a630121df2b3d3",
            "hex": "493046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1ebcc6028d9cdb1c3af7748014104f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f25f87c161bc6f8a630121df2b3d3"
          },
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 5.56000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 c398efa9c392ba6013c5e04ee729755ef7f58b32 OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(1JqDybm2nWTENrHvMyafbSXXtTk5Uv5QAn)#70tf4ktg",
            "hex": "76a914c398efa9c392ba6013c5e04ee729755ef7f58b3288ac",
            "address": "1JqDybm2nWTENrHvMyafbSXXtTk5Uv5QAn",
            "type": "pubkeyhash"
          }
        },
        {
          "value": 44.44000000,
          "n": 1,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 948c765a6914d43f2a7ac177da2c2f6b52de3d7c OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(1EYTGtG4LnFfiMvjJdsU7GMGCQvsRSjYhx)#t40fmm8a",
            "hex": "76a914948c765a6914d43f2a7ac177da2c2f6b52de3d7c88ac",
            "address": "1EYTGtG4LnFfiMvjJdsU7GMGCQvsRSjYhx",
            "type": "pubkeyhash"
          }
        }
      ],
      "fee": 0.00000000,
      "hex": "0100000001032e38e9c0a84c6046d687d10556dcacc41d275ec55fc00779ac88fdf357a187000000008c493046022100c352d3dd993a981beba4a63ad15c209275ca9470abfcd57da93b58e4eb5dce82022100840792bc1f456062819f15d33ee7055cf7b5ee1af1ebcc6028d9cdb1c3af7748014104f46db5e9d61a9dc27b8d64ad23e7383a4e6ca164593c2527c038c0857eb67ee8e825dca65046b82c9331586c82e0fd1f633f25f87c161bc6f8a630121df2b3d3ffffffff0200e32321000000001976a914c398efa9c392ba6013c5e04ee729755ef7f58b3288ac000fe208010000001976a914948c765a6914d43f2a7ac177da2c2f6b52de3d7c88ac00000000"
    },
    {
      "txid": "6359f0868171b1d194cbee1af2f16ea598ae8fad666d9b012c8ed2b79a236ec4",
      "hash": "6359f0868171b1d194cbee1af2f16ea598ae8fad666d9b012c8ed2b79a236ec4",
      "version": 1,
      "size": 257,
      "vsize": 257,
      "weight": 1028,
      "locktime": 0,
      "vin": [
        {
          "txid": "cf4e2978d0611ce46592e02d7e7daf8627a316ab69759a9f3df109a7f2bf3ec3",
          "vout": 1,
          "scriptSig": {
            "asm": "30440220032d30df5ee6f57fa46cddb5eb8d0d9fe8de6b342d27942ae90a3231e0ba333e02203deee8060fdc70230a7f5b4ad7d7bc3e628cbe219a886b84269eaeb81e26b4fe[ALL] 04ae31c31bf91278d99b8377a35bbce5b27d9fff15456839e919453fc7b3f721f0ba403ff96c9deeb680e5fd341c0fc3a7b90da4631ee39560639db462e9cb850f",
            "hex": "4730440220032d30df5ee6f57fa46cddb5eb8d0d9fe8de6b342d27942ae90a3231e0ba333e02203deee8060fdc70230a7f5b4ad7d7bc3e628cbe219a886b84269eaeb81e26b4fe014104ae31c31bf91278d99b8377a35bbce5b27d9fff15456839e919453fc7b3f721f0ba403ff96c9deeb680e5fd341c0fc3a7b90da4631ee39560639db462e9cb850f"
          },
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 0.01000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 b0dcbf97eabf4404e31d952477ce822dadbe7e10 OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(1H8ANdafjpqYntniT3Ddxh4xPBMCSz33pj)#ejxdpym6",
            "hex": "76a914b0dcbf97eabf4404e31d952477ce822dadbe7e1088ac",
            "address": "1H8ANdafjpqYntniT3Ddxh4xPBMCSz33pj",
            "type": "pubkeyhash"
          }
        },
        {
          "value": 2.99000000,
          "n": 1,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 6b1281eec25ab4e1e0793ff4e08ab1abb3409cd9 OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(1Am9UTGfdnxabvcywYG2hvzr6qK8T3oUZT)#te23gwt4",
            "hex": "76a9146b1281eec25ab4e1e0793ff4e08ab1abb3409cd988ac",
            "hex": "76a9146b1281eec25ab4e1e0793ff4e08ab1abb3409cd988ac",
            "address": "1Am9UTGfdnxabvcywYG2hvzr6qK8T3oUZT",
            "type": "pubkeyhash"
          }
        }
      ],
      "fee": 0.00000000,
      "hex": "0100000001c33ebff2a709f13d9f9a7569ab16a32786af7d7e2de09265e41c61d078294ecf010000008a4730440220032d30df5ee6f57fa46cddb5eb8d0d9fe8de6b342d27942ae90a3231e0ba333e02203deee8060fdc70230a7f5b4ad7d7bc3e628cbe219a886b84269eaeb81e26b4fe014104ae31c31bf91278d99b8377a35bbce5b27d9fff15456839e919453fc7b3f721f0ba403ff96c9deeb680e5fd341c0fc3a7b90da4631ee39560639db462e9cb850fffffffff0240420f00000000001976a914b0dcbf97eabf4404e31d952477ce822dadbe7e1088acc060d211000000001976a9146b1281eec25ab4e1e0793ff4e08ab1abb3409cd988ac00000000"
    },
    {
      "txid": "e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d",
      "hash": "e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d",
      "version": 1,
      "size": 225,
      "vsize": 225,
      "weight": 900,
      "locktime": 0,
      "vin": [
        {
          "txid": "f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b",
          "vout": 0,
          "scriptSig": {
            "asm": "3046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3[ALL] 04a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbb",
            "hex": "493046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3014104a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbb"
          },
          "sequence": 4294967295
        }
      ],
      "vout": [
        {
          "value": 0.01000000,
          "n": 0,
          "scriptPubKey": {
            "asm": "OP_DUP OP_HASH160 39aa3d569e06a1d7926dc4be1193c99bf2eb9ee0 OP_EQUALVERIFY OP_CHECKSIG",
            "desc": "addr(16FuTPaeRSPVxxCnwQmdyx2PQWxX6HWzhQ)#r33agg0y",
            "hex": "76a91439aa3d569e06a1d7926dc4be1193c99bf2eb9ee088ac",
            "address": "16FuTPaeRSPVxxCnwQmdyx2PQWxX6HWzhQ",
            "type": "pubkeyhash"
          }
        }
      ],
      "fee": 0.00000000,
      "hex": "01000000010b6072b386d4a773235237f64c1126ac3b240c84b917a3909ba1c43ded5f51f4000000008c493046022100bb1ad26df930a51cce110cf44f7a48c3c561fd977500b1ae5d6b6fd13d0b3f4a022100c5b42951acedff14abba2736fd574bdb465f3e6f8da12e2c5303954aca7f78f3014104a7135bfe824c97ecc01ec7d7e336185c81e2aa2c41ab175407c09484ce9694b44953fcb751206564a9c24dd094d42fdbfdd5aad3e063ce6af4cfaaea4ea14fbbffffffff0140420f00000000001976a91439aa3d569e06a1d7926dc4be1193c99bf2eb9ee088ac00000000"
    }
  ]
}
```
</details>

This gives a rough structure:

```
block: 000000000003ba27aa200b1cecaad478d2b00432346c3f1f3986da1afd33e506

tx: 8c14f0db3df150123e6f3dbbf30f8b955a8249b62ac1d1ff16284aefa3d06d87
  vin: coinbase
  vout 0: 50 @ scriptPubKey
tx: fff2525b8931402dd09222c50775608f75787bd2b87e56995a7bdd30f79702c4
  vin: 87a157f3fd88ac7907c05fc55e271dc4acdc5605d187d646604ca8c0e9382e03 vout:0
  vout 0: 5.56 @ scriptPubKey
  vout 1: 44.44 @ scriptPubKey
tx: 6359f0868171b1d194cbee1af2f16ea598ae8fad666d9b012c8ed2b79a236ec4
  vin: cf4e2978d0611ce46592e02d7e7daf8627a316ab69759a9f3df109a7f2bf3ec3 vout:1
  vout 0: 0.01 @ scriptPubKey
  vout 1: 2.99 @ scriptPubKey
tx: e9a66845e05d5abc0ad04ec80f774a7e585c6e8db975962d069a522137b80c1d
  vin: f4515fed3dc4a19b90a317b9840c243bac26114cf637522373a7d486b372600b vout:0
  vout 0: 0.01 @ scriptPubKey
```

* inputs to a transaction only contain a reference to an earlier output, so this requires a lookup with the "tx hash" and the "vout" index.

* outputs in transactions contain an index so they can be referenced later as inputs.

* the first transaction spends the miner's reward and all fees and is termed "coinbase". It has no input but only outputs.

* for performance reasons: best to use the REST API (default port 8332)

readings: https://developer.bitcoin.org/reference/transactions.html


## Schema

### Block

![Bitcoin block](out/block/block.png)

The identity is the block "hash".


### Transaction

![Bitcoin transaction](out/tx/transaction.png)

The identity is the "txid".

A transaction points to its block: "blockhash".

The field "sumins" contains the sum of values in the inputs.

The field "sumouts" contains the sum of values in the outputs.

### Transaction Input

![Bitcoin transaction input](out/txin/txin.png)

The identity is the triple: "txid", "txoutid", "vout".

A transaction input points to its transaction: "txid".

And, relates to an output: "txoutid", "vout".

We can copy over from the output its value.

### Transaction Output

![Bitcoin transaction output](out/txout/txout.png)

The identity is the tuple: "txid", "n".

A transaction output points to its transaction.

Once consumed, the field "txconsumed" contains the txid of the transaction that this output is an input.

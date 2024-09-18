#!/usr/bin/env bash

set -e

if [ $# -lt 2 ]; then
    echo "$0: <start block height> <number of blocks>"
    exit 1
fi

#STARTBLOCKHEIGHT=$1
printf -v STARTBLOCKHEIGHT "%06u" $1
NUMBLOCKS=$2

BUCKET=idx-btc

# count number of transactions
TXN=$(set -e ; { echo "SELECT COUNT(*) AS txcount FROM read_parquet('s3://${BUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet');" | duckdb -init settings -json | jq -r '.[0] | .txcount'; } || echo -n 0)
echo "    number of txs: ${TXN}"
if ! [[ -n "$TXN" && ${TXN} -ge $NUMBLOCKS ]]; then echo " *FAIL*  |tx| < \$NUMBLOCKS ($NUMBLOCKS)"; exit 1; fi

# count number of blocks
BN=$(echo "SELECT COUNT(*) AS blcount FROM read_parquet('s3://${BUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet');" | duckdb -init settings -json | jq -r '.[0] | .blcount' || echo 0)
echo "    number of blocks: ${BN}"
if ! [[ -n "$BN" && ${BN} -ge $NUMBLOCKS ]]; then echo " *FAIL*  |block| < \$NUMBLOCKS ($NUMBLOCKS)"; exit 1; fi

# check that the block heights cover the range [STARTBLOCKHEIGHT .. STARTBLOCKHEIGHT + NUMBLOCKS]
BSEQN=$(echo "SELECT SUM(delta) AS bncount FROM (SELECT (row_number() OVER (ORDER BY height)) - (height - ${STARTBLOCKHEIGHT}) AS delta FROM read_parquet('s3://${BUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet') ORDER BY height ASC);" | duckdb -init settings -json | jq -r '.[0] | .bncount' || echo 0)
echo "    block sequence coverage: ${BSEQN}%"
if ! [[ -n "$BSEQN" && ${BSEQN} -eq 100 ]]; then echo " *FAIL*  block sequence does not cover [$STARTBLOCKHEIGHT .. $((STARTBLOCKHEIGHT + NUMBLOCKS))]"; exit 1; fi

# check that the blockhashes in the transactions are the one from the block table
TXBhN=$(echo "SELECT COUNT(*) AS txbhcount FROM (SELECT DISTINCT blockhash FROM read_parquet('s3://${BUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet') AS ttx JOIN (SELECT hash FROM read_parquet('s3://${BUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet')) AS tbl ON (tbl.hash = ttx.blockhash));" | duckdb -init settings -json | jq -r '.[0] | .txbhcount' || echo 0)
echo "    number of block hashes in txs: ${TXBhN}"
if ! [[ -n "$TXBhN" && ${TXBhN} -eq $NUMBLOCKS ]]; then echo " *FAIL*  |tx.blockhash| != \$NUMBLOCKS ($NUMBLOCKS)"; exit 1; fi

echo "done."

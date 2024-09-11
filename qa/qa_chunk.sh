#!/usr/bin/env bash

set -e

if [ $# -lt 2 ]; then
    echo "$0: <start block height> <number of blocks>"
    exit 1
fi

STARTBLOCKHEIGHT=$1
NUMBLOCKS=$2

SRCINSTANCE="base1"
TGTINSTANCE="minio440"
SRCBUCKET=idx-btc
TGTBUCKET=vidx-btc

./eval_chunk.sh ${STARTBLOCKHEIGHT} ${NUMBLOCKS} && {
  mc mv -a "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet" "${TGTINSTANCE}/${TGTBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet"
  mc mv -a "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet" "${TGTINSTANCE}/${TGTBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet"
} || {
  echo ${STARTBLOCKHEIGHT} >> failed.${NUMBLOCKS}
}

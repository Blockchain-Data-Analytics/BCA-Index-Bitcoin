#!/usr/bin/env bash

set -e

if [ $# -lt 2 ]; then
    echo "$0: <start block height> <number of blocks>"
    exit 1
fi

ORIGSTBH=$1
printf -v STARTBLOCKHEIGHT "%06u" $ORIGSTBH
NUMBLOCKS=$2

SRCINSTANCE="minio440"
TGTINSTANCE="minio440"
SRCBUCKET=idx-btc
TGTBUCKET=vidx-btc

./eval_chunk.sh ${ORIGSTBH} ${NUMBLOCKS} && {
  mc mv -a "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet" "${TGTINSTANCE}/${TGTBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet"
  mc mv -a "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet" "${TGTINSTANCE}/${TGTBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet"
} || {
  echo ${ORIGSTBH} >> failed.${NUMBLOCKS}
  #mc rm "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-block.parquet"
  #mc rm "${SRCINSTANCE}/${SRCBUCKET}/btc_${STARTBLOCKHEIGHT}_${NUMBLOCKS}-tx.parquet"
}

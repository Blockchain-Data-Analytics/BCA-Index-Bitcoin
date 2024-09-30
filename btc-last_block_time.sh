#!/usr/bin/env bash

if [ -z "${PQ_ROOT}" ]; then echo "missing \$PQ_ROOT"; exit 1; fi
if [ ! -d "${PQ_ROOT}" ]; then echo "missing \$PQ_ROOT at $PQ_ROOT"; exit 1; fi


LAST_PQ_PATH=$(ls -1 ${PQ_ROOT}/btc_[89]*-block.parquet | tail -n 1)

JSON_MAX_HEIGHT=$(duckdb -json -c "SELECT height, time FROM read_parquet('$LAST_PQ_PATH') ORDER BY height DESC LIMIT 1;")

DB_MAX_HEIGHT=$(echo $JSON_MAX_HEIGHT | jq -r '.[0].height')
DB_MAX_TIME=$(echo $JSON_MAX_HEIGHT | jq -r '.[0].time')
EPOCH=$(date --date="${DB_MAX_TIME}" '+%s')
NOW=$(date '+%s')
BLOCK_TIME=$(TZ=UTC date --date="@${EPOCH}" -Iseconds)

echo "# Latest block at height ${DB_MAX_HEIGHT} from ${BLOCK_TIME}"
echo "btc_latest_block_height ${DB_MAX_HEIGHT}"
echo "btc_latest_block_time ${EPOCH}"
echo "btc_latest_block_age $((NOW - EPOCH))"


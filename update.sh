#!/usr/bin/env bash

# this script requests block hashes from bitcoind
# arguments: <start blockheight> <count>

set -e

LOCKFILE=$0.locked
if [ -e ${LOCKFILE} ]; then
    echo "$0 is locked!  retry later."
    sleep 3
    exit 1
fi

touch ${LOCKFILE}

# check presence of settings:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
#   PQ_ROOT
if [ -z "${RPCUSER}" ]; then echo "missing \$RPCUSER"; exit 1; fi
if [ -z "${RPCSECRET}" ]; then echo "missing \$RPCSECRET"; exit 1; fi
if [ -z "${RPCENDPOINT}" ]; then echo "missing \$RPCENDPOINT"; exit 1; fi
if [ -z "${PQ_ROOT}" ]; then echo "missing \$PQ_ROOT"; exit 1; fi

SLEEP_S=7

JSON_CHAIN_INFO=$(./_build/default/bin/chaininfo.exe)
LAST_BTC_BLOCK=$(echo $JSON_CHAIN_INFO | jq -r '.result.blocks')
echo "Chain at ${LAST_BTC_BLOCK}"

LAST_PQ_PATH=$(ls -1 ${PQ_ROOT}/btc_[89]*-block.parquet | tail -n 1)

LAST_PQ_FILENAME=$(basename $LAST_PQ_PATH)

JSON_MAX_HEIGHT=$(duckdb -json -c "SELECT MAX(height) AS max_height FROM read_parquet('$LAST_PQ_PATH');")

DB_MAX_HEIGHT=$(echo $JSON_MAX_HEIGHT | jq -r '.[0].max_height')
echo "Database at ${DB_MAX_HEIGHT}"

UPDATE_HEIGHT=$((DB_MAX_HEIGHT + 1))

if [ ${UPDATE_HEIGHT} -gt ${LAST_BTC_BLOCK} ]; then
    echo "already updated to block ${LAST_BTC_BLOCK}"
    rm ${LOCKFILE}
    exit 0
fi

UPDATE_CHUNK=$((UPDATE_HEIGHT / 100 * 100))

CHUNK_LENGTH=1
EXPECTED_LENGTH=1
# can we fill the chunk of 100?
END_CHUNK=$(( (UPDATE_CHUNK + 100) / 100 * 100 - 1))
if [ ${END_CHUNK} -le ${LAST_BTC_BLOCK} ]; then
    CHUNK_LENGTH=$(($END_CHUNK - $DB_MAX_HEIGHT))
    EXPECTED_LENGTH=${CHUNK_LENGTH}
    echo "CHUNK_LENGTH: $CHUNK_LENGTH = $END_CHUNK - $DB_MAX_HEIGHT"
else
    CHUNK_LENGTH=1
    EXPECTED_LENGTH=$((UPDATE_HEIGHT - UPDATE_CHUNK + 1))
    echo "expected chunk length: ${EXPECTED_LENGTH} = ${UPDATE_HEIGHT} - ${UPDATE_CHUNK} + 1"
fi

UPDATE_PQ_FILESTEM="btc_$(printf '%06d' ${UPDATE_CHUNK})_100"
UPDATE_PQ_FILEPATH_BL="${UPDATE_PQ_FILESTEM}-block.parquet"
UPDATE_PQ_FILEPATH_TX="${UPDATE_PQ_FILESTEM}-tx.parquet"
DBSTEM="${UPDATE_PQ_FILESTEM}"
if [ -e ${DBSTEM}.db ]; then
    rm ${DBSTEM}.db
fi

CMD=

if [[ -e ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_BL} && -e ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_TX} ]]; then
    CMD=".read duckdb/btc_block.sql \n.read duckdb/btc_transaction.sql"
    CMD="${CMD}\nCOPY btc_block FROM '${PQ_ROOT}/${UPDATE_PQ_FILEPATH_BL}' (FORMAT PARQUET); COPY btc_transaction FROM '${PQ_ROOT}/${UPDATE_PQ_FILEPATH_TX}' (FORMAT PARQUET);"
    echo -e $CMD | duckdb ${DBSTEM}.db
fi

time { ./lsblocks.sh ${UPDATE_HEIGHT} ${CHUNK_LENGTH} | ./json2duckdb.sh ${DBSTEM}; }

# QA

JSON_TXCOUNT=$(duckdb -json ${DBSTEM}.db -c 'SELECT COUNT(*) AS txcount FROM (SELECT DISTINCT txhash FROM btc_transaction);')
echo $JSON_TXCOUNT
TXCOUNT=$(echo $JSON_TXCOUNT | jq -r '.[0].txcount')
if [ ${TXCOUNT} -lt ${EXPECTED_LENGTH} ]; then
    echo "txcount $TXCOUNT is less than minimally expected ${EXPECTED_LENGTH}"
    exit 1
fi

JSON_BLCOUNT=$(duckdb -json ${DBSTEM}.db -c 'SELECT COUNT(*) AS blockcount FROM (SELECT DISTINCT hash FROM btc_block);')
echo $JSON_BLCOUNT
BLCOUNT=$(echo $JSON_BLCOUNT | jq -r '.[0].blockcount')
if [ ${BLCOUNT} -ne ${EXPECTED_LENGTH} ]; then
    echo "block count $BLCOUNT is not equal expected ${EXPECTED_LENGTH}"
    exit 1
fi

JSON_BLCOVERAGE=$(duckdb -json ${DBSTEM}.db -c "SELECT SUM(delta) AS bncount FROM (SELECT (row_number() OVER (ORDER BY height)) - (height - ${UPDATE_HEIGHT}) AS delta FROM btc_block ORDER BY height ASC);")
echo $JSON_BLCOVERAGE
BLCOVERAGE=$(echo $JSON_BLCOVERAGE | jq -r '.[0].bncount')
if [[ ${CHUNK_LENGTH} -eq 100 && ${BLCOVERAGE} -ne ${EXPECTED_LENGTH} ]]; then
    echo "block coverage $BLCOVERAGE is not equal expected ${EXPECTED_LENGTH}"
    exit 1
fi

JSON_TXCOVERAGE=$(duckdb -json ${DBSTEM}.db -c "SELECT COUNT(*) AS txbhcount FROM (SELECT DISTINCT blockhash FROM btc_transaction AS ttx JOIN (SELECT hash FROM btc_block) AS tbl ON (tbl.hash = ttx.blockhash));")
echo $JSON_TXCOVERAGE
TXCOVERAGE=$(echo $JSON_TXCOVERAGE | jq -r '.[0].txbhcount')
if [ ${TXCOVERAGE} -ne ${EXPECTED_LENGTH} ]; then
    echo "txcount $TXCOVERAGE is not equal expected ${EXPECTED_LENGTH}"
    exit 1
fi

# extract parquet files and copy to destination

duckdb ${DBSTEM}.db -c "COPY btc_transaction TO '${UPDATE_PQ_FILEPATH_TX}' (FORMAT PARQUET);"
duckdb ${DBSTEM}.db -c "COPY btc_block TO '${UPDATE_PQ_FILEPATH_BL}' (FORMAT PARQUET);"

mv -v ${UPDATE_PQ_FILEPATH_TX} ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_TX}.new
mv -v ${UPDATE_PQ_FILEPATH_BL} ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_BL}.new
while ! mv -v ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_TX}.new ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_TX}; do
    echo "failed to copy ${UPDATE_PQ_FILEPATH_TX} to destination ${PQ_ROOT}"
    sleep $SLEEP_S
done
while ! mv -v ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_BL}.new ${PQ_ROOT}/${UPDATE_PQ_FILEPATH_BL}; do
    echo "failed to copy ${UPDATE_PQ_FILEPATH_BL} to destination ${PQ_ROOT}"
    sleep $SLEEP_S
done

# release lock

rm ${LOCKFILE}

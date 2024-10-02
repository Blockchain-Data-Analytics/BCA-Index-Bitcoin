#!/usr/bin/env bash

# Copyright &copy; 2024 Alexander Diemand
# Licensed under GPL-3; see [LICENSE](/LICENSE)

# this script reads records from stdin
# a record contains: <blockheight>,<blockhash>
# one by line

#set -e

# arguments: <duckdb name>

if [ $# -ne 1 ]; then
   echo "$0: <duckdb name>"
   exit 1
fi

OLDIFS=$IFS
IFS=,


# check presence of settings:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
if [ -z "${RPCUSER}" ]; then echo "missing \$RPCUSER"; exit 1; fi
if [ -z "${RPCSECRET}" ]; then echo "missing \$RPCSECRET"; exit 1; fi
if [ -z "${RPCENDPOINT}" ]; then echo "missing \$RPCENDPOINT"; exit 1; fi

# setup DuckDB db
DBSTEM="$1"
DBNAME="${DBSTEM}.db"
if [ -e ${DBNAME} ]; then
   echo "duckdb db: ${DBNAME} already exists."
else
   echo -e ".read duckdb/btc_block.sql \n.read duckdb/btc_transaction.sql" | duckdb ${DBNAME}
fi

# loop through blockheight, blockhash pairs
{
   read BLOCKHEIGHT BLOCKHASH;
   while [ -n "$BLOCKHEIGHT" ]; do
      ./_build/default/bin/json2sql.exe -duckdb -n ${BLOCKHEIGHT} -s ${BLOCKHASH} ;
      read BLOCKHEIGHT BLOCKHASH;
   done
} | duckdb ${DBNAME}


IFS=$OLDIFS


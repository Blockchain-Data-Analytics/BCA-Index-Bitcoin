#!/bin/bash

# Copyright &copy; 2024 Alexander Diemand
# Licensed under GPL-3; see [LICENSE](/LICENSE)

# this script reads records from stdin
# a record contains: <blockheight>,<blockhash>
# one by line

OLDIFS=$IFS
IFS=,


# check presence of settings:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
if [ -z "${RPCUSER}" ]; then echo "missing \$RPCUSER"; exit 1; fi
if [ -z "${RPCSECRET}" ]; then echo "missing \$RPCSECRET"; exit 1; fi
if [ -z "${RPCENDPOINT}" ]; then echo "missing \$RPCENDPOINT"; exit 1; fi

{
  read BLOCKHEIGHT BLOCKHASH;
  while [ -n "$BLOCKHEIGHT" ]; do
    #echo "h=$BLOCKHEIGHT hash=$BLOCKHASH";
    ./_build/default/bin/json2sql.exe -pg -n ${BLOCKHEIGHT} -s ${BLOCKHASH} | psql -q -b ;
    read BLOCKHEIGHT BLOCKHASH;
  done
}

IFS=$OLDIFS

#!/bin/sh

# this script reads records from stdin
# a record contains: <blockheight>,<blockhash>
# one by line

OLDIFS=$IFS
IFS=,


# include settings which defines:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
. settings

{
  read BLOCKHEIGHT BLOCKHASH;
  while [ -n "$BLOCKHEIGHT" ]; do
    #echo "h=$BLOCKHEIGHT hash=$BLOCKHASH";
    ./_build/default/bin/json2sql.exe -pg -n ${BLOCKHEIGHT} -s ${BLOCKHASH} | psql -q -b ;
    read BLOCKHEIGHT BLOCKHASH;
  done
}

IFS=$OLDIFS


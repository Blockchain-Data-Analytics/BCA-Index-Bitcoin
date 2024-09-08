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
	  echo "h=$BLOCKHEIGHT hash=$BLOCKHASH";
	  curl --user ${RPCUSER}:${RPCSECRET} --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblock", "params": ["'${BLOCKHASH}'", 2]}' -H 'content-type: text/plain;' -o data/${BLOCKHEIGHT}.json $RPCENDPOINT 
	  read BLOCKHEIGHT BLOCKHASH;
	 done
}

IFS=$OLDIFS


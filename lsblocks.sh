#!/bin/sh

# this script requests block hashes from bitcoind
# arguments: <start blockheight> <count>

# include settings which defines:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
. settings

if [ $# -ne 2 ]; then
   echo "$0: <start blockheight> <count>"
   exit 1
fi

_build/default/bin/lsblocks.exe -s $1 -n $2


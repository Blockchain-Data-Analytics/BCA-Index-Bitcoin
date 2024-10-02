#!/usr/bin/env bash

# Copyright &copy; 2024 Alexander Diemand
# Licensed under GPL-3; see [LICENSE](/LICENSE)

# this script requests block hashes from bitcoind
# arguments: <start blockheight> <count>

set -e

# check presence of settings:
#   RPCUSER
#   RPCSECRET
#   RPCENDPOINT
if [ -z "${RPCUSER}" ]; then echo "missing \$RPCUSER"; exit 1; fi
if [ -z "${RPCSECRET}" ]; then echo "missing \$RPCSECRET"; exit 1; fi
if [ -z "${RPCENDPOINT}" ]; then echo "missing \$RPCENDPOINT"; exit 1; fi

if [ $# -ne 2 ]; then
   echo "$0: <start blockheight> <count>"
   exit 1
fi

./_build/default/bin/lsblocks.exe -s $1 -n $2


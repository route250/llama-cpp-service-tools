#!/bin/bash

set -ue
LLAMA_HOME="$(cd $(dirname $0)/..;pwd)"
LLAMA_LOG=$LLAMA_HOME/logs
LLAMA_CONF=$LLAMA_HOME/conf/
mkdir -p $LLAMA_LOG
LOG_FILE=$LLAMA_LOG/llama-server-$(date +'%Y-%m-%d').log
exec >>$LOG_FILE 2>&1
echo "start $(date +'%Y-%m-%d %H:%M:%S')"

CTX=10000
exec $LLAMA_HOME/bin/llama-server -t 12 -tb 12 --host 0.0.0.0 -c $CTX -ub $CTX -b $CTX --embeddings --reasoning-budget 128

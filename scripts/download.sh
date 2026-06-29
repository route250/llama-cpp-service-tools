#!/bin/bash


# curl -LsSf https://hf.co/cli/install.sh | bash

HF_MODEL_NAME="google/gemma-4-E4B-it-qat-q4_0-gguf"
printf "/exit\n" | bin/llama-cli -hf "$HF_MODEL_NAME" --no-warmup --simple-io --color off --no-display-prompt
bin/llama-server --cl

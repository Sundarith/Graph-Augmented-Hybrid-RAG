#!/usr/bin/env bash
# Reproduce the shipped CTI-Bench RCM result:
# Phi-4-mini-reasoning + context-only prompt + Graph-Augmented Hybrid RAG.
#
# Start vLLM first:
#   CUDA_VISIBLE_DEVICES=0 vllm serve microsoft/Phi-4-mini-reasoning \
#     --enable-prefix-caching --trust-remote-code --port 8000 \
#     --max-model-len 24576 --gpu-memory-utilization 0.90

set -euo pipefail

cd "$(dirname "$0")/.."

export CTI_RAG_RCM_ONLY="${CTI_RAG_RCM_ONLY:-1}"
export CTI_RAG_PROMPT_CONTEXT_ONLY="${CTI_RAG_PROMPT_CONTEXT_ONLY:-1}"
export CTI_RAG_LLM_MODEL="${CTI_RAG_LLM_MODEL:-microsoft/Phi-4-mini-reasoning}"
export CTI_RAG_CWE_HYDE="${CTI_RAG_CWE_HYDE:-0}"
export CTI_RAG_CWE_PHRASE_SELECTOR="${CTI_RAG_CWE_PHRASE_SELECTOR:-0}"
export CTI_RAG_CWE_MAPPED_FAST_CONTEXT="${CTI_RAG_CWE_MAPPED_FAST_CONTEXT:-0}"
export CTI_RAG_CWE_HIERARCHY_EXPANSION="${CTI_RAG_CWE_HIERARCHY_EXPANSION:-0}"
export CTI_RAG_MAPPED_BRIDGE_PREFER_LAST_NVD="${CTI_RAG_MAPPED_BRIDGE_PREFER_LAST_NVD:-0}"
export CTI_RAG_CWE_CROSSENCODER="${CTI_RAG_CWE_CROSSENCODER:-1}"
export CTI_RAG_LLM_RESPONSE_BUDGET="${CTI_RAG_LLM_RESPONSE_BUDGET:-2048}"
export CTI_RAG_LLM_MAX_MODEL_LEN="${CTI_RAG_LLM_MAX_MODEL_LEN:-24576}"
export CTI_RAG_EMBEDDER_DEVICE="${CTI_RAG_EMBEDDER_DEVICE:-cpu}"
export CTI_RAG_CWE_CROSSENCODER_DEVICE="${CTI_RAG_CWE_CROSSENCODER_DEVICE:-cpu}"
export CTI_RAG_EVAL_WORKERS="${CTI_RAG_EVAL_WORKERS:-16}"

if (($#)); then
  exec python3 -u eval_rcm.py "$@"
else
  exec python3 -u eval_rcm.py 1000
fi

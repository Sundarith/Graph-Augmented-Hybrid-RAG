# Reproducibility

This file keeps the exact shipped CTI-Bench RCM recipe separate from exploratory scripts
and historical ablations.

## Expected Result

The shipped configuration reports:

| Split | Score |
| --- | ---: |
| Full CTI-Bench RCM | 909/1000 (90.9%) |
| NVD-mapped CVEs | 837/903 (92.7%) |
| NVD-unmapped CVEs | 72/97 (74.2%) |

## Data

The benchmark and raw CVE corpus are not committed. Place them at:

```text
data/cti-bench/data/cti-rcm.tsv
data/raw/cves/cves/YYYY/*.json
```

The committed MITRE and processed metadata files provide the compact public-data layer.
Large generated files such as `data/processed/cve_chunks.jsonl` and
`data/processed/chunk_embs.npy` are intentionally ignored.

See `DATA.md` for source provenance and rebuild commands.

## Serve Phi-4-mini-reasoning

```bash
CUDA_VISIBLE_DEVICES=0 vllm serve microsoft/Phi-4-mini-reasoning \
  --enable-prefix-caching --trust-remote-code --port 8000 \
  --max-model-len 24576 --gpu-memory-utilization 0.90
```

## Run the Full Benchmark

In another terminal:

```bash
conda activate cyber-ft
scripts/run_shipped_phi_eval.sh 1000
```

Equivalent explicit environment:

```bash
CTI_RAG_RCM_ONLY=1 \
CTI_RAG_PROMPT_CONTEXT_ONLY=1 \
CTI_RAG_LLM_MODEL=microsoft/Phi-4-mini-reasoning \
CTI_RAG_CWE_HYDE=0 \
CTI_RAG_CWE_PHRASE_SELECTOR=0 \
CTI_RAG_CWE_MAPPED_FAST_CONTEXT=0 \
CTI_RAG_CWE_HIERARCHY_EXPANSION=0 \
CTI_RAG_MAPPED_BRIDGE_PREFER_LAST_NVD=0 \
CTI_RAG_CWE_CROSSENCODER=1 \
CTI_RAG_LLM_RESPONSE_BUDGET=2048 \
CTI_RAG_LLM_MAX_MODEL_LEN=24576 \
CTI_RAG_EMBEDDER_DEVICE=cpu \
CTI_RAG_CWE_CROSSENCODER_DEVICE=cpu \
CTI_RAG_EVAL_WORKERS=16 \
python3 -u eval_rcm.py 1000
```

## Protocol Notes

- The scorer uses strict CWE-ID matching with zero-padding tolerance.
- The evaluation uses CTI-Bench `row["Prompt"]` unchanged; it does not add the CVE ID.
- The final classification path uses one LLM call per query.
- Historical router, picker, HyDE, phrase-selector, hierarchy-expansion, and T-RAFT
  experiments are not part of the shipped recipe.

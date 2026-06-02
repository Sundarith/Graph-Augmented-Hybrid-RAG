# Data

CTI-RAG uses public vulnerability and weakness data at inference time. This file explains
which data is committed, which data is local-only, and how to rebuild the generated
indexes used by the shipped CTI-Bench RCM result.

## Committed Public Data

The repository includes compact public-data artifacts derived from MITRE/NVD sources:

| Path | Purpose |
| --- | --- |
| `data/raw/cwec_latest.xml` | MITRE CWE catalog |
| `data/raw/cwec_latest.xml.zip` | CWE source archive |
| `data/raw/capec_latest.zip` | CAPEC source archive |
| `data/raw/enterprise-attack.json` | MITRE ATT&CK STIX bundle |
| `data/raw/stix-capec.json` | CAPEC STIX bundle |
| `data/processed/cwe_chunks.jsonl` | CWE retrieval chunks |
| `data/processed/cve_cwe_index.json` | CVE ID to NVD CWE mapping index |
| `data/processed/*relations.json` | Lightweight graph relation files |

The shipped CVE-to-CWE benchmark result primarily uses NVD CVE records and MITRE CWE
chunks. ATT&CK/CAPEC files support the broader interactive CTI traversal code path.

## Local-Only Data

These files are intentionally not committed:

| Path | Reason |
| --- | --- |
| `data/cti-bench/` | Third-party benchmark checkout |
| `data/raw/cves/` | Large NVD CVE corpus |
| `data/processed/cve_chunks.jsonl` | Generated from local NVD CVE files |
| `data/processed/cwe_chunks_augmented.jsonl` | Experiment-only generated chunks |
| `data/processed/cwe_phrase_index.json` | Experiment-only generated phrase index |
| `data/processed/chunk_embs*.npy` | Generated embedding caches |
| `logs/` | Per-run outputs and timing/debug traces |
| `analysis/*_eval_failures_debug.jsonl` | Per-model failure logs |

To run the full reproduction, clone CTI-Bench into `data/cti-bench/` and place the NVD
CVE JSON tree under `data/raw/cves/cves/YYYY/*.json`.

## Rebuild

Run the source-specific builders after refreshing raw data:

```bash
python3 build_attack_chunks.py
python3 build_capec_chunks.py
python3 build_cwe_chunks.py
python3 build_cve_chunks.py
```

Then rebuild the CVE-to-CWE index:

```bash
python3 - <<'PY'
import json
from pathlib import Path

index = {}
with open("data/processed/cve_chunks.jsonl", encoding="utf-8") as f:
    for line in f:
        item = json.loads(line)
        index[item["identifier"]] = item.get("cwe_ids", [])

Path("data/processed/cve_cwe_index.json").write_text(json.dumps(index), encoding="utf-8")
print(f"Written {len(index):,} entries")
PY
```

Delete `data/processed/chunk_embs.npy` after changing any chunk file so embeddings are
rebuilt on the next run.

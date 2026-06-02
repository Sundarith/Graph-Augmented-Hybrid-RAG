# Scripts

Use `run_shipped_phi_eval.sh` for the reported CTI-Bench RCM result:

```bash
scripts/run_shipped_phi_eval.sh 1000
```

Use `zero_shot_eval.py` for no-retrieval model baselines:

```bash
python3 scripts/zero_shot_eval.py 1000 --model microsoft/Phi-4-mini-reasoning
```

Older launchers for routed ensembles, T-RAFT, paper figure patching, and model-lineup
orchestration were removed from the public tree because they are not part of the shipped
artifact recipe.

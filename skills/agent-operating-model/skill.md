---
name: agent-operating-model
description: Define how agents execute the spec semi-autonomously (roles, multi-model topology, lifecycle gates, autonomy boundaries).
---

# Agent Operating Model Skill

- Source Spec: `docs/10_agent_ops/operating_model.md`
- Upstream: `operations-deployment-release`, `agent-memory-memsearch`
- Downstream: `agent-loop-memory-governance`

## Workflow
1. Fix component role boundaries (ralph=retry policy, hermes=executor, memsearch=episodic authority).
2. Define multi-model topology with the invariant Code Verifier ≠ Code Generator.
3. Map each lifecycle phase (design→dev→verify→test→deploy) to an objective completion gate.
4. Set autonomy boundaries: stage autonomous, prod human approval, no prod credentials in agent env.

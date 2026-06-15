---
name: agent-loop-memory-governance
description: Define ralph loop stop policy, objective completion judging, and memory governance (two-axis authority, anti-poisoning).
---

# Agent Loop & Memory Governance Skill

- Source Spec: `docs/10_agent_ops/loop_and_memory_governance.md`
- Upstream: `agent-operating-model`
- Downstream: none

## Workflow
1. Set ralph stop policy (tasks.json, max_iter, cost kill-switch, test_gate, dirty_worktree, stop_reason).
2. Bind completion to objective gates; enforce test-directory write Locker.
3. Split memory into episodic (memsearch sole authority) vs procedural (hermes SKILL.md, PR-promoted); disable hermes persistent FTS5/MEMORY.
4. Enforce anti-poisoning: verified-only, post-merge indexing, status field, curated failure_memory.

---
name: data-model
description: Lock entity schema, constraints, indexes, and data lifecycle for implementation.
---

# Data Model Skill

- Source Spec: `docs/03_data/data_model.md`
- Upstream: `requirements-functional`
- Downstream: `data-migration`, `api-endpoints`, `agent-memory-memsearch`

## Workflow
1. Define entities, columns, constraints, and indexes.
2. Verify normalization and query access patterns.
3. Fix retention, masking, and deletion policy.
4. Output migration-ready schema baseline.


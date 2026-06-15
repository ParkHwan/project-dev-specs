---
name: data-migration
description: Define ordered migration and rollback plan from fixed data model changes.
---

# Data Migration Skill

- Source Spec: `docs/03_data/migration_strategy.md`
- Upstream: `data-model`
- Downstream: none

## Workflow
1. Create phase-ordered migration steps.
2. Define backward compatibility window.
3. Add rollback and recovery checkpoints.
4. Output migration runbook for release.


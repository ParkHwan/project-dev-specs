---
name: data-pipeline
description: Define ETL/ELT pipeline design, data quality, scheduling, and backfill/idempotency rules.
---

# Data Pipeline Skill

- Source Spec: `docs/03_data/pipeline_spec.md`
- Upstream: `data-model`
- Downstream: `operations-observability`, `risk-management`

## Workflow
1. Define source → storage tiers (Raw/Refined/Curated) and batch vs streaming.
2. Specify scheduling/orchestration (DAG, triggers, retries).
3. Set data quality checks and failure policy.
4. Define idempotency, backfill, partitioning, and freshness SLA.

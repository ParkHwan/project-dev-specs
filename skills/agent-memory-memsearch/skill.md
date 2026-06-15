---
name: agent-memory-memsearch
description: Integrate memsearch-based markdown long-term memory with schema, retrieval policy, and operational controls.
---

# Agent Memory memsearch Skill

- Source Spec: `docs/03_data/memsearch_memory.md`
- Upstream: `data-model`, `api-guidelines`
- Downstream: `risk-management`

## Workflow
1. Define memory schema and metadata contract.
2. Fix retrieval strategy (Vector + BM25 + RRF) and fallback path.
3. Apply masking, retention, and delete policy before storage.
4. Add observability metrics and reindex operation runbook.

## Done Criteria
- 저장/검색/삭제 E2E 테스트 통과
- 민감정보 마스킹 검증 통과
- 검색 지연/적중률 메트릭 수집 확인


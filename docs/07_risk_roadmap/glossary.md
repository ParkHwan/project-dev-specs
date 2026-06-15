# 📖 Glossary

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 프로젝트에서 사용하는 용어를 정의합니다. 도메인 용어는 프로젝트별로 채우고, 아래 기술 용어/약어는 본 템플릿 문서에서 실제 사용된 항목을 미리 정리해 두었습니다.

---

## 15.1 도메인 용어 (프로젝트별 작성)

| 용어 | 정의 | 관련 섹션 |
|------|------|-----------|
| [도메인 용어 1] | [정의] | [섹션] |
| [도메인 용어 2] | [정의] | [섹션] |

---

## 15.2 기술 용어

| 용어 | 정의 |
|------|------|
| Expand/Contract | 파괴적 스키마 변경을 추가→이관→전환→제거 단계로 나눠 무중단 적용하는 패턴 |
| Backfill | 신규 스키마/로직에 맞춰 과거 데이터를 일괄 채워 넣는 작업 |
| Idempotency(멱등성) | 같은 요청/작업을 여러 번 수행해도 결과가 동일하게 유지되는 성질 |
| Circuit Breaker | 연쇄 장애 방지를 위해 실패가 임계치를 넘으면 호출을 차단하는 패턴 |
| Golden Signals | 지연/트래픽/에러/포화도 — SRE의 핵심 관측 지표 4종 |
| Error Budget | SLO 미달을 허용하는 한도(= 1 − SLO). 소진율(burn rate)로 관리 |
| Canary | 신버전을 일부 트래픽에만 점진 노출하는 배포 기법 |
| memsearch | Markdown 기반 에이전트 장기기억 저장/검색 시스템 (Milvus 백엔드) |
| RRF | Reciprocal Rank Fusion — 벡터/BM25 등 복수 검색 결과를 결합하는 랭킹 기법 |

---

## 15.3 약어 목록

| 약어 | 전체 명칭 |
|------|-----------|
| SLI | Service Level Indicator |
| SLO | Service Level Objective |
| SLA | Service Level Agreement |
| RPO / RTO | Recovery Point / Time Objective |
| RBAC | Role-Based Access Control |
| RACI | Responsible, Accountable, Consulted, Informed |
| CI/CD | Continuous Integration / Continuous Deployment |
| ADR | Architecture Decision Record |
| STRIDE | Spoofing, Tampering, Repudiation, Information disclosure, DoS, Elevation of privilege |
| SBOM | Software Bill of Materials |
| DAG | Directed Acyclic Graph (워크플로 의존 그래프) |
| ETL / ELT | Extract-Transform-Load / Extract-Load-Transform |
| IaC | Infrastructure as Code |
| FinOps | Cloud Financial Operations |
| WCAG | Web Content Accessibility Guidelines |
| OKR / KPI | Objectives & Key Results / Key Performance Indicator |
| BM25 | Best Matching 25 (키워드 검색 랭킹 함수) |
| TTL | Time To Live |

---

## 🔗 관련 문서
- [프로젝트 로드맵 (Roadmap)](./roadmap.md)
- [문제 정의 및 목표](../01_requirements/problem_and_goals.md)
- [에이전트 장기기억 (memsearch)](../03_data/memsearch_memory.md)

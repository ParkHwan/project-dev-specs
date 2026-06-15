# project-dev-specs — 프로젝트 상태 (단일 출처)

> 이 파일이 프로젝트 상태의 단일 출처(Source of Truth)다. 세션 시작 시 먼저 읽고, 변화가 생기면 갱신한다.

## 목적
다양한 개발 프로젝트(Web/API/ML·AI/Data Pipeline/Library)에 재사용할 **공통 개발 명세서 템플릿 + 에이전트 실행 체계**를 정교화한다. 산업 표준(Google PRD/SRE, Microsoft SDL, OWASP, C4, AWS Well-Architected) 기반.

## 원격 저장소
- GitHub: https://github.com/ParkHwan/project-dev-specs (worktree를 여기서 가져감)

## 구조 — 레이아웃 B (평탄화 완료)
repo 루트 직속 배치:
- **SoT = `docs/`** (01_requirements ~ 09_ux, 99_appendix). 모든 내용 수정은 여기서 시작.
- 실행 레이어: `skill.md`(executor) + `BUILD_SPEC_TEMPLATE.md`(Build-Ready 게이트) + `skills/`(26 스킬 + `skill_graph.yaml/.md` DAG).
- `archive/`: `PROJECT_SPECIFICATION.monolith.md`(1세대, deprecated), `PROJECT_SPECIFICATION_EN.md`(영문, stale), `reviews/`(LLM 분석본 4종).
- 차별점: `docs/03_data/memsearch_memory.md` — 에이전트 장기기억(memsearch/Milvus) 정책.

## 경로 규약
- 스킬·그래프·템플릿의 문서 참조는 **repo 루트 상대경로** (`docs/...`, `BUILD_SPEC_TEMPLATE.md`). `Project_Specification_Enhancement/` 접두어는 전부 제거됨.
- docs 내부 문서 간 링크는 상대(`./`, `../`).

## 완료된 작업
- P0~P2(2026-06-15): SoT 배너, 경로 통일, 허브 Quick Nav/매트릭스, 섹션번호 충돌 해소(tech_stack 6.6), 플레이스홀더 표준규칙, 빈약문서 4종 보강+ADR 템플릿, OpenAPI 정책, 신규문서 4종(ui_spec/cost_management/iac/pipeline_spec)+스킬/그래프 반영, 한/영 동기화 정책.
- 레이아웃 B 평탄화: 스킬 레이어를 repo 루트로 이동, `docs/` 루트 직속화, 경로 28곳 재정렬, monolith/EN/분석본 `archive/`로, MAC 복구보고서는 repo 밖 `/Users/parkhwan/개인/`로 분리(무결, 명세와 무관).

## 남은 작업 (다음 세션 우선순위)
- **[정리] git 초기 커밋** — project-dev-specs 원격에 첫 커밋 구조 잡기(현재 로컬 변경 미커밋).
- **[정합] 하위문서 메타데이터 헤더, 양방향 상호참조, 섹션번호 근본 비번호화(선택)**.
- **[콘텐츠] `endpoints.md` 리소스별 확장, `security_spec` 체크리스트 실제화, resilience 패턴, `README.md` 보강(현재 2줄)**.

## 컨벤션 / 주의
- 문서는 한국어 우선. 수정은 항상 SoT(`docs/`)에서 → 필요 시 EN 동기화.
- 보강 문서는 `[브래킷]` 템플릿이며, build-spec-gate 게이트는 "실제 프로젝트에 채운 사본"에 적용(템플릿 자체는 통과 대상 아님).
- 참고: git 미추적 파일은 mv 전에 위치를 확인할 것(이번에 MAC 보고서를 repo 밖 `개인/`로 옮긴 뒤 검색 범위 착오로 분실로 오인한 사례 있음 — 실제로는 무결).
- 관련 메모리: [[style_and_conventions]], [[suggested_commands]], [[task_completion]]

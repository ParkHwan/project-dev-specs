# project-dev-specs

프로젝트 개발 명세서 및 기술 문서 관리 Repository

다양한 개발 프로젝트(Web · API · ML/AI · Data Pipeline · Library)에 재사용하는 **모듈형 개발 명세서 템플릿**과, 그 명세를 에이전트가 즉시 개발에 쓸 수 있게 검증·실행하는 **에이전트 실행 체계**를 함께 관리한다. 산업 표준(Google PRD/SRE, Microsoft SDL, OWASP, C4, AWS Well-Architected) 기반.

---

## 단일 진실 출처 (Source of Truth)

- **`docs/` (한국어 모듈형) 가 원본이다.** 모든 내용 수정은 여기서 시작한다.
- `archive/`의 monolith·영문본은 파생/보존본이며 직접 수정하지 않는다.
- 한/영 동기화 정책: [`docs/99_appendix/references.md`](docs/99_appendix/references.md) 참조.

## 레이아웃

```
project-dev-specs/
├── skill.md                  # 에이전트 실행기(executor) 진입점
├── BUILD_SPEC_TEMPLATE.md    # Build-Ready 게이트(착수 전 채우는 실행 스펙)
├── docs/                     # ★ SoT: 모듈형 명세 (도메인별 분리)
├── skills/                   # 도메인 스킬 26개 + skill_graph(DAG)
├── archive/                  # monolith(deprecated)·영문본(stale)·LLM 리뷰 보관
└── .serena/                  # serena 프로젝트(메모리 포함)
```

### 경로 규약
문서 참조 경로는 **repo 루트 상대경로**를 쓴다 (예: `docs/01_requirements/functional.md`). `docs/` 내부 문서 간 링크는 상대(`./`, `../`)를 쓴다. 디렉터리 레이아웃을 바꾸면 `skills/`·`skill_graph`·`BUILD_SPEC_TEMPLATE.md`의 참조도 함께 맞춘다.

---

## 사용법

### 1) 명세 채우기
프로젝트마다 [`docs/PROJECT_SPECIFICATION.md`](docs/PROJECT_SPECIFICATION.md)(허브)에서 시작해, **프로젝트 유형별 필수 섹션 매트릭스**를 보고 해당 하위 문서의 `[브래킷]` 플레이스홀더를 실제 값으로 채운다.

### 2) Build-Ready 게이트
구현 착수 전 [`BUILD_SPEC_TEMPLATE.md`](BUILD_SPEC_TEMPLATE.md)를 채우고 게이트(섹션 1)를 통과시킨다. 플레이스홀더 잔존 검사는 표준 규칙으로 고정되어 있다([`skills/build-spec-gate/skill.md`](skills/build-spec-gate/skill.md)).

```bash
# 플레이스홀더(미완성) 검사 — 매칭 0건이어야 Build-Ready
grep -rInE 'TODO|TBD|FIXME|XXX|\[[^]]*\]|\{[^}]*\}|example\.com|YYYY-MM-DD' docs | grep -v 'gate:ignore'
```

### 3) 에이전트 실행
[`skill.md`](skill.md)가 실행기다. 스킬은 [`skills/skill_graph.md`](skills/skill_graph.md)의 의존 그래프(DAG)와 실행 순서를 따른다:

```
build-spec-gate → requirements-* → architecture-* → data-*/api-*
  → agent-memory-memsearch → engineering-*/ux-ui-spec/security-spec
  → operations-* → risk-management → roadmap → glossary → appendix-references
```

---

## 문서 색인 (`docs/`)

| 도메인 | 문서 |
|--------|------|
| 01 요구사항 | problem_and_goals · stakeholders · functional · non_functional |
| 02 아키텍처 | system_design · deployment_arch · tech_stack |
| 03 데이터 | data_model · migration_strategy · pipeline_spec · **memsearch_memory** |
| 04 API | api_guidelines · endpoints |
| 05 엔지니어링 | coding_style · testing_strategy |
| 06 운영 | observability · deployment_release · cost_management · infrastructure_as_code |
| 07 리스크/로드맵 | risk_management · roadmap · glossary |
| 08 보안/프라이버시 | security_spec |
| 09 UX | ui_spec |
| 99 부록 | references · adr/ |

> **차별점 — 에이전트 장기기억**: [`docs/03_data/memsearch_memory.md`](docs/03_data/memsearch_memory.md)는 일반 명세엔 드문 memsearch(Milvus 백엔드) 기반 저장/검색/보존/삭제/재색인 정책을 다룬다.

---

## 작업 규칙

- 추정이 아닌 **스펙 기반**으로 구현한다. 스펙 공백/충돌은 코드 작성 전에 차단 이슈로 보고한다.
- 각 작업은 `요구사항 → 구현 → 테스트 → 검증` 순으로 기록한다.
- 문서는 한국어 우선. 수정은 항상 SoT(`docs/`)에서 → 필요 시 영문본 동기화.
- 보강 문서의 `[브래킷]`은 템플릿 표시이며, Build-Ready 게이트는 "실제 프로젝트에 채운 사본"에 적용한다(템플릿 자체는 통과 대상 아님).

## 프로젝트 상태

진행 상태의 단일 출처는 [`.serena/memories/project_overview.md`](.serena/memories/project_overview.md)다. 세션 시작 시 먼저 읽고, 변화가 생기면 갱신한다.

# Build-Ready Specification Template

> 목적: 에이전트가 즉시 개발 착수 가능한 수준으로 스펙을 고정한다.
> 적용 기준: `docs` 기반
> 상태: `Draft | Build-Ready | In-Progress | Done`

---

## 0. 문서 메타

- 프로젝트명:
- 버전:
- 작성일:
- 마지막 수정일:
- 오너(의사결정권자):
- Tech Lead:
- 대상 저장소/브랜치:
- 배포 목표일:

---

## 1. Build-Ready 게이트 (모두 충족해야 착수)

- [ ] `TODO`, `TBD`, `[값]`, `[날짜]` 등 플레이스홀더가 없다.
- [ ] MVP 범위(In-Scope / Out-of-Scope)가 확정되었다.
- [ ] 기능 요구사항이 User Story + Acceptance Criteria로 명시되었다.
- [ ] API 계약(요청/응답/에러코드)이 확정되었다.
- [ ] 데이터 스키마(타입/제약/인덱스/마이그레이션 순서)가 확정되었다.
- [ ] 테스트 통과 기준(단위/통합/E2E/커버리지)이 수치로 정의되었다.
- [ ] 운영 기준(SLO/알람/롤백/런북)이 명시되었다.
- [ ] 보안/개인정보 요구사항이 구현 항목으로 분해되었다.
- [ ] 장기기억 전략(memsearch: 저장/검색/보존/삭제/재색인)이 정의되었다.
- [ ] 리스크와 대응전략, 차단 이슈(blocker)가 등록되었다.

---

## 2. 참조 문서 매핑 (기존 가이드 연결)

- 요구사항/목표: `docs/01_requirements/problem_and_goals.md`
- 기능 요구사항: `docs/01_requirements/functional.md`
- 비기능 요구사항: `docs/01_requirements/non_functional.md`
- 이해관계자/RACI: `docs/01_requirements/stakeholders.md`
- 아키텍처: `docs/02_architecture/system_design.md`
- 기술스택: `docs/02_architecture/tech_stack.md`
- 기술 스택: `docs/02_architecture/tech_stack.md`
- 데이터 모델/마이그레이션/파이프라인: `docs/03_data/*.md`
- 에이전트 장기기억(memsearch): `docs/03_data/memsearch_memory.md`
- API: `docs/04_api/*.md`
- 코딩/테스트 전략: `docs/05_engineering/*.md`
- 배포/관측성/비용(FinOps)/IaC: `docs/06_operations/*.md`
- 리스크/로드맵/용어: `docs/07_risk_roadmap/*.md`
- 보안/프라이버시: `docs/08_security_privacy/security_spec.md`
- UI/UX·접근성: `docs/09_ux/ui_spec.md`
- 부록/ADR: `docs/99_appendix/references.md`, `.../adr/`

---

## 3. 프로젝트 실행 스펙 (에이전트 입력용)

### 3.1 Problem / Goal / KPI

- 문제 정의(As-Is):
- 목표 상태(To-Be):
- KPI 1 (현재/목표/기한):
- KPI 2 (현재/목표/기한):
- 제외 범위(Out-of-Scope):

### 3.2 범위 및 릴리스 단위

- MVP 기능 목록:
- v1.0 추가 기능:
- 이번 스프린트 구현 범위:
- 이번 스프린트 비구현 범위:

### 3.3 기능 요구사항 (필수 형식)

#### Story ID:
- As a:
- I want:
- So that:
- Priority: `P0|P1|P2`
- Dependencies:

Acceptance Criteria:
- [ ] Given/When/Then 기준 1
- [ ] Given/When/Then 기준 2
- [ ] 실패/예외 처리 기준

Definition of Done:
- [ ] 코드 + 테스트 + 문서 반영
- [ ] 리뷰 승인
- [ ] 관측성(로그/메트릭) 반영

### 3.4 API 계약

- 엔드포인트:
- 메서드:
- 인증 방식:
- 요청 스키마(JSON):
- 응답 스키마(JSON):
- 에러코드/조건:
- 멱등성/재시도 정책:
- Rate Limit:

### 3.5 데이터 계약

- 엔터티/테이블:
- 컬럼(타입, nullable, default):
- PK/FK/Unique/Index:
- 데이터 보존/삭제 정책:
- 마이그레이션 순서:
- 롤백 전략:

### 3.6 비기능 요구사항

- 가용성 SLO:
- 지연시간 SLO (p95/p99):
- 처리량 목표:
- 에러버짓:
- 보안 요구사항(암호화, 시크릿, 접근통제):
- 개인정보 요구사항(수집/마스킹/파기):

### 3.7 테스트 전략

- 단위 테스트 범위:
- 통합 테스트 범위:
- E2E 시나리오:
- 테스트 데이터 준비:
- 최소 커버리지 기준:
- CI 게이트(실패 조건):

### 3.8 운영/배포

- 환경(dev/stage/prod) 차이:
- 필수 환경변수:
- 배포 방식(blue-green/canary/rolling):
- 롤백 트리거/절차:
- 알람 임계치:
- 장애 대응 Runbook 링크:

### 3.9 리스크/결정 로그

- 주요 리스크:
- 완화 전략:
- 미결정 이슈:
- 결정사항(ADR):

### 3.10 에이전트 장기기억 (memsearch)

- 메모리 저장 단위(문서/세션/태스크):
- 필수 메타데이터(project_id, session_id, task_id, tags, timestamp):
- 검색 전략(벡터/BM25/RRF 가중치):
- 최근성 정책(recency window):
- 요약/압축 정책(토큰 한도):
- 개인정보 마스킹 규칙(저장 전):
- TTL/보존/삭제 정책:
- 재색인(백필) 전략:
- 실패 시 폴백(기본 검색/캐시):

---

## 4. 에이전트 작업 규칙 (실행 표준)

- 추정이 아닌 스펙 기반으로 구현한다.
- 스펙 공백/충돌이 있으면 코드 작성 전에 차단 이슈로 보고한다.
- 각 작업은 `요구사항 -> 구현 -> 테스트 -> 검증 결과` 순서로 기록한다.
- PR/커밋 단위는 Story 또는 API 계약 단위로 자른다.
- 완료 보고에는 변경 파일, 테스트 결과, 잔여 리스크를 포함한다.

---

## 5. 착수 승인 체크 (PM/Tech Lead)

- [ ] Build-Ready 게이트 통과
- [ ] 스프린트 범위 승인
- [ ] 일정/리소스 승인
- [ ] 차단 이슈 없음
- [ ] 개발 착수 승인

승인자:
승인일:

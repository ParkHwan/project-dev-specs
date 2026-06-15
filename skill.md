---
name: build-ready-project-executor
description: Hermes runner contract. Use when executing implementation from project-dev-specs. Validates build readiness, resolves spec gaps first, then executes per-TASK under the agent operating model (ralph-bounded retries, memsearch memory, objective-gate completion) with test evidence.
---

# Build-Ready Project Executor Skill (Hermes Runner Contract)

> 이 스킬은 단순 executor가 아니라 **hermes 실행자가 따르는 runner contract**다.
> 반복은 ralph 정책으로 bound되고, 완료는 객관 게이트로 판정하며, 기억은 memsearch가 공급한다.
> 운영 모델: [docs/10_agent_ops/operating_model.md](docs/10_agent_ops/operating_model.md),
> 루프/메모리/완료 규칙: [docs/10_agent_ops/loop_and_memory_governance.md](docs/10_agent_ops/loop_and_memory_governance.md).

## Trigger

- 사용자가 "이 문서를 기반으로 개발 시작", "스펙 기반 구현", "에이전트로 개발 진행"을 요청할 때 사용한다.
- 기준 문서는 `BUILD_SPEC_TEMPLATE.md`와 `docs`이다.

## Runner 규약 (요약)

- **단일 TASK 단위 실행**: ralph가 `tasks.json`에서 한 TASK를 주입하면 "검색→변경→테스트→기록"까지만 수행한다.
- **완료는 자기판단 금지**: CI·테스트·contract·smoke 통과로만 done(테스트 디렉터리 쓰기 잠금 준수).
- **생성자≠검증자**: 코드 생성과 적대적 교차검증은 다른 모델이 맡는다.
- **검증된 것만 기억**: post-merge 시 memsearch 인덱싱, 미검증 추론 저장 금지.
- **prod 차단**: prod 배포는 사람 승인 게이트, prod 크레덴셜 미주입.

## Inputs

- 프로젝트 코드베이스 경로
- 채워진 build 스펙 파일 경로 (`BUILD_SPEC_TEMPLATE.md` 기반)
- 타겟 브랜치/배포 환경

## Execution Workflow

1. 스펙 로드
- `BUILD_SPEC_TEMPLATE.md`와 연결된 도메인 문서를 확인한다.
- 범위(MVP/스프린트), API/데이터 계약, 테스트 기준을 우선 추출한다.

2. Build-Ready 판정
- 플레이스홀더(`TODO`, `TBD`, `[값]`, `[날짜]`) 잔존 여부를 먼저 검사한다.
- 미기입 또는 충돌 항목이 있으면 구현을 멈추고 "차단 이슈 목록"을 작성한다.

3. 작업 분해
- Story/엔드포인트/마이그레이션 단위로 태스크를 분해한다.
- 각 태스크에 `입력 스펙`, `완료 조건`, `테스트 항목`을 연결한다.

4. 구현
- 스펙에 명시된 범위만 구현한다.
- 스펙 변경이 필요하면 먼저 변경 제안을 작성하고 승인 후 반영한다.

5. 검증
- 단위/통합/E2E 테스트를 실행한다.
- 실패 시 원인과 영향 범위를 명확히 남긴다.

6. 보고
- `요구사항 -> 구현 결과 -> 테스트 결과 -> 잔여 리스크` 순서로 보고한다.
- 변경 파일 목록과 배포/롤백 영향도를 포함한다.

## Non-Negotiable Rules

- 추측 구현 금지: 스펙에 없는 기능은 추가하지 않는다.
- 테스트 없는 완료 금지: 최소 1개 이상의 검증 증거를 남긴다.
- 계약 위반 금지: API/데이터 계약을 임의 변경하지 않는다.
- 차단 이슈 은닉 금지: 미확정 항목은 즉시 명시한다.

## Output Format

아래 형식을 고정해서 출력한다.

```md
## Implementation Summary
- Scope:
- Stories/Tasks Done:

## Validation
- Unit:
- Integration:
- E2E:
- Coverage/Quality Gate:

## Risks & Follow-ups
- Open Risks:
- Blockers:
- Next Actions:
```

## Quick Start Prompt

```text
`BUILD_SPEC_TEMPLATE.md`와 연결 문서를 기준으로 Build-Ready 여부를 먼저 점검하세요.
누락/충돌 항목은 차단 이슈로 먼저 보고하고, 승인된 범위 내에서만 구현하세요.
각 작업은 요구사항-구현-테스트-리스크 형식으로 결과를 남겨주세요.
```


---
name: build-spec-gate
description: Validate BUILD_SPEC_TEMPLATE completeness and open blockers before implementation starts.
---

# Build Spec Gate Skill

- Source Spec: `BUILD_SPEC_TEMPLATE.md`
- Upstream: none
- Downstream: `requirements-*`

## Workflow
1. Run the standard placeholder scan (see below). Any hit = FAIL.
2. Verify gate checklist in section 1 is all complete.
3. Produce blocker list if any item is missing.
4. Mark state: `Draft` or `Build-Ready`.

## Standard Placeholder Scan (고정 규칙)

Build-Ready 판정 전, 대상 스펙에 대해 아래 단일 규칙으로 검사한다.
한 건이라도 매칭되면 즉시 `FAIL`이며 매칭 위치를 blocker로 보고한다.

- 검사 정규식(대소문자 무시):
  `TODO|TBD|FIXME|XXX|\[[^\]]*\]|\{[^}]*\}|example\.com|YYYY-MM-DD`
- 표준 명령(레포 루트에서 실행):
  ```bash
  grep -rInE 'TODO|TBD|FIXME|XXX|\[[^]]*\]|\{[^}]*\}|example\.com|YYYY-MM-DD' \
    docs | grep -v 'gate:ignore'
  ```
- 의도적으로 남기는 토큰(예: 코드/정규식 예시)은 해당 라인에
  `<!-- gate:ignore -->`를 붙여 예외 처리하고, "허용된 예외"로 분리 보고한다.

## Output
- Gate result: `PASS|FAIL`
- Placeholder scan: 매칭 건수 + `파일:라인` 목록 (0건이어야 PASS)
- Missing fields with owner/action
- Approved scope for next implementation cycle


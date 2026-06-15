# 🔁 Loop & Memory Governance

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: ralph 반복 루프의 정지 정책과, 3주체(hermes/memsearch/사람)가 공유하는 기억의 권위·오염 방지 규칙을 정의합니다. 운영 모델 전반은 [operating_model.md](./operating_model.md) 참조.

---

## Ralph Loop 정책

ralph는 **한 TASK에 대한 제한된 반복 정책**이다(총괄 루프 아님). 다음을 강제한다.

| 항목 | 규칙 |
|------|------|
| 상태 파일 | `tasks.json` — 각 TASK 상태(todo/in_progress/blocked/done) read/write |
| `max_iterations` | TASK당 [예: 6]회 초과 시 강제 종료 + 사람 에스컬레이션 |
| 비용 킬스위치 | 누적 토큰/비용 한도(예: 세션당 [$5] 또는 [N]회) 초과 시 `exit 1` + 알림(예: Slack) |
| `max_wall_time` | TASK당 [예: 20분] 초과 시 종료 |
| `max_diff_size` | 변경 규모 상한 초과 시 종료(스코프 폭주 방지) |
| `test_gate` | 루프 1회 = "검색 → 변경 → 테스트 → 기록"까지만. 테스트가 backpressure |
| `dirty_worktree_policy` | 미커밋 변경이 정책 위반이면 중단 |
| `stop_reason` | 종료 시 반드시 사유 기록(success/max_iter/budget/escalation) |
| 모드 | greenfield/격리 브랜치 = 전면 반복 / 기존 repo = **TASK 단위 patch mode만** |

---

## 완료 판정 (거짓 완료 방지)

완료는 **에이전트 응답이 아니라 객관 산출물**로 판정한다.

- `<promise>`(또는 done 마킹)는 **CI green · contract test · smoke test · 빌드 아티팩트** 결과에 결속한다.
- 🔒 **테스트 디렉터리 쓰기 잠금(Locker)**: 에이전트 CLI에 테스트 디렉터리 쓰기 권한을 주지 않는다. 테스트를 고치거나 mocking으로 통과시키는 꼼수를 권한 레벨에서 차단(테스트 변경이 필요하면 별도 사람 승인 TASK).
- 적대적 교차검증(Code Verifier)은 게이트 통과 **후** 도는 소프트 레이어이며 최종 권위가 아니다(→ [operating_model](./operating_model.md)).

---

## 메모리 2축 권위

기억을 **에피소드 / 절차** 두 축으로 가르고, 각 축에 권위를 하나씩만 둔다(이중 canonical 금지).

| 축 | 단일 권위 | 내용 | 비고 |
|----|-----------|------|------|
| 에피소드(events) | **memsearch** | 결정/태스크/실패 이력 | hermes 네이티브 FTS5·MEMORY.md의 **영속 에피소드 저장은 비활성화** |
| 절차(how-to) | **hermes SKILL.md** | 반복 작업 절차·트러블슈팅 경로 | 자동 설치 금지 → **PR 리뷰 후 승격** |
| 세션(휘발) | (RAM only) | 진행 중 단기 컨텍스트 | 영속화하지 않음 → 상태 desync·컨텍스트 비대화 방지 |

- 세부 저장/검색/보존 규격은 [memsearch_memory.md](../03_data/memsearch_memory.md)를 따른다.
- 컨텍스트 비대화("Lost in the Middle")를 막기 위해 재기동 시 **최소 맥락만 시맨틱하게 주입**한다(전체 히스토리 강제 주입 금지).

---

## 메모리 오염 방지 (Negative Transfer)

- **자동 저장 금지**: 미검증 추론·임시 우회 코드(workaround)는 기억하지 않는다.
- **검증 시점 결속**: memsearch 인덱싱은 **post-merge 훅**(main/develop에 squash-merge된 산출물 + ADR)에서만 수행.
- **상태 필드**: `verified | unverified | deprecated`. 검색 시 `verified` 우선, `deprecated` 제외.
- **실패 기억**: 원시 로그가 아니라 **검증된 사후분석(failure_memory)** 만 저장.
- **스킬 승격**: SKILL.md 후보는 사람 PR 리뷰 후 승격(부정적 전이 차단).

---

## 비용·관측성

- 멀티모델(Generator+Verifier+Doc Reviewer)은 비용이 곱해진다 → 킬스위치를 **멀티모델 합산 기준**으로 설정.
- 루프 건강 지표(→ [observability](../06_operations/observability.md)): TASK당 반복수, 성공률, memsearch 적중률, `stop_reason` 분포, TASK당 비용.

---

## 🔗 관련 문서
- [에이전트 운영 모델](./operating_model.md)
- [에이전트 장기기억 (memsearch)](../03_data/memsearch_memory.md)
- [관측성 및 모니터링](../06_operations/observability.md)
- [보안 및 프라이버시](../08_security_privacy/security_spec.md)

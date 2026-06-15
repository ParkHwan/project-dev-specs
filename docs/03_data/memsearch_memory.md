# 🧠 Agent Long-term Memory (memsearch)

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 에이전트가 이전 문맥을 안정적으로 재사용할 수 있도록 memsearch 기반 장기기억 규격을 정의합니다.

---

## M1. 목적 및 범위

- 목적: 대화/작업/결정 이력을 Markdown 기반으로 저장하고, 다음 세션에서 검색/복원하여 개발 연속성을 확보한다.
- 범위:
- In-Scope: 작업 로그, 요구사항 결정사항, 이슈/해결 이력, 배포/장애 요약
- Out-of-Scope: 민감 원문(PII, 토큰, 비밀번호), 법적 보관 대상 원본 문서

---

## M2. 메모리 단위 및 스키마

#### 저장 단위
- `memory_note`: 단일 사실/결정/요약
- `memory_session`: 세션 요약(시작/종료 상태)
- `memory_task`: 태스크 실행 결과(요구사항-구현-테스트-리스크)

#### 필수 메타데이터
| 필드 | 타입 | 필수 | 설명 |
|------|------|:----:|------|
| memory_id | string | ✅ | 메모리 고유 ID |
| project_id | string | ✅ | 프로젝트 식별자 |
| session_id | string | ✅ | 세션 식별자 |
| task_id | string | ✅ | 태스크/스토리 식별자 |
| memory_type | enum | ✅ | note/session/task |
| tags | array[string] | ✅ | 기능/도메인 태그 |
| content_md | text | ✅ | Markdown 본문 |
| summary | text | ✅ | 짧은 요약 |
| created_at | datetime | ✅ | 생성 시각 |
| updated_at | datetime | ✅ | 수정 시각 |
| ttl_days | int | ✅ | 보존 기간 |
| pii_masked | bool | ✅ | 마스킹 완료 여부 |

---

## M3. 검색 전략

- 검색 방식: `Vector + BM25 + RRF` 하이브리드
- 기본 쿼리:
- 입력: 현재 태스크 요약 + 최근 변경 파일 + 태그
- 출력: 상위 `k=10` 후보 -> 재랭킹 상위 `k=5`
- 가중치 가이드:
- 벡터 유사도: 0.5
- BM25: 0.3
- 최근성(recency boost): 0.2
- 폴백:
- 검색 실패 시 최근 세션 요약 + 동일 태그 메모리 우선 반환

---

## M4. 저장 정책

| 이벤트 | 저장 시점 | 저장 내용 |
|--------|-----------|-----------|
| Story 시작 | 작업 시작 직후 | 목표, 범위, 의존성 |
| Story 완료 | 테스트 통과 후 | 구현 요약, 검증 결과, 잔여 리스크 |
| 장애 발생 | 원인 파악 시점 | 증상, 원인, 임시 조치 |
| 배포 완료 | 릴리즈 직후 | 변경점, 롤백 포인트 |

저장 포맷 예시:

```md
## Memory: TASK-123
- Scope: 사용자 인증 API 개선
- Changes: token refresh 로직 분리
- Validation: unit 24 pass, integration 7 pass
- Risks: refresh 토큰 만료 경계 케이스 1건
```

---

## M5. 개인정보/보안 정책

- 저장 전 마스킹 필수:
- 이메일, 전화번호, 주민번호/식별번호
- 액세스 토큰/시크릿/API 키
- 사용자 원문 입력 중 민감정보
- 접근 제어:
- 프로젝트 단위 네임스페이스 분리
- 운영 환경 쓰기 권한 최소화
- 감사 로그:
- memory write/read/delete 이벤트 기록

---

## M6. 운영 정책

- 인덱스 재생성(reindex): 주 1회 또는 스키마 변경 시
- 백필(backfill): 신규 태그 체계 도입 시 최근 90일 대상
- 데이터 보존:
- 기본 180일
- 릴리즈/장애 메모리 365일
- 삭제:
- TTL 만료 자동 삭제
- 수동 삭제 요청 시 24시간 내 반영

---

## M7. 수용 기준 (Definition of Done)

- [ ] memsearch 연동 코드가 빌드 파이프라인에서 정상 동작한다.
- [ ] 저장/검색/삭제 E2E 테스트가 통과한다.
- [ ] 민감정보 마스킹 테스트가 통과한다.
- [ ] 장애 시 폴백 경로가 검증되었다.
- [ ] 운영 대시보드에 메모리 지표가 반영되었다.

---

## 🔗 관련 문서
- [데이터 모델](./data_model.md)
- [마이그레이션 전략](./migration_strategy.md)
- [관측성 및 모니터링](../06_operations/observability.md)
- [보안 및 프라이버시](../08_security_privacy/security_spec.md)

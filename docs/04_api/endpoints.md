# 📡 API Endpoints Spec

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 리소스별로 엔드포인트를 문서화합니다. **기계가 읽는 단일 소스는 OpenAPI 스펙**이며(→ [api_guidelines.md 8.6](./api_guidelines.md#86-openapi-단일-소스-정책)), 이 문서는 그 스펙을 사람이 빠르게 읽기 위한 동반 문서입니다. 스키마가 바뀌면 OpenAPI를 먼저 고치고 이 문서를 맞춥니다(수기 중복 금지).

> ℹ️ 섹션 번호: API 설계 원칙은 `api_guidelines.md`가 8.1~8.7, 본 문서는 **8.8부터** 사용합니다.

---

## 8.8 공통 규약

모든 엔드포인트에 공통 적용. 개별 절에서는 차이만 명시한다.

- **Base URL / 버저닝 / 인증 / 공통 헤더 / 에러 모델**: [api_guidelines.md](./api_guidelines.md) 8.2~8.5를 따른다.
- **페이지네이션**: 목록 조회는 `limit`(기본 [20], 최대 [100]) + `cursor`(권장) 또는 `offset`.
  ```json
  { "data": [], "meta": { "next_cursor": "eyJ...", "has_more": true } }
  ```
- **필터링/정렬**: `?status=active&sort=-created_at` (`-` 접두어 = 내림차순). 허용 필드는 리소스별로 명시.
- **부분 응답**: `?fields=id,name` 으로 필드 선택(선택 지원).
- **멱등성**: 생성/결제 등 부작용 있는 POST는 `Idempotency-Key` 헤더 필수(→ 8.4).

---

## 8.9 리소스별 엔드포인트

> 아래는 **작성 양식 + 예시(Users)**입니다. 실제 프로젝트 리소스로 교체하세요. 리소스마다 메서드 요약 표 + 엔드포인트 상세를 둡니다.

### 8.9.1 [예시] Users

| 메서드 | 경로 | 설명 | 인증 | 필요 권한 |
|--------|------|------|:----:|-----------|
| GET | `/api/v1/users` | 사용자 목록 | ✅ | `users:read` |
| GET | `/api/v1/users/{id}` | 사용자 단건 | ✅ | `users:read` |
| POST | `/api/v1/users` | 사용자 생성 | ✅ | `users:write` |
| PATCH | `/api/v1/users/{id}` | 부분 수정 | ✅ | `users:write` |
| DELETE | `/api/v1/users/{id}` | 삭제 | ✅ | `users:admin` |

#### `POST /api/v1/users` — 사용자 생성

생성 시 `Idempotency-Key` 헤더로 중복 생성을 방지한다.

**Request**

```json
{ "email": "user@example.com", "name": "홍길동", "role": "member" }
```

| 필드 | 타입 | 필수 | 기본값 | 제약/설명 |
|------|------|:----:|--------|-----------|
| `email` | string | ✅ | - | RFC 5322, unique |
| `name` | string | ✅ | - | 1~50자 |
| `role` | enum | ❌ | `member` | `member` \| `admin` |

**Response (201 Created)**

```json
{ "data": { "id": "usr_123", "email": "user@example.com", "name": "홍길동", "role": "member", "created_at": "2026-01-01T00:00:00Z" },
  "meta": { "request_id": "req_xxx" } }
```

**에러 (8.5 공통 모델 사용)**

| HTTP | code | 조건 |
|------|------|------|
| 400 | `VALIDATION_ERROR` | 필드 검증 실패 |
| 409 | `CONFLICT` | 이메일 중복 |
| 422 | `UNPROCESSABLE_ENTITY` | 비즈니스 규칙 위반 |

- **멱등성**: 동일 `Idempotency-Key` 재요청 시 최초 생성 결과를 재반환(중복 생성 없음).
- **권한**: `users:write`. 타 테넌트 사용자 생성 불가.

#### `GET /api/v1/users` — 목록

- 쿼리: `limit`, `cursor`, `status`, `sort`(허용: `created_at`, `name`).
- Response: `data[]` + `meta.next_cursor` (8.8 페이지네이션 규약).

> 다른 리소스는 위 양식을 복제해 8.9.2, 8.9.3 …으로 추가한다.

---

## 8.10 Rate Limiting

| 엔드포인트 | 제한 | 윈도우 |
|------------|:----:|--------|
| 기본 | [100] req | 1분 |
| [고비용 API] | [10] req | 1분 |

**응답 헤더**

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1706961600
```

초과 시 `429 RATE_LIMIT_EXCEEDED` + `Retry-After` 헤더 반환.

---

## 🔗 관련 문서
- [API 가이드라인 (Guidelines)](./api_guidelines.md)
- [기능 요구사항 (Functional)](../01_requirements/functional.md)
- [보안 정책 (Security)](../08_security_privacy/security_spec.md)

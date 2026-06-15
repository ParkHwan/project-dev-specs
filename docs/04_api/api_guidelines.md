# 🔌 API Guidelines

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: [Google API Design Guide](https://cloud.google.com/apis/design) 원칙을 따릅니다.

---

## 8.1 API 설계 원칙

| 원칙 | 적용 |
|------|------|
| 버저닝 | URL Path (`/api/v1/...`) |
| 리소스 지향 | 명사형 리소스 |
| 표준 메서드 | GET/POST/PUT/PATCH/DELETE |
| 에러 모델 | 일관된 JSON 구조 |
| 페이지네이션 | `limit`, `offset` 또는 `cursor` |
| 멱등성 | `Idempotency-Key` 헤더 지원 |

---

## 8.2 Base URL

| 환경 | URL |
|------|-----|
| Production | `https://api.example.com/api/v1` |
| Staging | `https://api-staging.example.com/api/v1` |
| Development | `http://localhost:8000/api/v1` |

---

## 8.3 인증/인가

```http
Authorization: Bearer <access_token>
```

| 인증 방식 | 용도 |
|-----------|------|
| OAuth 2.0 / JWT | 사용자 인증 |
| API Key | 서비스 간 통신 |

---

## 8.4 공통 헤더

| 헤더 | 필수 | 설명 |
|------|:----:|------|
| `Authorization` | ✅ | 인증 토큰 |
| `Content-Type` | ✅ | `application/json` |
| `X-Request-ID` | ❌ | 요청 추적 ID |
| `Idempotency-Key` | ❌ | POST 멱등성 키 |

---

## 8.5 에러 응답 모델

```json
{
    "error": {
        "code": "ERROR_CODE",
        "message": "Human-readable message",
        "details": [
            {
                "field": "field_name",
                "reason": "validation error reason"
            }
        ],
        "request_id": "req_xxx"
    }
}
```

#### 에러 코드 목록

| HTTP Status | Code | 설명 |
|-------------|------|------|
| 400 | `VALIDATION_ERROR` | 요청 데이터 검증 실패 |
| 400 | `INVALID_PARAMETER` | 잘못된 파라미터 |
| 401 | `UNAUTHORIZED` | 인증 필요 |
| 403 | `FORBIDDEN` | 권한 없음 |
| 404 | `NOT_FOUND` | 리소스 없음 |
| 409 | `CONFLICT` | 리소스 충돌 |
| 429 | `RATE_LIMIT_EXCEEDED` | 요청 한도 초과 |
| 500 | `INTERNAL_ERROR` | 서버 내부 오류 |
| 503 | `SERVICE_UNAVAILABLE` | 서비스 일시 불가 |

---

## 8.6 OpenAPI 단일 소스 정책

API 스펙은 **OpenAPI 3.1 문서 하나를 단일 소스(Single Source of Truth)**로 둔다.

- **스펙 위치**: [`api/openapi.yaml` 등 레포 내 고정 경로]
- **생성 방식**: [코드-퍼스트(데코레이터/애노테이션에서 생성) | 스펙-퍼스트(스펙에서 클라이언트/서버 스텁 생성)] 중 택1을 명시한다.
- **문서 렌더링**: [Swagger UI / Redoc] 로 자동 게시.
- **동기화 검증(CI)**: 스펙과 구현 불일치를 막기 위해 CI에서 contract test 또는 spec-diff를 실행하고, `endpoints.md`는 이 스펙에서 파생/링크한다(수기 중복 금지).
- **버저닝**: 호환 불가 변경은 URL major 버전을 올리고 ADR로 기록한다.

---

## 🔗 관련 문서
- [상세 엔드포인트 명세 (Endpoints)](./endpoints.md)
- [보안 정책 (Security)](../08_security_privacy/security_spec.md)
- [부록/참고 (OpenAPI 링크)](../99_appendix/references.md)

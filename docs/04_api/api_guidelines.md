# 🔌 API Guidelines

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

## 🔗 관련 문서
- [상세 엔드포인트 명세 (Endpoints)](./endpoints.md)
- [보안 정책 (Security)](../08_security_privacy/security_spec.md)

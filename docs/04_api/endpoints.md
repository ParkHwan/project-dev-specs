# 📡 API Endpoints Spec

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 각 엔드포인트를 상세히 문서화합니다.

---

## 8.6 Endpoints

### `[METHOD] /api/v1/[resource]`

[API 설명]

**Request:**

```json
{
    "field_1": "value",
    "field_2": 123
}
```

| 필드 | 타입 | 필수 | 기본값 | 설명 |
|------|------|:----:|--------|------|
| `field_1` | string | ✅ | - | [설명] |
| `field_2` | integer | ❌ | 10 | [설명] |

**Response (200 OK):**

```json
{
    "data": {
        "id": "xxx",
        "field_1": "value"
    },
    "meta": {
        "request_id": "req_xxx"
    }
}
```

---

## 8.7 Rate Limiting

| 엔드포인트 | 제한 | 윈도우 |
|------------|:----:|--------|
| 기본 | 100 req | 1분 |
| [고비용 API] | 10 req | 1분 |

**Rate Limit 응답 헤더:**

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1706961600
```

---

## 🔗 관련 문서
- [API 가이드라인 (Guidelines)](./api_guidelines.md)
- [기능 요구사항 (Functional)](../01_requirements/functional.md)

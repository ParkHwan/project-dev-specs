# 👁️ Observability & Monitoring

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: Google SRE의 골든 시그널을 기반으로 관측성을 설계합니다.

---

## 골든 시그널 (Four Golden Signals)

| 시그널 | 정의 | 측정 방법 | 알림 기준 |
|--------|------|-----------|-----------|
| **Latency** | 요청 처리 시간 | p50/p95/p99 | p95 > SLO |
| **Traffic** | 요청량 | QPS/TPS | 급격한 변화 |
| **Errors** | 오류율 | 5xx / 전체 | > [X]% |
| **Saturation** | 리소스 포화도 | CPU/Mem/Conn | > 80% |

---

## 로깅 전략

#### 로그 포맷 (구조화 JSON)

```json
{
    "timestamp": "2026-02-03T10:15:30.123Z",
    "level": "INFO",
    "service": "[service_name]",
    "trace_id": "abc123",
    "span_id": "def456",
    "message": "[log message]",
    "context": {
        "[key]": "[value]"
    }
}
```

#### 로그 레벨 가이드

| 레벨 | 용도 | 예시 |
|------|------|------|
| ERROR | 즉시 조치 필요 | DB 연결 실패, 외부 API 오류 |
| WARN | 주의 필요 | 재시도 발생, 임계치 근접 |
| INFO | 정상 운영 기록 | 요청 완료, 작업 완료 |
| DEBUG | 개발/디버깅 | 상세 실행 흐름 |

---

## 메트릭

#### 애플리케이션 메트릭

| 메트릭 명 | 타입 | 라벨 | 설명 |
|-----------|------|------|------|
| `http_requests_total` | Counter | method, path, status | 총 요청 수 |
| `http_request_duration_seconds` | Histogram | method, path | 요청 지연 |
| `memory_recall_latency_seconds` | Histogram | project_id, memory_type | 메모리 검색 지연 |
| `memory_recall_hit_ratio` | Gauge | project_id | 메모리 검색 적중률 |
| `memory_write_total` | Counter | project_id, result | 메모리 저장 건수 |
| `[custom_metric]` | [타입] | [라벨] | [설명] |

#### 인프라 메트릭

| 메트릭 | 소스 | 알림 임계치 |
|--------|------|-------------|
| CPU 사용률 | [소스] | > 80% |
| 메모리 사용률 | [소스] | > 85% |
| 디스크 사용률 | [소스] | > 90% |
| 커넥션 수 | [소스] | > 80% of max |

---

## 분산 추적 (Tracing)

추적 전파 헤더:
- `X-Request-ID`: 클라이언트 → 백엔드
- `traceparent`: W3C Trace Context (OpenTelemetry)

---

## 대시보드 구성

| 대시보드 | 포함 내용 | 대상 |
|----------|-----------|------|
| **Overview** | SLO 현황, 트래픽, 에러율 | 전체 |
| **Performance** | 지연, 처리량 | Backend |
| **Infrastructure** | 리소스 사용량 | SRE |
| **Cost** | 비용 현황 | 관리자 |

---

## 알림 정책

| 심각도 | 조건 | 알림 채널 | 대응 시간 |
|--------|------|-----------|-----------|
| **Critical** | 서비스 다운, SLO 위반 | PagerDuty + Slack | 15분 |
| **Warning** | 임계치 근접, 이상 패턴 | Slack | 1시간 |
| **Info** | 배포 완료, 정기 리포트 | Slack | N/A |

---

## memsearch 운영 지표

| 항목 | 목표 | 알림 기준 |
|------|------|-----------|
| 검색 지연 p95 | ≤ 300ms | p95 > 500ms (15분) |
| 검색 적중률 | ≥ 70% | 60% 미만 1시간 지속 |
| 저장 실패율 | < 0.5% | 1% 초과 10분 지속 |
| 재색인 성공률 | 100% | 실패 즉시 Critical |

---

## 🔗 관련 문서
- [배포 및 릴리즈 (Deployment)](./deployment_release.md)
- [품질 및 비기능 요구사항 (Non-Functional)](../01_requirements/non_functional.md)
- [Agent Long-term Memory (memsearch)](../03_data/memsearch_memory.md)
- [보안 및 프라이버시 (Security)](../08_security_privacy/security_spec.md)

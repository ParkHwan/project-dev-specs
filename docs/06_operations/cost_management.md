# 💰 Cost Management (FinOps)

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 클라우드/인프라 비용을 예측·추적·최적화하는 기준을 정의합니다. 비용은 NFR이자 운영 책임입니다.

---

## 월간 예산 / 리소스별 추정

| 리소스 | 사양 | 월 비용(추정) | 비고 |
|--------|------|--------------:|------|
| Compute | [인스턴스/노드] | [$] | |
| Database | [관리형 DB] | [$] | |
| Storage / Object | [GCS/S3 등] | [$] | |
| Network / Egress | [전송량] | [$] | |
| Vector DB (Milvus) | [노드/스토리지] | [$] | memsearch 백엔드 |
| 기타(LB/Secret/로그) | | [$] | |
| **합계** | | **[$]** | |

---

## 비용 알림 / 임계치

- 월 예산 대비 [50% / 80% / 100%] 도달 시 알림.
- 알림 채널: [Slack/Email] / 수신자: [담당자]
- 이상 급증(anomaly) 감지: [전일 대비 X% 초과 시 알림]

---

## 최적화 전략

- **Right-sizing**: 사용률 기반 인스턴스 조정 [주기].
- **약정/스팟**: [Reserved/Savings Plan/Spot] 적용 대상 워크로드.
- **스토리지 계층화**: 콜드 데이터 [Nearline/Coldline] 전환 주기.
- **비운영 시간 축소**: dev/stage 야간·주말 [중지/축소].
- **로그/메트릭 보존**: 보존 기간 정책으로 관측성 비용 통제(→ [관측성](./observability.md)).

---

## 책임 / 리뷰

- 비용 오너: [담당자] / 리뷰 주기: [월 1회]
- 태깅 정책: 모든 리소스에 `env`, `service`, `owner` 태그 필수(비용 귀속).

---

## 🔗 관련 문서
- [배포 아키텍처](../02_architecture/deployment_arch.md)
- [Infrastructure as Code](./infrastructure_as_code.md)
- [비기능 요구사항](../01_requirements/non_functional.md)

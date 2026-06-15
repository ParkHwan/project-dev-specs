# 🏗️ Infrastructure as Code (IaC)

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 인프라를 코드로 관리하는 도구·구조·운영 규칙을 정의합니다. 수동 콘솔 변경(ClickOps)은 금지를 원칙으로 합니다.

---

## 12b.1 도구 및 범위

| 항목 | 선택 |
|------|------|
| IaC 도구 | [Terraform / Pulumi / OpenTofu 등] |
| 상태(state) 저장소 | [원격 백엔드 — 예: GCS/S3 + 잠금] |
| 관리 대상 | [네트워크/컴퓨트/DB/IAM/시크릿 등] |
| 비관리 대상(예외) | [수동 관리가 불가피한 항목과 사유] |

---

## 12b.2 환경 분리

- 환경: [dev / stage / prod] — 디렉터리 또는 workspace로 분리.
- 환경별 변수: [tfvars / 환경 설정] 로 분리, 시크릿은 코드에 두지 않음(→ [보안](../08_security_privacy/security_spec.md)).

---

## 12b.3 변경 워크플로

```mermaid
flowchart LR
    A[코드 변경 PR] --> B[plan/preview]
    B --> C[리뷰 승인]
    C --> D[apply via CI]
    D --> E[drift 점검]
```

- `plan`/`preview` 결과를 PR에 첨부하여 리뷰.
- `apply`는 CI 파이프라인에서만 실행(로컬 apply 금지).
- **Drift 감지**: [주기]로 실제 상태와 코드 비교, 차이 발생 시 알림.

---

## 12b.4 모듈화 / 재사용

- 공통 리소스는 모듈로 추출하고 버전 고정.
- 네이밍/태깅 규칙은 [비용 태깅 정책](./cost_management.md)과 일치.

---

## 🔗 관련 문서
- [배포 아키텍처](../02_architecture/deployment_arch.md)
- [배포 및 릴리즈](./deployment_release.md)
- [비용 관리 (FinOps)](./cost_management.md)

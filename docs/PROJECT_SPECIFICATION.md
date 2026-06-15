# [PROJECT_NAME] - Project Specification Hub

> ✅ **이 모듈형 `docs/` 트리가 단일 진실 출처(Source of Truth)입니다.**
> `archive/PROJECT_SPECIFICATION.monolith.md`(monolith, deprecated)와
> `archive/PROJECT_SPECIFICATION_EN.md`(영문, stale)는 이 허브에서 파생된 보존본/번역본이며,
> 원본 수정은 항상 이 모듈형 문서에서 진행합니다.

> **Template Version**: 1.1.0 (Modular)  
> **Last Updated**: [YYYY-MM-DD]  
> **Status**: Draft | In Review | Approved  
> **Owner**: [담당자명]

---

## 💡 How to Use This Modular Template

1. **[PROJECT_NAME]** 등 플레이스홀더를 실제 내용으로 대체하세요.
2. 아래 **프로젝트 유형별 필수 섹션**을 확인하고, 해당 하위 문서를 완성하세요.
3. 각 하위 문서의 상단에 있는 `💡 작성 가이드`를 참고하여 내용을 작성합니다.

### 프로젝트 유형별 필수 섹션 매트릭스

| 섹션 | Web App | API/Backend | ML/AI | Data Pipeline | Library | 상세 문서 링크 |
|------|:-------:|:-----------:|:-----:|:-------------:|:-------:|---------------|
| Executive Summary | ✅ | ✅ | ✅ | ✅ | ✅ | [본문 요약](#executive-summary) |
| Problem & Goals | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/problem_and_goals.md](./01_requirements/problem_and_goals.md) |
| Stakeholders | ✅ | ✅ | ✅ | ✅ | ⚪ | [01_requirements/stakeholders.md](./01_requirements/stakeholders.md) |
| Functional Req. | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/functional.md](./01_requirements/functional.md) |
| Non-Functional Req. | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/non_functional.md](./01_requirements/non_functional.md) |
| System Architecture | ✅ | ✅ | ✅ | ✅ | ⚪ | [02_architecture/system_design.md](./02_architecture/system_design.md) |
| Deployment Arch. | ✅ | ✅ | ✅ | ✅ | ⚪ | [02_architecture/deployment_arch.md](./02_architecture/deployment_arch.md) |
| Tech Stack | ✅ | ✅ | ✅ | ✅ | ✅ | [02_architecture/tech_stack.md](./02_architecture/tech_stack.md) |
| Data Model | ✅ | ✅ | ✅ | ✅ | ⚪ | [03_data/data_model.md](./03_data/data_model.md) |
| Data Migration | ✅ | ✅ | ⚪ | ✅ | ⚪ | [03_data/migration_strategy.md](./03_data/migration_strategy.md) |
| Agent Memory (memsearch) | ⚪ | ⚪ | ✅ | ✅ | ⚪ | [03_data/memsearch_memory.md](./03_data/memsearch_memory.md) |
| API Guidelines | ⚪ | ✅ | ⚪ | ⚪ | ✅ | [04_api/api_guidelines.md](./04_api/api_guidelines.md) |
| API Endpoints | ⚪ | ✅ | ⚪ | ⚪ | ✅ | [04_api/endpoints.md](./04_api/endpoints.md) |
| Coding Style | ✅ | ✅ | ✅ | ✅ | ✅ | [05_engineering/coding_style.md](./05_engineering/coding_style.md) |
| Testing Strategy | ✅ | ✅ | ✅ | ✅ | ✅ | [05_engineering/testing_strategy.md](./05_engineering/testing_strategy.md) |
| Observability | ✅ | ✅ | ✅ | ✅ | ⚪ | [06_operations/observability.md](./06_operations/observability.md) |
| Deployment | ✅ | ✅ | ✅ | ✅ | ✅ | [06_operations/deployment_release.md](./06_operations/deployment_release.md) |
| Security & Privacy | ✅ | ✅ | ✅ | ✅ | ⚪ | [08_security_privacy/security_spec.md](./08_security_privacy/security_spec.md) |
| Risk Management | ✅ | ✅ | ✅ | ✅ | ⚪ | [07_risk_roadmap/risk_management.md](./07_risk_roadmap/risk_management.md) |
| Roadmap | ✅ | ✅ | ✅ | ✅ | ✅ | [07_risk_roadmap/roadmap.md](./07_risk_roadmap/roadmap.md) |
| Glossary | ✅ | ✅ | ✅ | ✅ | ✅ | [07_risk_roadmap/glossary.md](./07_risk_roadmap/glossary.md) |
| Appendix / ADR | ✅ | ✅ | ✅ | ✅ | ✅ | [99_appendix/references.md](./99_appendix/references.md) |
| Responsible AI | ⚪ | ⚪ | ✅ | ⚪ | ⚪ | [01_requirements/non_functional.md#책임있는-ai](./01_requirements/non_functional.md#책임있는-ai) |
| UI/UX & Accessibility | ✅ | ⚪ | ⚪ | ⚪ | ⚪ | [09_ux/ui_spec.md](./09_ux/ui_spec.md) |
| Cost / FinOps | ✅ | ✅ | ✅ | ✅ | ⚪ | [06_operations/cost_management.md](./06_operations/cost_management.md) |
| IaC | ✅ | ✅ | ✅ | ✅ | ⚪ | [06_operations/infrastructure_as_code.md](./06_operations/infrastructure_as_code.md) |
| Data Pipeline | ⚪ | ⚪ | ✅ | ✅ | ⚪ | [03_data/pipeline_spec.md](./03_data/pipeline_spec.md) |

✅ 필수 | ⚪ 선택/해당시

---

## Executive Summary

> 💡 **작성 가이드**: 프로젝트의 핵심을 5분 안에 이해할 수 있도록 요약합니다.

### 프로젝트 한 줄 정의
> [TODO] 프로젝트의 핵심 가치를 한 문장으로 정의

### 핵심 가치 제안 (Value Proposition)
| 대상 | 현재 문제 | 제안 솔루션 | 기대 효과 |
|------|-----------|-------------|-----------|
| [사용자 그룹 A] | [문제점] | [솔루션] | [정량적 효과] |

### 프로젝트 범위 (Scope)
- **In-Scope**: [포함 기능/범위]
- **Out-of-Scope**: [제외 기능/범위]
- **Future Scope**: [향후 고려 사항]

### 주요 가정 및 제약사항
| 구분 | 내용 | 영향도 | 비고 |
|------|------|:------:|------|
| **가정** | [가정 사항] | H/M/L | |
| **제약** | [제약 조건] | H/M/L | |

---

## 📜 Revision History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.1.0 | [YYYY-MM-DD] | [작성자] | 단일 파일에서 모듈형 템플릿으로 전환 및 구조 고도화 |

---

## 🔗 Quick Navigation

**01 요구사항**
- [문제 정의 및 목표](./01_requirements/problem_and_goals.md)
- [이해관계자 및 RACI](./01_requirements/stakeholders.md)
- [기능 요구사항](./01_requirements/functional.md)
- [비기능 요구사항](./01_requirements/non_functional.md)

**02 아키텍처**
- [시스템 설계](./02_architecture/system_design.md)
- [배포 아키텍처](./02_architecture/deployment_arch.md)
- [기술 스택](./02_architecture/tech_stack.md)

**03 데이터**
- [데이터 모델](./03_data/data_model.md)
- [마이그레이션 전략](./03_data/migration_strategy.md)
- [데이터 파이프라인](./03_data/pipeline_spec.md)
- [에이전트 장기기억 (memsearch)](./03_data/memsearch_memory.md)

**04 API**
- [API 가이드라인](./04_api/api_guidelines.md)
- [API 엔드포인트](./04_api/endpoints.md)

**05 엔지니어링**
- [코딩 스타일](./05_engineering/coding_style.md)
- [테스트 전략](./05_engineering/testing_strategy.md)

**06 운영**
- [관측성 및 모니터링](./06_operations/observability.md)
- [배포 및 릴리즈](./06_operations/deployment_release.md)
- [비용 관리 (FinOps)](./06_operations/cost_management.md)
- [Infrastructure as Code](./06_operations/infrastructure_as_code.md)

**07 리스크/로드맵**
- [위험 관리](./07_risk_roadmap/risk_management.md)
- [프로젝트 로드맵](./07_risk_roadmap/roadmap.md)
- [용어 사전](./07_risk_roadmap/glossary.md)

**08 보안/프라이버시**
- [보안 및 프라이버시](./08_security_privacy/security_spec.md)

**09 UX**
- [UI/UX 및 접근성](./09_ux/ui_spec.md)

**99 부록**
- [부록 및 결정 기록 (ADR)](./99_appendix/references.md)

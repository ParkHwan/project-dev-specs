# [PROJECT_NAME] - Project Specification Hub

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
| Executive Summary | ✅ | ✅ | ✅ | ✅ | ✅ | [본문 요약](#1-executive-summary) |
| Problem & Goals | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/problem_and_goals.md](./01_requirements/problem_and_goals.md) |
| Stakeholders | ✅ | ✅ | ✅ | ✅ | ⚪ | [01_requirements/stakeholders.md](./01_requirements/stakeholders.md) |
| Functional Req. | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/functional.md](./01_requirements/functional.md) |
| Non-Functional Req. | ✅ | ✅ | ✅ | ✅ | ✅ | [01_requirements/non_functional.md](./01_requirements/non_functional.md) |
| System Architecture | ✅ | ✅ | ✅ | ✅ | ⚪ | [02_architecture/system_design.md](./02_architecture/system_design.md) |
| Data Model | ✅ | ✅ | ✅ | ✅ | ⚪ | [03_data/data_model.md](./03_data/data_model.md) |
| API Specification | ⚪ | ✅ | ⚪ | ⚪ | ✅ | [04_api/api_guidelines.md](./04_api/api_guidelines.md) |
| Security & Privacy | ✅ | ✅ | ✅ | ✅ | ⚪ | [08_security_privacy/security_spec.md](./08_security_privacy/security_spec.md) |
| Testing Strategy | ✅ | ✅ | ✅ | ✅ | ✅ | [05_engineering/testing_strategy.md](./05_engineering/testing_strategy.md) |
| Observability | ✅ | ✅ | ✅ | ✅ | ⚪ | [06_operations/observability.md](./06_operations/observability.md) |
| Deployment | ✅ | ✅ | ✅ | ✅ | ✅ | [06_operations/deployment_release.md](./06_operations/deployment_release.md) |
| Risk Management | ✅ | ✅ | ✅ | ✅ | ⚪ | [07_risk_roadmap/risk_management.md](./07_risk_roadmap/risk_management.md) |
| Responsible AI | ⚪ | ⚪ | ✅ | ⚪ | ⚪ | [01_requirements/non_functional.md#55-책임있는-ai](./01_requirements/non_functional.md#55-책임있는-ai) |

✅ 필수 | ⚪ 선택/해당시

---

## 1. Executive Summary

> 💡 **작성 가이드**: 프로젝트의 핵심을 5분 안에 이해할 수 있도록 요약합니다.

### 1.1 프로젝트 한 줄 정의
> [TODO] 프로젝트의 핵심 가치를 한 문장으로 정의

### 1.2 핵심 가치 제안 (Value Proposition)
| 대상 | 현재 문제 | 제안 솔루션 | 기대 효과 |
|------|-----------|-------------|-----------|
| [사용자 그룹 A] | [문제점] | [솔루션] | [정량적 효과] |

### 1.3 프로젝트 범위 (Scope)
- **In-Scope**: [포함 기능/범위]
- **Out-of-Scope**: [제외 기능/범위]
- **Future Scope**: [향후 고려 사항]

### 1.4 주요 가정 및 제약사항
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
- [요구사항 및 목표 (Requirements)](./01_requirements/problem_and_goals.md)
- [시스템 설계 (Architecture)](./02_architecture/system_design.md)
- [데이터 명세 (Data Model)](./03_data/data_model.md)
- [API 명세 (API Spec)](./04_api/api_guidelines.md)
- [보안 및 프라이버시 (Security)](./08_security_privacy/security_spec.md)
- [부록 및 결정 기록 (Appendix)](./99_appendix/references.md)

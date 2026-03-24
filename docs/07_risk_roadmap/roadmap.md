# 📅 Roadmap & Milestones

> 💡 **작성 가이드**: 프로젝트 일정과 마일스톤을 정의합니다.

---

## 14.1 전체 로드맵

```mermaid
gantt
    title Project Roadmap
    dateFormat YYYY-MM-DD
    section Phase 1 - MVP
        요구사항 분석      :done, req, 2026-02-01, 2w
        아키텍처 설계      :done, arch, after req, 1w
        핵심 기능 개발     :active, dev1, after arch, 4w
        테스트 및 QA       :test1, after dev1, 2w
        MVP 출시           :milestone, m1, after test1, 0d
    section Phase 2 - v1.0
        추가 기능 개발     :dev2, after m1, 4w
        성능 최적화        :perf, after dev2, 2w
        v1.0 출시          :milestone, m2, after perf, 0d
```

---

## 14.2 마일스톤 상세

#### Milestone 1: [마일스톤 명] (목표일: [YYYY-MM-DD])

| Phase | Task | Owner | 상태 |
|:-----:|------|-------|:----:|
| 1 | [태스크 1] | [담당] | ⚪/🔵/🟢/✅ |
| 2 | [태스크 2] | [담당] | ⚪/🔵/🟢/✅ |
| 3 | [태스크 3] | [담당] | ⚪/🔵/🟢/✅ |

> 상태: ⚪ Not Started | 🔵 Planning | 🟢 In Progress | ✅ Done

**완료 기준 (Definition of Done):**
- [ ] [기준 1]
- [ ] [기준 2]
- [ ] [기준 3]

---

## 14.3 의존관계 다이어그램

```mermaid
flowchart TD
    A["인프라 구축"] --> B["DB 스키마 설계"]
    A --> C["CI/CD 파이프라인"]
    
    B --> D["API 개발"]
    C --> D
    
    D --> E["프론트엔드 개발"]
    D --> F["테스트 자동화"]
    
    E --> G["통합 테스트"]
    F --> G
    
    G --> H["MVP 출시"]
    
    style A fill:#e1f5fe
    style H fill:#c8e6c9
```

---

## 🔗 관련 문서
- [위험 관리 (Risk Management)](./risk_management.md)
- [용어 사전 (Glossary)](./glossary.md)

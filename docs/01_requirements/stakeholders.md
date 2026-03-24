# 🤝 Stakeholders & RACI

> 💡 **작성 가이드**: 프로젝트 관련 모든 이해관계자와 책임을 명확히 합니다.

---

## 3.1 이해관계자 맵

| 역할 | 담당자 | 책임 범위 | 연락처 |
|------|--------|-----------|--------|
| **Product Owner** | [이름] | 요구사항 정의, 우선순위 결정 | [이메일] |
| **Tech Lead** | [이름] | 기술 의사결정, 아키텍처 설계 | [이메일] |
| **Developer** | [이름] | 개발 및 구현 | [이메일] |
| **Designer** | [이름] | UI/UX 설계 | [이메일] |
| **QA** | [이름] | 테스트 전략/실행 | [이메일] |
| **SRE/DevOps** | [이름] | 인프라/배포/모니터링 | [이메일] |
| **Sponsor** | [이름] | 예산/리소스 승인 | [이메일] |

---

## 3.2 RACI Matrix

> R: Responsible (실행) | A: Accountable (최종책임) | C: Consulted (자문) | I: Informed (통보)

| 활동 | PO | Tech Lead | Dev | QA | SRE |
|------|:--:|:---------:|:---:|:--:|:---:|
| 요구사항 정의 | A | C | I | C | I |
| 아키텍처 설계 | C | A | R | I | C |
| 개발 | I | A | R | C | I |
| 코드 리뷰 | I | A | R | I | I |
| 테스트 | C | C | R | A | I |
| 배포 | I | A | C | C | R |
| 운영/모니터링 | I | C | C | I | A |
| 장애 대응 | I | A | R | I | R |

---

## 3.3 커뮤니케이션 계획

| 회의/채널 | 목적 | 참석자 | 주기 | 산출물 |
|-----------|------|--------|------|--------|
| Daily Standup | 진행 상황 공유 | 개발팀 | 매일 | N/A |
| Sprint Planning | 스프린트 계획 | 전체 | 격주 | Sprint Backlog |
| Sprint Review | 결과 데모 | 전체 + Stakeholder | 격주 | Demo |
| Retrospective | 회고 | 개발팀 | 격주 | Action Items |
| Technical Review | 기술 결정 | Tech Lead + Dev | 필요시 | ADR |

---

## 🔗 관련 문서
- [문제 정의 및 목표](./problem_and_goals.md)
- [기능 요구사항 (Functional)](./functional.md)

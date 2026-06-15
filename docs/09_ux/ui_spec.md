# 🎨 UI/UX & Accessibility Spec

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: Web App 유형 프로젝트의 화면/상호작용/접근성 기준을 정의합니다. (API/Library 유형은 생략 가능)

---

## 디자인 시스템

| 항목 | 내용 |
|------|------|
| 디자인 토큰 | [색상/타이포/spacing 출처 — 예: Figma 라이브러리 링크] |
| 컴포넌트 라이브러리 | [예: 자체 DS / MUI / shadcn 등] |
| 아이콘/이미지 | [출처 및 라이선스] |
| 다크모드/테마 | [지원 여부 및 토큰 전략] |

---

## 화면 / 플로우

- **주요 화면 목록**: [화면명 + 목적]
- **와이어프레임/프로토타입**: [Figma 등 링크]
- **핵심 사용자 플로우**: [진입 → 행동 → 완료 경로]

---

## 반응형 / 브레이크포인트

| 구간 | 폭 | 레이아웃 |
|------|----|---------|
| Mobile | < 768px | [단일 컬럼 등] |
| Tablet | 768–1024px | [...] |
| Desktop | > 1024px | [...] |

---

## 접근성 (WCAG 2.1 AA 기준)

- [ ] 키보드만으로 모든 기능 사용 가능 (focus 순서/visible focus)
- [ ] 색 대비 4.5:1 이상 (본문 텍스트)
- [ ] 이미지 `alt`, 폼 `label`, 랜드마크/heading 구조
- [ ] 스크린리더 검증 (VoiceOver/NVDA 중 [택1])
- [ ] 동작 감소(prefers-reduced-motion) 대응
- [ ] 다국어/RTL 필요 시 [i18n 문서로 분리]

---

## 성능 / 품질 기준 (프론트)

- Core Web Vitals 목표: LCP [≤2.5s], INP [≤200ms], CLS [≤0.1]
- 번들 예산: 초기 JS [≤ KB], 이미지 최적화 정책

---

## 🔗 관련 문서
- [기능 요구사항](../01_requirements/functional.md)
- [비기능 요구사항](../01_requirements/non_functional.md)
- [관측성 (RUM)](../06_operations/observability.md)

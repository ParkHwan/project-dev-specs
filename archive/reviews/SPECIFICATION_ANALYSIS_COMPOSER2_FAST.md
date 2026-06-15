# 개발 명세서 종합 분석·평가 및 개선 권고

> **대상 저장소**: `docs/` 모듈형 프로젝트 명세 템플릿 (Template Version 1.1.0)  
> **분석 일자**: 2026-03-24  
> **검토 범위**: `docs/` 이하 마크다운 문서 전부 (반복 검토 2회)

---

## 1. 검토 대상 문서 인벤토리 (누락 없음 확인)

다음 **20개** 파일을 모두 열람·분석하였다.

| 구분 | 경로 |
|------|------|
| 허브 | `PROJECT_SPECIFICATION.md` |
| 요구사항 | `01_requirements/problem_and_goals.md`, `stakeholders.md`, `functional.md`, `non_functional.md` |
| 아키텍처 | `02_architecture/system_design.md`, `tech_stack.md`, `deployment_arch.md` |
| 데이터 | `03_data/data_model.md`, `migration_strategy.md` |
| API | `04_api/api_guidelines.md`, `endpoints.md` |
| 엔지니어링 | `05_engineering/testing_strategy.md`, `coding_style.md` |
| 운영 | `06_operations/deployment_release.md`, `observability.md` |
| 리스크·로드맵 | `07_risk_roadmap/risk_management.md`, `roadmap.md`, `glossary.md` |
| 보안 | `08_security_privacy/security_spec.md` |
| 부록 | `99_appendix/references.md` |

**참고**: 사용자 안내에 있던 `docs/PROJECT_SPECIFICATION_EN.md`는 **현재 워크트리에 존재하지 않았다**. 영문 허브가 필요하면 추가하거나, 허브에서 경로를 제거·동기화하는 것이 좋다.

---

## 2. 구조·내비게이션 평가

### 2.1 강점

- **계층 분리**: 요구사항 → 아키텍처 → 데이터 → API → 엔지니어링 → 운영 → 리스크 순으로 읽기 좋다.
- **교차 링크**: 대부분의 하위 문서 하단에「관련 문서」가 있어 탐색이 가능하다.
- **허브 매트릭스**: 프로젝트 유형(Web, API, ML, 파이프라인 등)별 필수 섹션을 한눈에 볼 수 있다.
- **시각 자료**: Mermaid 기반 아키텍처·시퀀스·ERD·가트·카나리 플로우 등이 있어 온보딩에 유리하다.

### 2.2 허브와 실제 파일의 정합성

`PROJECT_SPECIFICATION.md`의 매트릭스·Quick Navigation에는 **일부 문서가 직접 노출되지 않는다**.

- 매트릭스에 **명시되지 않았으나 존재하는 문서**: `tech_stack.md`, `deployment_arch.md`, `migration_strategy.md`, `endpoints.md`, `coding_style.md`, `roadmap.md`, `glossary.md`
- **개선 권고**: 허브의 표 또는 Quick Navigation에 위 문서를 추가하고, `04_api`는「가이드라인 + 엔드포인트」를 함께 안내하는 편이 일관적이다.

---

## 3. 문서별 내용 요약 (반영 확인용)

| 문서 | 역할 | 현재 상태 요약 |
|------|------|----------------|
| `PROJECT_SPECIFICATION.md` | 진입점·매트릭스·Executive Summary 자리 | 플레이스홀더·TODO 중심 |
| `problem_and_goals.md` | As-Is/To-Be, OKR, KPI | 템플릿·예시 블록 위주 |
| `stakeholders.md` | 이해관계자·RACI·커뮤니케이션 | 역할 표는 채워진 예시, 담당자는 플레이스홀더 |
| `functional.md` | Epic·User Story·Feature Matrix | EP/US 구조만 있고 본문은 미작성 |
| `non_functional.md` | 품질·SLO·성능 예산·책임 있는 AI | 루브릭·SLO 표 형태는 우수, 수치·서비스명은 플레이스홀더 |
| `system_design.md` | C4 스타일 다이어그램 | 범용 백엔드 구조로 잘 정리됨 |
| `tech_stack.md` | 기술 스택 표 | 전 항목 플레이스홀더 |
| `deployment_arch.md` | 클라우드·옵션 K8s | AWS/GCP 혼합적 예시(용어), 다이어그램은 참고용으로 적합 |
| `data_model.md` | ERD·DDL·라이프사이클 | **이커머스 샘플**(USER/ORDER 등)이 구체적으로 들어가 있어, 범용 템플릿과 혼재 |
| `migration_strategy.md` | 마이그레이션 정책 | 매우 짧음, 도구·롤백 등 불릿만 |
| `api_guidelines.md` | 설계 원칙·에러 모델·Base URL | 실무에 가까운 수준의 골격 |
| `endpoints.md` | 개별 API | 단일 템플릿 블록만 존재 |
| `testing_strategy.md` | 피라미드·품질 게이트·부하 시나리오 | 구조 양호, 도구명은 플레이스홀더 |
| `coding_style.md` | 네이밍·Git·로컬 환경 | **함수/변수 camelCase** 예시는 Python 관례와 충돌 가능 |
| `deployment_release.md` | 카나리·롤백·CI/CD·공급망·DB 마이그레이션 | 내용 밀도 높음 |
| `observability.md` | 골든 시그널·로그·메트릭·트레이싱·알림 | 실무 지향 |
| `security_spec.md` | STRIDE·인증·데이터 분류·마스킹 | 체크리스트·표는 좋으나 세부는 플레이스홀더 |
| `risk_management.md` | 리스크 등록부·매트릭스·비상 계획 | Mermaid quadrant 사용 |
| `roadmap.md` | 가트·마일스톤·의존 관계 | 예시 일정(2026) 포함 |
| `glossary.md` | 용어·약어 | 대부분 플레이스홀더 |
| `references.md` | ADR 템플릿·외부 링크·Mermaid 가이드 | `adr/` 폴더는 **문서에만 언급되고 저장소에 없음** |

**2차 검토**: 위 표가 본 워크트리의 `docs/**/*.md` 전부를 포함하는지 재확인하였다. (누락 없음)

---

## 4. 종합 평가

### 4.1 적합한 용도

- **신규 프로젝트 킥오프** 시 채워 넣을 **모듈형 명세 골격**으로 매우 적합하다.
- SRE·보안·API 가이드·관측성·배포 등 **운영 품질 관점**이 초기부터 반영되어 있다.
- 팀 간 합의 산출물(특히 NFR, SLO, 보안, 릴리즈)을 **문서 단위로 분리**한 점은 유지보수에 유리하다.

### 4.2 한계 (현재 상태 기준)

- 대부분 **프로젝트 특정 정보가 비어 있거나 TODO**이므로, 그대로는「완성된 개발 명세」라기보다 **고품질 템플릿**에 가깝다.
- **도메인 예시 불일치**: `data_model.md`만 이커머스 도메인이 구체화되어 있어, 다른 문서의 추상적 플레이스홀더와 톤이 어긋난다.
- **섹션 번호 중복**: `deployment_arch.md`와 `tech_stack.md`에 **둘 다 `6.5`**가 있어, 문서 간 참조 시 혼동 여지가 있다. (`system_design`은 6.1~6.3)
- **용어**: `non_functional.md`의「에러버짓 **번레이트**」는 일반적으로 **burn rate**(소진율) 표기가 맞다.

---

## 5. 개선 권고 사항 (우선순위 순)

### P0 — 구조·일관성

1. **허브(`PROJECT_SPECIFICATION.md`) 보강**: 존재하는 모든 하위 문서를 매트릭스 또는 Quick Navigation에 링크한다. (`endpoints`, `migration_strategy`, `tech_stack`, `deployment_arch`, `coding_style`, `roadmap`, `glossary`)
2. **섹션 번호 정리**: `02_architecture` 내 `6.4` / `6.5` / `6.6` 등으로 **중복 없이 재번호**하거나, 파일별로 독립 번호 체계(예: 문서 로컬 번호만 사용)를 택한다.
3. **`data_model.md` 정렬**: (A) 완전 범용 템플릿으로 되돌리거나, (B) 샘플임을 상단에 명시하고 **실제 프로젝트 ERD로 교체**한다. 다른 문서 도메인과 맞출 것.

### P1 — 실무 완성도

4. **`migration_strategy.md` 확장**: 스키마 버저닝, expand/contract, 다운타임 윈도, 롤백·재처리, 데이터 검증·샘플링, 드라이런 체크리스트를 표준 절로 보강한다.
5. **`endpoints.md`**: 리소스별로 섹션을 나누고, OpenAPI/Swagger **단일 소스**와의 관계(자동 생성 여부)를 `references.md`와 연계한다.
6. **`PROJECT_SPECIFICATION_EN.md`**: 영문 허브가 필요하면 **한글 허브와 동기화된 영문본**을 추가하고, 상호 링크를 넣는다.

### P2 — 팀 표준·도구

7. **`coding_style.md`**: 언어별 서브섹션(예: Python은 snake_case, TypeScript는 camelCase 등)으로 **분리**하거나,「팀 표준 언어」를 먼저 고정한다.
8. **`99_appendix/adr/`**: `references.md`에서 권장한 ADR 폴더를 생성하고, `ADR-000-template.md`를 두어 **첫 ADR부터 누적**되게 한다.
9. **Mermaid 렌더링**: `quadrantChart` 등은 뷰어에 따라 미지원일 수 있으니, README 또는 부록에 **권장 미리보기 환경**(예: GitHub, 특정 VS Code 확장)을 한 줄 명시한다.

### P3 — 거버넌스

10. **Revision History**: 허브의 버전·날짜·작성자 플레이스홀더를 실제 값으로 바꾸고, **주요 문서 변경 시** 부록 또는 허브에 요약을 남긴다.
11. **보안·컴플라이언스**: `security_spec.md`의 OWASP/SDL/GDPR 체크를 실제 적용 범위에 맞게 채우고, **DPIA/데이터 처리 위치**가 필요하면 별도 소절을 추가한다.

---

## 6. 결론

현재 `docs/`는 **범위가 넓고 품질 루브릭·운영·보안까지 포괄하는 모듈형 명세 템플릿**으로 평가된다. 다만 **프로젝트 고유 내용 채움**, **허브–전체 문서 링크 정합성**, **섹션 번호·도메인 예시 일관성**, **영문 허브 유무 정리**를 진행하면, 실제 개발·감사·온보딩에 바로 쓰이는 **완성도 높은 명세 패키지**로 발전시킬 수 있다.

---

## 부록: 본 보고서의 검토 절차

1. `docs/**/*.md` 전체 목록 수집 후 20개 파일 전부 정독  
2. 허브 매트릭스·Quick Navigation과 실제 파일 목록 대조  
3. 문서 간 링크·섹션 번호·도메인 예시 충돌 점검  
4. 위 1~3을 바탕으로 표·권고안을 재검토하여 누락 여부 확인  

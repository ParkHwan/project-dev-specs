# 💻 Coding Style & Guidelines

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 프로젝트의 일관성을 위한 코드 스타일 및 컨벤션을 정의합니다. **언어별 관례를 우선**하며, 팀 표준 언어를 먼저 고정한 뒤 해당 섹션만 적용합니다.

> **팀 표준 언어**: [예: Python(백엔드) + TypeScript(프론트)] — 사용하지 않는 언어 섹션은 삭제하세요.

---

## 공통 원칙

- **Clean Code**: SOLID, KISS, DRY 원칙을 준수합니다.
- **Naming**: 의도가 명확히 드러나는 이름을 씁니다. (의미 불분명한 약어 지양)
- **Comments**: '무엇'보다 '왜'를 설명합니다. 코드로 표현 가능한 것은 주석 대신 코드로.
- **Formatter/Linter 강제**: 스타일은 사람 리뷰가 아니라 도구로 강제합니다(아래 표).

---

## 언어별 네이밍 규칙

> ⚠️ 네이밍은 **각 언어의 공식 관례를 따릅니다.** 언어 간 공통 규칙으로 강제하지 않습니다.

### Python (PEP 8)
| 대상 | 규칙 | 예시 |
|------|------|------|
| Class / Type | PascalCase | `UserService`, `OrderResponse` |
| Function / Method | snake_case | `get_user_by_id()`, `calculate_total()` |
| Variable | snake_case | `user_name`, `order_count` |
| Constant | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Module / File | snake_case | `data_loader.py` |

### TypeScript / JavaScript
| 대상 | 규칙 | 예시 |
|------|------|------|
| Class / Type / Interface | PascalCase | `UserService`, `UserResponse` |
| Function / Method | camelCase | `getUserById()`, `calculateTotal()` |
| Variable | camelCase | `userName`, `orderCount` |
| Constant | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| File | kebab-case | `user-controller.ts` |

### Go
| 대상 | 규칙 | 예시 |
|------|------|------|
| Exported | PascalCase | `UserService`, `Calculate()` |
| unexported | camelCase | `userName`, `calculate()` |
| Constant | PascalCase / UPPER_SNAKE | `MaxRetry`, `DEFAULT_PORT` |
| File | snake_case | `user_service.go` |

---

## 도구 표준 (언어별)

| 언어 | Formatter | Linter | Type Check |
|------|-----------|--------|------------|
| Python | [Black / Ruff format] | [Ruff] | [mypy / pyright] |
| TS/JS | [Prettier] | [ESLint] | [tsc] |
| Go | [gofmt] | [golangci-lint] | (내장) |

---

## Import 순서 / 에러 핸들링

- **Import 순서**: 표준 라이브러리 → 서드파티 → 내부 모듈 (그룹 간 빈 줄). 도구 자동 정렬(isort/Ruff/eslint-plugin-import) 사용.
- **에러 핸들링**: 예외는 의미 있는 타입으로 던지고 삼키지 않는다(로그+재던지기 또는 명시적 처리). 사용자 노출 메시지와 내부 로그를 분리한다(→ [API 에러 모델](../04_api/api_guidelines.md)).

---

## Git Workflow & Commit

- **Branch Strategy**: `main`(Production), `develop`(Staging), `feature/*`(Feature)
- **Commit Format**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- **PR 규칙**: Story 또는 API 계약 단위로 분리. 리뷰 승인 + CI 통과 필수.

### 코드 리뷰 체크리스트
- [ ] 스펙/Acceptance Criteria 충족
- [ ] 테스트 추가/통과 (→ [테스트 전략](./testing_strategy.md))
- [ ] 에러 처리·로깅·관측성 반영
- [ ] 보안/시크릿 노출 없음
- [ ] 네이밍/포맷 도구 통과

---

## 개발 환경 설정 (Local Setup)

- **Node.js**: [v20.x 이상]
- **Python**: [v3.11 이상]
- **Docker**: Local DB 실행 시 필수
- **사전 커밋 훅**: [pre-commit / husky] 로 formatter·linter·secret-scan 강제

---

## 🔗 관련 문서
- [테스트 전략 (Testing)](./testing_strategy.md)
- [API 가이드라인 (API)](../04_api/api_guidelines.md)
- [배포 및 릴리즈 (Deployment)](../06_operations/deployment_release.md)

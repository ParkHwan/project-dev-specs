# 💻 Coding Style & Guidelines

> 💡 **작성 가이드**: 프로젝트의 일관성을 위한 코드 스타일 및 컨벤션을 정의합니다.

---

## 5.6 언어 및 프레임워크별 컨벤션

### 공통 원칙
- **Clean Code**: SOLID 원칙 및 KISS 원칙을 준수합니다.
- **Naming**: 변수/함수명은 의도가 명확하게 드러나도록 네이밍합니다. (길더라도 의미가 불분명한 약어는 지양)
- **Comments**: '무엇'을 하는지보다 '왜' 그렇게 했는지를 설명하는 주석을 작성합니다.

### Naming Rule
| 대상 | 규칙 | 예시 |
|------|------|------|
| Class / Types | PascalCase | `UserService`, `UserResponse` |
| Functions / Methods | camelCase | `getUserById()`, `calculateTotal()` |
| Variables | camelCase | `userName`, `orderCount` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT`, `DEFAULT_PAGE_SIZE` |
| Files | kebab-case / snake_case | `user-controller.ts`, `data_loader.py` |

### Git Workflow & Commit
- **Branch Strategy**: `main` (Production), `develop` (Staging), `feature/*` (Feature)
- **Commit Format**: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`

---

## 5.7 개발 환경 설정 (Local Setup)

- **Node.js**: v20.x 이상
- **Python**: v3.11 이상
- **Docker**: Local DB 실행 시 필수
- **Linting & Formatting**: [ESLint/Prettier/Ruff 등] 적용 필수

---

## 🔗 관련 문서
- [테스트 전략 (Testing)](./testing_strategy.md)
- [배포 및 릴리즈 (Deployment)](../06_operations/deployment_release.md)

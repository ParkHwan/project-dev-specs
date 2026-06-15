# 🛡️ Security & Privacy

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: Microsoft SDL(Security Development Lifecycle) 원칙을 적용합니다.

---

## 보안 프레임워크
본 프로젝트는 OWASP Top 10, Microsoft SDL, 적용 규제를 준수한다(아래 절).
각 항목은 "적용 통제 + 검증 위치"까지 채워야 한다(체크박스만으로는 미완성).

### OWASP Top 10 (2021) 대응

| # | 항목 | 적용 통제 | 검증 |
|---|------|-----------|------|
| A01 | Broken Access Control | RBAC/ABAC, 서버측 권한 검사, 객체 소유권 확인 (→ 인증/인가) | 통합/권한 테스트, 코드리뷰 |
| A02 | Cryptographic Failures | 전송 TLS1.2+, 저장 암호화, KMS 키관리 (→ 데이터 보호) | 구성 점검, SAST |
| A03 | Injection | 파라미터 바인딩/ORM, 입력 검증, 출력 인코딩 | SAST, DAST |
| A04 | Insecure Design | 위협 모델링(STRIDE, → 위협 모델), 보안 설계 리뷰 | 설계 리뷰 게이트 |
| A05 | Security Misconfiguration | 시크릿 분리(→ 데이터 보호), 최소 권한, 기본값 강화, 헤더(HSTS/CSP) | IaC 스캔, 구성 점검 |
| A06 | Vulnerable & Outdated Components | 의존성 고정·스캔, SBOM, EOL 추적 (→ tech_stack 버전 정책) | Dependency Scanner(보안 검사 도구) |
| A07 | Identification & Auth Failures | 강력한 인증, MFA, 세션/토큰 만료, 무차별 대입 방어 (→ 인증/인가) | 인증 테스트 |
| A08 | Software & Data Integrity Failures | 이미지 서명, 공급망 검증, CI 무결성 (→ deployment_release) | Container/Secret 스캔 |
| A09 | Logging & Monitoring Failures | 보안 이벤트 로깅, 마스킹(→ 로그 민감정보 마스킹), 알림 (→ observability) | 로그/알림 점검 |
| A10 | SSRF | 아웃바운드 allowlist, 메타데이터 endpoint 차단, URL 검증 | DAST, 코드리뷰 |

### Microsoft SDL 단계별 체크

- [ ] **요구사항**: 보안/프라이버시 요구사항을 NFR로 등록 (→ non_functional)
- [ ] **설계**: 위협 모델링(STRIDE) 수행 및 공격 표면 분석 (→ 위협 모델)
- [ ] **구현**: 보안 코딩 표준(→ coding_style), SAST/Secret 스캔 통과 (→ 보안 검사 도구)
- [ ] **검증**: DAST/의존성 스캔, 필요 시 침투 테스트
- [ ] **릴리스**: 최종 보안 리뷰, 인시던트 대응 계획(→ risk_management)
- [ ] **대응**: 취약점 제보 창구·패치 SLA 정의

### 규제 / 컴플라이언스

| 규제 | 적용 | 핵심 의무 |
|------|:----:|-----------|
| 개인정보보호법(PIPA, KR) | [ ] | 수집·이용 동의, 보유·파기, 안전성 확보조치 |
| GDPR (EU) | [ ] | 정보주체 권리(열람/삭제/이동), 처리 근거, DPO |
| 기타([HIPAA/PCI-DSS 등]) | [ ] | [해당 의무] |

- **DPIA(개인정보 영향평가)**: 민감정보/대규모 처리 시 수행 여부 명시 → [필요/불필요].
- **데이터 처리 위치/국외이전**: 저장 리전 및 국외이전 동의 여부 → [내용].
- **정보주체 권리 대응**: 열람/정정/삭제/이동 요청 처리 절차 → [절차/SLA].
- 보존·파기 기준은 데이터 분류 및 [data_model 라이프사이클](../03_data/data_model.md#데이터-라이프사이클)을 따른다.

---

## 위협 모델 (STRIDE)

| 위협 유형 | 대상 영역 | 위협 시나리오 | 완화 방안 |
|-----------|-----------|---------------|-----------|
| **S**poofing | 인증 | [시나리오] | [완화책] |
| **T**ampering | API | [시나리오] | [완화책] |
| **R**epudiation | 감사 | [시나리오] | [완화책] |
| **I**nfo Disclosure | 데이터 | [시나리오] | [완화책] |
| **D**oS | 서버 | [시나리오] | [완화책] |
| **E**levation | 권한 | [시나리오] | [완화책] |

---

## 인증/인가
- **인증 방식**: [OAuth 2.0, JWT, 등]
- **토큰 만료**: Access: [X]시간, Refresh: [X]일
- **권한 모델**: [RBAC / ABAC]
- **MFA**: [지원 여부]

---

## 데이터 보호
- **전송 암호화**: TLS 1.2+ 필수
- **저장 암호화**: [암호화 방식]
- **키 관리**: [KMS 서비스]
- **시크릿 관리**: [Secret Manager]

---

## 보안 검사 도구
| 도구 | 용도 | 실행 시점 |
|------|------|-----------|
| [SAST 도구] | 정적 분석 | Pre-commit, CI |
| [Dependency Scanner] | 종속성 취약점 | Daily, PR |
| [Container Scanner] | 이미지 스캔 | Build |
| [Secret Scanner] | 시크릿 유출 | Pre-commit |

---

## 데이터 분류 및 프라이버시

| 분류 | 정의 | 예시 | 보존 기간 | 접근 권한 |
|------|------|------|-----------|-----------|
| **Public** | 공개 가능 | [예시] | 영구 | 전체 |
| **Internal** | 사내 공유 | [예시] | [기간] | 팀원 |
| **Confidential** | 제한 공유 | [예시] | [기간] | 담당자 |
| **Restricted** | 엄격 제한 | [예시] | 최소 | 시스템 |

---

## 로그 민감정보 마스킹
마스킹 대상:
- [ ] 이메일 주소
- [ ] 전화번호
- [ ] API 키/토큰
- [ ] 비밀번호
- [ ] 개인식별정보 (PII)

---

## Agent Memory 보안 (memsearch)

- 저장 전 민감정보 필터링:
- [ ] 이메일/전화번호/주민번호 패턴 마스킹
- [ ] 액세스 토큰/시크릿/API 키 제거
- [ ] 원문 프롬프트 내 PII 치환
- 접근 정책:
- 프로젝트 네임스페이스 단위 격리
- 읽기/쓰기 권한 분리(최소권한 원칙)
- 감사:
- 메모리 read/write/delete 이벤트 감사 로그 보관

---

## 🔗 관련 문서
- [API 가이드라인](../04_api/api_guidelines.md)
- [데이터 라이프사이클](../03_data/data_model.md#데이터-라이프사이클)
- [Agent Long-term Memory (memsearch)](../03_data/memsearch_memory.md)
- [관측성 (Observability)](../06_operations/observability.md)
- [위험 관리 (Risk)](../07_risk_roadmap/risk_management.md)
- [Infrastructure as Code](../06_operations/infrastructure_as_code.md)
- [API 엔드포인트 (Endpoints)](../04_api/endpoints.md)

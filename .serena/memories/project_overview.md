# project-dev-specs — 프로젝트 상태 (단일 출처)

> 이 파일이 프로젝트 상태의 단일 출처(Source of Truth)다. 세션 시작 시 먼저 읽고, 변화가 생기면 갱신한다.

## 목적
다양한 개발 프로젝트(Web/API/ML·AI/Data Pipeline/Library)에 재사용할 **공통 개발 명세서 템플릿 + 에이전트 실행 체계**를 정교화한다. 산업 표준(Google PRD/SRE, Microsoft SDL, OWASP, C4, AWS Well-Architected) 기반.

## 원격 저장소
- GitHub: https://github.com/ParkHwan/project-dev-specs (worktree를 여기서 가져감)

## 구조 — 레이아웃 B (평탄화 완료)
repo 루트 직속 배치:
- **SoT = `docs/`** (01_requirements ~ 09_ux, 99_appendix). 모든 내용 수정은 여기서 시작.
- 실행 레이어: `skill.md`(executor) + `BUILD_SPEC_TEMPLATE.md`(Build-Ready 게이트) + `skills/`(26 스킬 + `skill_graph.yaml/.md` DAG).
- `archive/`: `PROJECT_SPECIFICATION.monolith.md`(1세대, deprecated), `PROJECT_SPECIFICATION_EN.md`(영문, stale), `reviews/`(LLM 분석본 4종).
- 차별점: `docs/03_data/memsearch_memory.md` — 에이전트 장기기억(memsearch/Milvus) 정책.

## 경로 규약
- 스킬·그래프·템플릿의 문서 참조는 **repo 루트 상대경로** (`docs/...`, `BUILD_SPEC_TEMPLATE.md`). `Project_Specification_Enhancement/` 접두어는 전부 제거됨.
- docs 내부 문서 간 링크는 상대(`./`, `../`).

## 완료된 작업
- P0~P2(2026-06-15): SoT 배너, 경로 통일, 허브 Quick Nav/매트릭스, 섹션번호 충돌 해소(tech_stack 6.6), 플레이스홀더 표준규칙, 빈약문서 4종 보강+ADR 템플릿, OpenAPI 정책, 신규문서 4종(ui_spec/cost_management/iac/pipeline_spec)+스킬/그래프 반영, 한/영 동기화 정책.
- 레이아웃 B 평탄화: 스킬 레이어를 repo 루트로 이동, `docs/` 루트 직속화, 경로 28곳 재정렬, monolith/EN/분석본 `archive/`로, MAC 복구보고서는 repo 밖 `/Users/parkhwan/개인/`로 분리(무결, 명세와 무관).

## 완료(이관/베이스라인)
- git 베이스라인: origin을 project-dev-specs로 재지정, .gitignore 추가, .serena/memories 포함 커밋, 원격 초기커밋 병합(README는 사용자본 채택) 후 main push 동기화.
- README 보강: SoT/레이아웃/경로 규약/Build-Ready 사용법/스킬 실행순서/문서 색인 추가.
- 메타데이터 헤더: 도메인 문서 25개 H1 아래 `Last Updated | Status | Owner` 추가(허브·ADR 템플릿 제외).
- endpoints.md 확장: 리소스별 양식+예시(Users), 공통규약(페이지네이션/멱등성), OpenAPI 동반문서 위치 명시. 섹션 8 번호 정렬(guidelines 8.1~8.6 / endpoints 8.7~8.9).
- security_spec 9.1 실제화: 9.1.1 OWASP Top10(2021) 대응표, 9.1.2 SDL 단계 체크, 9.1.3 규제(PIPA/GDPR)+DPIA. 9.2~9.8 유지.
- resilience 패턴: api_guidelines 재시도/타임아웃/서킷브레이커/멱등성/벌크헤드.
- 섹션 비번호화: docs 전체 헤딩 121개 번호 접두어 제거(설명형 헤딩), 앵커 5개·본문 숫자참조 16곳 수정, 번호 안내문 제거. 번호 충돌 근본 원인 해소. (archive/monolith는 보존용이라 번호 유지)
- 양방향 상호참조: 강결합 짝 10개 대칭화(api_guidelines↔coding_style, deployment_arch↔cost/IaC, data_model↔pipeline/security, security_spec↔observability/risk/IaC/endpoints 등). 허브/상위/sink로의 역링크는 제외.

## 컨벤션 추가
- 헤딩에 글로벌 섹션번호를 다시 붙이지 않는다(설명형 헤딩 유지). 문서 간 참조는 번호가 아니라 섹션명/파일 링크로 한다.

## 에이전트 자율개발 운영 모델 (R&D, 반영 완료)
- 구상: hermes-agent(NousResearch) 실행 + ralph loop 반복 + memsearch 기억으로, 명세를 입력으로 설계→개발→검증→테스트→배포를 **반자율** 수행, 사람 감독.
- 3자 검토(나/Codex/Gemini) 수렴 결론: "완전 자율" 아닌 **객관 게이트 기반 반자율**.
- 핵심 규칙: 완료는 CI/테스트로 객관판정(자기판단 금지)·테스트디렉터리 쓰기잠금(Locker), 생성자≠검증자(Codex 생성/Opus 적대검증/Gemini 문서검증, 역할로 고정·교체가능), 기억 2축(에피소드=memsearch 단일권위·post-merge 인덱싱·verified만 / 절차=hermes SKILL.md·PR승격), hermes 격리(샌드박스·노출금지·YOLO금지), ralph=제한 반복(tasks.json·max_iter·비용 킬스위치), prod=사람 승인·크레덴셜 미주입.
- 반영 위치: 신규 `docs/10_agent_ops/operating_model.md`·`loop_and_memory_governance.md`, `memsearch_memory.md` 확장(status/outcome/post-merge/failure_memory/FTS5 OFF), `skill.md`=Hermes runner contract, security_spec/deployment_release 절, 스킬 2개+그래프 노드, 허브 매트릭스/Quick Nav, BUILD_SPEC 매핑.
- 미해결 참고: hermes webhook/API는 RCE-class라 반드시 격리. 자가발전=절차 캐싱+검색+빠른 거절이지 모델 향상 아님.

## 남은 작업
- 템플릿 정비(P0~P2 + 이관 + 비번호화 + 상호참조 + 에이전트 운영 모델)는 **완료**. 이후는 실제 프로젝트에 템플릿을 채우는 단계(플레이스홀더 → 실제 값, Build-Ready 게이트 통과). 선택: hermes 실제 연동 PoC(샌드박스 Dockerfile, tasks.json 스키마, post-merge 인덱싱 훅).

## 컨벤션 / 주의
- 문서는 한국어 우선. 수정은 항상 SoT(`docs/`)에서 → 필요 시 EN 동기화.
- 보강 문서는 `[브래킷]` 템플릿이며, build-spec-gate 게이트는 "실제 프로젝트에 채운 사본"에 적용(템플릿 자체는 통과 대상 아님).
- 참고: git 미추적 파일은 mv 전에 위치를 확인할 것(이번에 MAC 보고서를 repo 밖 `개인/`로 옮긴 뒤 검색 범위 착오로 분실로 오인한 사례 있음 — 실제로는 무결).
- 관련 메모리: [[style_and_conventions]], [[suggested_commands]], [[task_completion]]

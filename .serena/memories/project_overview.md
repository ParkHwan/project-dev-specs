# project-dev-specs — 프로젝트 상태 (단일 출처)

> 이 파일이 프로젝트 상태의 SoT다. 세션 시작 시 먼저 읽고, 변화가 생기면 갱신한다. 세부 이력은 git 로그.

## 목적
다양한 개발 프로젝트(Web/API/ML·AI/Data Pipeline/Library)에 재사용할 **공통 개발 명세서 템플릿 + 에이전트 실행 체계**. 산업 표준(Google PRD/SRE, MS SDL, OWASP, C4, AWS WA) 기반.

## 원격 저장소
- GitHub: https://github.com/ParkHwan/project-dev-specs (branch `main`, 여기서 worktree). origin 연결됨.

## 구조 (레이아웃 B — 평탄화)
repo 루트 직속:
- **SoT = `docs/`** (01_requirements ~ 09_ux, 10_agent_ops, 99_appendix). 모든 수정은 여기서 시작.
- 실행 레이어: `skill.md`(Hermes runner contract) + `BUILD_SPEC_TEMPLATE.md`(Build-Ready 게이트) + `skills/`(28 스킬 + `skill_graph.yaml/.md` DAG).
- `archive/`: monolith(deprecated)·영문본(stale)·LLM 리뷰 4종. 직접 수정 금지.
- `poc/hermes-agent/`: 에이전트 실행 PoC(아래).
- 차별점: `docs/03_data/memsearch_memory.md` — 에이전트 장기기억(memsearch/Milvus).

## 핵심 규약
- **경로**: repo 루트 상대경로(`docs/...`). `Project_Specification_Enhancement/`·`Development_Project_Guide/` 접두어 금지.
- **헤딩**: 글로벌 섹션번호 금지(설명형). 문서 간 참조는 번호 아닌 섹션명/링크.
- **언어/SoT**: 한국어 우선, 수정은 `docs/`에서 → 필요 시 영문본 동기화.
- **플레이스홀더**: `[브래킷]`/`{예시}`. build-spec-gate는 "실제 프로젝트에 채운 사본"에 적용(템플릿 자체는 통과 대상 아님).
- 상세: [[style_and_conventions]], 검사 명령: [[suggested_commands]], 완료 체크: [[task_completion]].

## 상태: 템플릿 정비 = 완료
P0~P2, 레이아웃 B 이관, git 베이스라인, README, 메타데이터 헤더, 섹션 비번호화, 양방향 상호참조, 콘텐츠 심화(endpoints/security/resilience)까지 모두 반영·push 완료.

## 에이전트 자율개발 운영 모델 (반영 완료)
hermes-agent(NousResearch) 실행 + ralph loop + memsearch로 명세를 입력으로 설계→개발→검증→테스트→배포를 **객관 게이트 기반 반자율**로 수행, 사람 감독. (3자 검토 수렴: 완전 자율 아님)
- **핵심 규칙**: 완료는 CI/테스트로 객관판정(자기판단 금지)+테스트디렉터리 쓰기잠금. **생성자≠검증자**(역할로 고정·교체가능). 기억 2축(에피소드=memsearch 단일권위·post-merge·verified만 / 절차=hermes SKILL.md·PR승격). hermes 격리(샌드박스·노출금지·YOLO금지). ralph=제한 반복(max_iter·비용 킬스위치). prod=사람 승인·크레덴셜 미주입.
- **빌드/운영 모드**: ralph는 단계가 아니라 hermes 위 "반복 강도 노브". Build(그린필드·대형기능, 기존repo는 patch mode) / Operate(트러블슈팅·소규모). 경계는 phase가 아니라 작업크기·prod영향. memsearch가 두 모드 공유 학습 다리.
- 반영 위치: `docs/10_agent_ops/{operating_model,loop_and_memory_governance}.md`, `memsearch_memory.md` 확장, `skill.md`, security_spec/deployment_release/cost_management 절, 스킬 2개+그래프, 허브 매트릭스/Quick Nav.

## PoC 결과 (poc/hermes-agent/ — 실증 완료)
- **역할별 모델 분리는 hermes 단독 불가**: 서브에이전트(delegate_task)가 메인 모델 상속. → **ralph 래퍼가 per-invocation `hermes -z -m <모델> --provider`로 역할별 호출**해 Generator≠Verifier 보장.
- **runner 플러그형**(`ralph_loop.sh`, jq 없이 python3 파싱): `model_roles.*.runner` = hermes/codex/claude/gemini.
- **실증 PASS 2건**: ① API모드(`tasks.smoke.json`, hermes/OpenRouter) ② 구독모드(`tasks.smoke.sub.json`, codex 생성/claude 검증) — 둘 다 생성→게이트→적대검증(VERDICT APPROVE)→success.
- 확정 모델 id(OpenRouter): Generator `openai/gpt-5.3-codex`, Verifier `anthropic/claude-opus-4-8`, DocReviewer `google/gemini-3.5-flash`.
- 사실: 구독 CLI는 **계정 기본 모델** 사용(model 필드는 의도 기록용, `-m` 무시). codex `exec` 기본 read-only → 생성 역할은 `--sandbox workspace-write` 필요(반영함). hermes `--read-only` 컨테이너는 `~/.hermes` 쓰기 마운트 필요. `hermes memory`=외부 메모리 provider(memsearch 연결 후보).

## 비용 모델 (사용자 목표: 추가 과금 0)
구독(Claude/ChatGPT/Gemini) ≠ API. **빌드=구독 CLI(codex/claude/gemini 비대화)로 ralph 호출 = 추가 과금 0**, **운영 무인 자동화만 hermes(API)**. 주의: 구독 CLI 루프는 rate limit·ToS 확인.

## 남은 작업
1. (선택) 신규생성 재검증: `calc.py` 삭제 후 구독모드 재실행(codex가 빈 상태에서 생성하는지).
2. **실제 프로젝트 TASK로 확장**: 실 테스트 게이트가 있는 작은 기능으로 `tasks.json` 작성·루프 검증.
3. (선택) memsearch를 `hermes memory`로 연결 + post-merge 인덱싱 검증.

## 주의 / 보안
- 🔑 **키 회전 필요**: 실험 중 OpenAI·OpenRouter 키 노출(채팅+`.env`). `.env`는 gitignore(`poc/**/.env`)됨.
- 🐳 컨테이너가 repo 루트 마운트 시 `.codex/`·`codex-install/`·`tmp/` 잔여물 생성 → gitignore로 막음. 커밋은 **`git add -A` 금지, 명시 경로**. push는 GitHub 시크릿스캐닝 통과 필요.
- git 미추적 파일은 mv 전 위치 확인.

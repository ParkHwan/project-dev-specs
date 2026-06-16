# PoC: hermes-agent 연동 실험

> ⚠️ **실험용 스캐폴드**입니다. 명세(`docs/`)가 아니라 `docs/10_agent_ops/`의 운영 모델을 **실제로 한 번 돌려보기 위한** 산출물입니다.
> hermes의 정확한 설치 명령·memsearch 인덱싱 API·서브에이전트 모델 오버라이드 지원 여부는 **공식 문서에서 미확정**이므로, 아래에 `# 확인 필요`로 표시된 부분은 hermes/memsearch 실제 버전에 맞춰 채운다.

## 구성물

| 파일 | 용도 |
|------|------|
| `Dockerfile` | hermes 격리 실행용 샌드박스 이미지 (비루트·아웃바운드 통제 전제) |
| `config.example.yaml` | hermes 모델/역할 설정 예시 (`~/.hermes/config.yaml`로 복사) |
| `tasks.schema.json` | ralph 루프가 읽는 TASK 상태 파일 JSON Schema (완료 게이트·역할모델·loop 정책 인코딩) |
| `tasks.example.json` | 위 스키마를 따르는 예시 |
| `hooks/post-merge` | main/develop 머지 시 검증 산출물을 memsearch에 인덱싱하는 git 훅 |
| `EXPERIMENT_role_model_separation.md` | **핵심 실험**: 서브에이전트 역할별 모델 분리가 hermes 단독으로 되는지 실측 절차 |

## 실험 목표 (우선순위)

1. **(최우선) 서브에이전트 역할별 모델 분리** — Generator(예: Codex)와 Verifier(예: Opus)를 hermes 설정만으로 다른 모델에 배정할 수 있는가? → `EXPERIMENT_role_model_separation.md`
2. **격리 실행** — Dockerfile로 hermes를 비루트·아웃바운드 통제 하에 띄울 수 있는가.
3. **완료 게이트 결속** — `tasks.json`의 gate 명령(CI/테스트)으로 완료가 객관 판정되는가.
4. **메모리 다리** — post-merge 훅으로 검증 산출물만 memsearch에 들어가는가.

## 모델 라우팅 / 키 구성

- **메인** = Claude via **OpenRouter** (`OPENROUTER_API_KEY`) — Orchestrator + Code Verifier
- **서브** = Codex (`OPENAI_API_KEY`) = Generator / Gemini (`GEMINI_API_KEY`) = Doc·Arch Reviewer
- **비용 모드**: 빌드는 구독 CLI(`codex`/`claude`/`gemini`)로 ralph 호출 = 추가 과금 0 / 무인 운영만 hermes(API). 역할별 `runner`는 tasks.json `model_roles.*.runner`로 지정.
- Anthropic 직접 키는 쓰지 않는다. `~/.hermes/.env`에 위 3개 키를 둔다(커밋 금지).
- ✅ 실측 결과(2026-06-16): 서브에이전트별 모델 분리는 hermes 단독 **불가** → **ralph 래퍼**가 역할별 호출로 분리(`EXPERIMENT_role_model_separation.md` 참고).

## 빠른 시작 (격리 실행 예시)

```bash
# 1) 이미지 빌드
docker build -t hermes-sandbox poc/hermes-agent

# 2) 호스트에 hermes 홈 준비 (config + 키). ~/.hermes 는 쓰기 가능해야 한다.
mkdir -p ~/hermes-poc
cp poc/hermes-agent/config.example.yaml ~/hermes-poc/config.yaml
printf 'OPENROUTER_API_KEY=...\nOPENAI_API_KEY=...\nGEMINI_API_KEY=...\n' > ~/hermes-poc/.env
chmod 600 ~/hermes-poc/.env

# 3) 실행 — 루트FS는 읽기전용, 단 ~/.hermes 와 /workspace 는 쓰기 가능 볼륨
docker run --rm -it \
  --name hermes-sandbox \
  --cap-drop ALL \
  --security-opt no-new-privileges \
  --read-only --tmpfs /tmp \
  -v "$PWD":/workspace:rw \
  -v "$PWD/tests":/workspace/tests:ro \              # 테스트 디렉터리 쓰기 잠금(Locker)
  -v "$HOME/hermes-poc":/home/agent/.hermes:rw \     # config/키/스킬/메모리 쓰기 공간(--read-only 보완)
  # --network 통제: 사내 프록시/allowlist만 허용 (예: 전용 docker network)
  hermes-sandbox
```

> ⚠️ `--read-only`만 두고 `~/.hermes`를 쓰기 볼륨으로 마운트하지 않으면, hermes가 config.yaml을 생성할 때 `Read-only file system` 오류가 난다. 위처럼 `~/.hermes`를 반드시 쓰기 가능 볼륨/`--tmpfs`로 준다.
> 휘발 임시로 쓰려면 마운트 대신 `--tmpfs /home/agent/.hermes:uid=10001,mode=0700` 후 컨테이너 안에서 config/.env 생성.

> 🔒 prod 크레덴셜은 이 컨테이너에 **주입하지 않는다**. webhook/API 게이트웨이는 외부 노출 금지.

## 관련 문서
- [에이전트 운영 모델](../../docs/10_agent_ops/operating_model.md)
- [루프·메모리 거버넌스](../../docs/10_agent_ops/loop_and_memory_governance.md)
- [에이전트 장기기억 (memsearch)](../../docs/03_data/memsearch_memory.md)

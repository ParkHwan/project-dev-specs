# 실험: 서브에이전트 역할별 모델 분리 (Generator ≠ Verifier)

> **목표**: hermes **단독 설정만으로** "코드 생성 서브에이전트 = Codex, 검증 = Opus"처럼 역할별로 다른 모델을 배정할 수 있는가? 안 되면 대안 경로를 확정한다.
>
> 이게 가장 가치 있는 실험인 이유: "생성자≠검증자"는 거짓 완료 방어의 핵심인데, hermes 공식 문서에 **서브에이전트 모델 오버라이드 키가 명시돼 있지 않다.** 서브에이전트가 주 모델을 그대로 상속하면 분리가 깨진다.

## 가설
- **H0(귀무)**: hermes 서브에이전트는 주(primary) 모델을 상속한다 → 설정만으로 역할 분리 불가.
- **H1(대립)**: hermes 설정(서브에이전트/aux 슬롯/스킬 단위 모델 지정 등)으로 서브에이전트에 다른 모델을 배정할 수 있다.

## 준비
1. `~/.hermes/.env`에 3개 키:
   - `OPENROUTER_API_KEY` — 메인 Claude (OpenRouter 경유)
   - `OPENAI_API_KEY` — 서브 Codex (Generator)
   - `GEMINI_API_KEY` — 서브 Gemini (Doc/Arch Reviewer)  # 확인 필요: 실제 키 이름
2. `config.example.yaml`을 `~/.hermes/config.yaml`로 복사. 주 모델 = `anthropic/claude-opus-4`, provider=`openrouter`.

목표 매핑: Generator=Codex(OpenAI) · Verifier=Claude(OpenRouter, 메인) · Doc Reviewer=Gemini(Google).
3. 관측 수단 확보(아래 중 하나):
   - 프로바이더 대시보드(OpenRouter/Anthropic console)에서 **실제 호출된 모델** 로그 확인.
   - 또는 에이전트/서브에이전트에게 "현재 응답 모델 ID를 보고하라" 프롬프트(자기보고는 보조 근거).

## 절차
1. **베이스라인**: 주 모델만 설정한 채 서브에이전트를 스폰하는 작업을 실행 → 서브에이전트 호출이 어느 모델로 나가는지 대시보드로 확인.
2. **오버라이드 시도 A — 설정 키**: `config.yaml`에 서브에이전트/스킬 단위 모델 키가 있는지 문서/`hermes config` 출력에서 탐색하고 적용. (`# 확인 필요` 키 후보: `subagents.*.model`, skill frontmatter의 `model:` 등)
3. **오버라이드 시도 B — CLI/스킬**: 서브에이전트 정의(스킬/agentskills) 또는 CLI 플래그로 모델 지정이 가능한지 시도.
4. **검증**: 생성 호출이 Codex(OpenRouter), 검증 호출이 Opus(Anthropic)로 **분리되어 나가는지** 대시보드 로그로 교차 확인.

## 판정 기준
- **PASS(H1)**: 대시보드 로그상 generator 호출 = Codex, verifier 호출 = Opus로 명확히 분리.
- **FAIL(H0)**: 두 호출 모두 주 모델로 나감 → 설정만으로는 분리 불가.

## FAIL 시 대안 (사전 정의)
1. **ralph 래퍼에서 보장(권장)**: ralph 루프가 ① Codex 엔드포인트로 생성 호출 → ② 게이트 통과 후 별도 Opus 엔드포인트로 검증 호출. hermes는 실행 셸로만 쓰고 모델 분리는 외부에서 강제.
2. **2-인스턴스**: generator용 hermes(주 모델=Codex) + verifier용 hermes(주 모델=Opus)를 ralph가 조율.
3. **OpenRouter 호출별 전환**: 프레임워크가 호출 단위 모델 지정을 허용하면 단일 키로 전환.

## 결과 기록 (2026-06-16 실측)
| 항목 | 결과 |
|------|------|
| 서브에이전트 명령/설정 키 | 없음 (`hermes`에 agent/subagent 명령 없음, `config show`에 subagent 모델 키 없음) |
| 서브에이전트 기본 모델 상속? | **예** — delegate_task 서브가 메인(Claude/OpenRouter)에서 실행됨 |
| 분리 관측(대시보드) | OpenRouter에만 호출 / **OpenAI 대시보드 무호출** = LLM 분리 안 됨 |
| hermes의 "Codex 사용" 방식 | 모델 라우팅 아님 → 외부 `codex` CLI 셸아웃(tool-use), Codex 자체 인증 필요(401 실패) |
| generator≠verifier 분리(hermes 단독) | **FAIL** |
| per-invocation 오버라이드(`-m/--provider/-z`) | **지원** → 역할별 호출 분리 가능 |
| 채택 경로 | **ralph 래퍼**(`ralph_loop.sh`), 모델은 모두 **OpenRouter** 경유 |
| 비고 | hermes OpenAI 키 슬롯은 STT/TTS용 → GPT/Codex chat은 OpenRouter로. 시크릿 마스킹/승인 게이트가 키 셸 전파를 차단(보안 정상 작동). |

**확정 결론**: hermes 내부 서브에이전트로는 Generator≠Verifier를 만들 수 없다. ralph가 역할마다 `hermes -z -m <모델> --provider openrouter`로 호출하여 LLM 레벨 분리를 보장한다. → `operating_model.md` 토폴로지 절에 반영함.

## ralph 래퍼 end-to-end 실증 (2026-06-16, PASS)

`ralph_loop.sh poc/hermes-agent/tasks.smoke.json` 1회 실행 결과:
- **역할 분리 실증**: 생성 = `openai/gpt-5.3-codex`, 검증 = `anthropic/claude-opus-4-8` — OpenRouter 대시보드에 두 모델 각각 호출 확인.
- **루프 정상**: iter 1 → 생성(calc.py 작성) → **게이트 PASS**(check.py `GATE OK`) → 적대적 검증 → `VERDICT: APPROVE` → `stop_reason=success`.
- **adversarial verify 동작**: 검증자가 오버플로·음수·교환법칙으로 반증 시도 후, 타입검증은 TASK 스코프 밖이라 정확히 판단하고 승인.
- 해소된 불확실성: hermes `-z` oneshot이 **파일을 실제로 생성**함, **VERDICT 파싱 동작**.

결론: **객관 게이트 기반 반자율 + 역할별 모델 분리(ralph 래퍼)** 아키텍처가 실제로 동작함을 확인. 다음은 실제 프로젝트 TASK(실 테스트 게이트)로 확장.

## 구독 CLI 모드 실증 (2026-06-16, PASS — 비용 0 경로)

`ralph_loop.sh tasks.smoke.sub.json`(generator=codex, verifier=claude)을 **호스트**에서 실행:
- **codex(ChatGPT 구독)** 가 생성 역할로 동작, **claude(Claude 구독)** 가 검증 역할로 `VERDICT: APPROVE` 출력 → success. **추가 API 과금 0**.
- 확인 사실: 구독 CLI는 **계정 기본 모델**을 사용(codex가 `gpt-5.5`로 실행, tasks.json의 `model`은 의도 기록용·`-m` 무시).
- ⚠️ 주의: codex `exec`의 기본 샌드박스는 **read-only**라 신규 파일을 못 쓴다. 생성 역할은 `--sandbox workspace-write` 필요(ralph_loop에 반영). 위 1회는 calc.py가 이전 잔존본이라 통과했으므로, **신규 생성 검증은 calc.py 삭제 후 재실행**으로 확인할 것.
- 실행 위치: 구독 CLI는 호스트에 로그인되어 있으므로 **호스트에서 실행**(hermes만 컨테이너 격리).

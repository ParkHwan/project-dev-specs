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

## 결과 기록 (실험 후 채움)
| 항목 | 결과 |
|------|------|
| hermes 버전 | [확인] |
| 서브에이전트 기본 모델 상속? | [예/아니오] |
| 설정 오버라이드 키 존재? | [키 이름 / 없음] |
| generator=Codex, verifier=Opus 분리 확인? | [PASS/FAIL] |
| 채택 경로 | [설정 / ralph 래퍼 / 2-인스턴스 / OpenRouter] |
| 비고 | [ ] |

> 결과가 나오면 `docs/10_agent_ops/operating_model.md`의 멀티에이전트 토폴로지 절에 "역할-모델 분리 실현 방식"으로 한 줄 확정 반영한다(현재는 미확정으로 남겨둠).

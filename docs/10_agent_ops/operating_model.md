# 🤖 Agent Operating Model

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 이 명세서를 입력으로, 에이전트가 설계→개발→검증→테스트→배포를 수행하는 **운영 모델**을 정의합니다. 핵심 원칙은 **"완전 자율"이 아니라 "객관 게이트 기반 반자율(semi-autonomous)"** 입니다. 루프/메모리 세부 규칙은 [loop_and_memory_governance.md](./loop_and_memory_governance.md)를 따릅니다.

---

## 핵심 원칙

- **객관 게이트가 권위**: 완료 여부는 에이전트의 자기 보고가 아니라 CI·테스트·계약·스모크로 판정한다.
- **생성자 ≠ 검증자**: 코드를 생성한 모델과 검증하는 모델은 항상 다르다.
- **검증된 것만 기억**: 미검증 추론은 장기기억에 저장하지 않는다.
- **사람 감독 지점 고정**: 아키텍처 결정, prod 배포, 스킬 승격은 사람이 승인한다.
- **단일 진실 출처 유지**: 명세(`docs/`)가 입력이자 완료 기준이며, 에이전트는 스펙 밖을 추측 구현하지 않는다.

---

## 구성요소와 역할 경계

| 구성요소 | 맡는 역할 | 맡기지 않는 역할 |
|----------|-----------|------------------|
| BUILD_SPEC_TEMPLATE 게이트 | Build-Ready 계약·착수/차단 기준 | 실행 루프 자체 |
| skills DAG | 어떤 명세를 어떤 순서로 완성할지 | 실시간 task 스케줄러 |
| **hermes-agent** | 주 실행자: 도구 호출, 코드 수정, 테스트 구동, 보고 | 무제한 prod 배포, 무검증 자기 승인 |
| **ralph loop** | 한 TASK에 대한 **제한된 반복 정책**(retry harness) | 전체 프로젝트를 모는 무한 총괄 루프 |
| **memsearch** | 검증된 에피소드 기억(결정/태스크/실패)의 **단일 권위** + 시맨틱 검색 | 매 턴 자동 저장되는 쓰레기통 |
| **hermes SKILL.md** | 검토 후 승격된 **절차적 지식** | 실패 로그에서 자동 즉시 설치되는 self-modifying code |

> 루프는 hermes를 주 실행자로 두고, ralph는 그 위의 **외부 반복 정책**(max_iter·비용·테스트 게이트)으로만 제한한다. 단계 진행(설계→개발…)은 skills DAG와 사람이 몰고, ralph는 **태스크 단위 재시도**만 담당한다.

---

## 멀티에이전트 모델 토폴로지

역할별로 모델을 라우팅하되, **모델명이 아니라 역할로 고정**한다(교체 가능). 불변 규칙: **Code Verifier ≠ Code Generator**.

| 역할 | 책임 | 현재 배정(예시) | 교체 |
|------|------|-----------------|:----:|
| Orchestrator | 계획·다음 단계 결정·서브에이전트 조율 | Opus | ✅ |
| Code Generator (subagent) | 단일 TASK 코드 생성/수정 | Codex | ✅ |
| Code Verifier (적대적) | 생성 코드의 결함·보안·계약 위반을 **반증** | Opus(생성자와 다른 모델) | ✅ |
| Doc/Arch Reviewer | 문서·아키텍처·ADR 교차검증 | Gemini | ✅ |

> **역할-모델 분리 실현 방식 (실측 확정, 2026-06-16)**: hermes 내부 서브에이전트는 메인 모델을 상속하므로 hermes 단독으로는 Generator≠Verifier가 안 된다. → **ralph 외부 래퍼가 역할마다 `hermes -z "<프롬프트>" -m <모델> --provider openrouter`로 호출**해 LLM 레벨 분리를 보장한다. 모델은 모두 OpenRouter 경유(예: Generator=`openai/gpt-5-codex`, Verifier=`anthropic/claude-opus-4-8`). 구현·근거: [PoC ralph_loop.sh / EXPERIMENT](../../poc/hermes-agent/EXPERIMENT_role_model_separation.md).

### Generator–Critic 흐름과 중재
1. Generator가 TASK 코드 생성.
2. **하드 게이트**(CI·테스트·lint) 통과 후에만 검증 진행(미통과 코드에 리뷰 낭비 금지).
3. **Code Verifier가 적대적 리뷰**: "Acceptance Criteria 위반·보안·엣지케이스를 반증하라" 체크리스트로(긍정 동의 유도 금지).
4. 거절 시: 비평을 다음 ralph 루프 입력으로 Generator에 피드백(반복은 `max_iter`로 bound).
5. `max_iter` 초과 또는 Verifier 반복 거절 시 **사람 에스컬레이션**.
6. Doc/Arch Reviewer는 **핫 루프 밖**에서, 아키텍처/ADR/스펙 변경 PR 시점에만 호출.

> LLM 교차검증은 게이트의 **대체가 아니라 추가 소프트 레이어**다. 최종 권위는 객관 게이트와 사람 승인이다.

---

## 단계별 적용

각 단계 = `명세 입력 → ralph 루프(hermes 실행 + memsearch 회수) → 완료 게이트 → 사람 감독 → 검증 기억 적립`.

| 단계 | 입력(명세) | 완료 게이트(객관) | 사람 감독 |
|------|------------|-------------------|-----------|
| 설계 | requirements/architecture/data/api | 플레이스홀더 0, 미결정 ADR 0(또는 blocker 등록), API/데이터/테스트 계약 존재 | 아키텍처·DB/인프라·비용 결정 **서명** |
| 개발 | 설계 산출물·endpoints·coding_style | TASK Acceptance 충족 + lint/type/unit 통과 + diff scope 제한 | API/public interface/마이그레이션 변경 승인 |
| 검증 | testing_strategy·security_spec | CI green + coverage 기준 + contract diff 없음 + 보안 스캔 high/critical 0 | 보안 스캔 결과 검토 |
| 테스트 | testing_strategy(E2E/부하)·non_functional(SLO) | 요구사항별 테스트 매핑 100% + flaky 격리 + 재현 실패 없음 + SLO 충족 | 릴리스 후보 검수 |
| 배포 | deployment_release·cost_management·IaC | (stage) 스모크 통과·롤백 검증 / (prod) Manual Approval | 🚦 **prod 배포 직접 승인** |

---

## 빌드 모드 vs 운영 모드 (Build vs Operate)

ralph와 hermes는 단계가 아니라 **레이어**다. 실행 주체는 두 모드 모두 hermes(또는 CLI 에이전트)이고, **ralph는 그 위의 "반복 강도 노브"** 다.

| 구분 | Build 모드 | Operate 모드 |
|------|-----------|--------------|
| 대상 | 그린필드·대형 기능(잘 정의된 TASK 다수) | 정상 운영·트러블슈팅·소규모 요청 |
| ralph | **세게**(bounded 자동 반복) | **약하게/끄고** hermes 네이티브 루프 + 사람 트리거 |
| 기존 코드베이스 | (해당 시) **patch mode만** | patch mode·대화형 |
| 게이트 | 전체 게이트 | prod 영향 변경은 게이트·승인·교차검증 유지 |

### 모드 경계 = phase가 아니라 작업 크기·prod 영향
- 운영 중 **추가 기능 = 미니 빌드 사이클** → Build 모드 규칙 적용(기존 repo는 patch mode).
- **작은 triage(버그·문의)** → Operate 모드(hermes 대화형 + 스킬).
- **prod에 닿는 변경**은 모드 불문 객관 게이트 + 사람 승인(+가능하면 교차검증)을 유지한다. 운영이라고 게이트를 풀지 않는다.

### 학습 연속성 (다리)
- 빌드에서 쌓은 검증 지식이 운영으로 넘어가야 자가습득이 의미를 가진다.
- **memsearch를 두 모드가 공유하는 단일 에피소드 권위**로 둔다 → 빌드의 결정·실패→해결·패턴을 운영 단계 에이전트가 그대로 회수. 절차 지식(hermes SKILL.md)도 공유한다. 이 다리를 놓지 않으면 운영 에이전트는 처음부터 다시 학습한다.

### 자동화 점진 경로
1. **수동 오케스트레이션**: 사람이 orchestrator(예: cmux에서 Claude가 설계·프롬프트 작성 → Codex/Gemini에 분배) — 제어 최대.
2. **반자동**: 그 프롬프트 릴레이를 ralph로 자동화하되 TASK 완료마다 감독.
3. 신뢰가 쌓이면 자동화 비중을 높인다(자율 경계는 아래를 유지).

---

## 자율 경계 (Autonomy Boundaries)

- **dev/staging**: 자율 배포 + 스모크 테스트 자동 허용.
- **prod**: 🚫 에이전트 직접 배포 차단. CI/CD에 **Manual Approval Gate** 명시, 사람이 영향도·롤백 런북 검토 후 승인.
- **prod 크레덴셜**: 에이전트 실행 환경에 **주입하지 않는다**. prod는 에이전트가 PR/Release를 *준비*만 한다.
- **스킬 승격**: 자동 설치 금지 → PR 리뷰 후 승격(→ [loop_and_memory_governance](./loop_and_memory_governance.md)).
- **기존 코드베이스**: ralph 전면 반복 금지, **TASK 단위 patch mode**만. 전면 반복은 greenfield/격리 브랜치 한정.

---

## 🔗 관련 문서
- [루프·메모리 거버넌스](./loop_and_memory_governance.md)
- [에이전트 장기기억 (memsearch)](../03_data/memsearch_memory.md)
- [Build-Ready 게이트](../../BUILD_SPEC_TEMPLATE.md)
- [배포 및 릴리즈](../06_operations/deployment_release.md)
- [보안 및 프라이버시](../08_security_privacy/security_spec.md)

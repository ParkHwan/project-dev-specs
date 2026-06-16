#!/usr/bin/env bash
# ralph 래퍼 — tasks.json 기반 "역할별 모델" 루프
#
# 배경(실험 결과): hermes 내부 서브에이전트는 메인 모델을 상속하므로 LLM 레벨에서
# Generator≠Verifier 분리가 안 된다. 그래서 ralph(외부)가 역할마다 hermes를
# per-invocation 모델 오버라이드(-m/--provider, oneshot -z)로 호출해 분리를 보장한다.
#
# 흐름(한 TASK): [생성:Generator 모델] → [객관 게이트:테스트] → [검증:Verifier 모델(다른 모델)]
#               게이트+검증 통과 시 success, 아니면 max_iterations까지 반복(자기참조=repo/테스트 상태).
#
# 요구: jq, hermes(컨테이너 내), OpenRouter 키(~/.hermes/.env)
# 사용: ./ralph_loop.sh [tasks.json]
#
# 한계/주의:
#  - 비용 킬스위치는 hermes oneshot에서 토큰비용을 직접 못 받으므로 max_iterations로 근사
#    (정밀 비용은 `hermes insights`/대시보드로 별도 관측). # 확인 필요
#  - 게이트 test_command는 실제 프로젝트 명령으로 교체(예시는 플레이스홀더).
#  - prod 영향(human_gate=true)은 배포 자동화하지 않고 사람 승인으로 넘긴다.
set -Eeuo pipefail

TASKS="${1:-tasks.json}"
WORKDIR="${WORKDIR:-/workspace}"
command -v jq     >/dev/null || { echo "[ERR] jq 필요"; exit 1; }
command -v hermes >/dev/null || { echo "[ERR] hermes 필요"; exit 1; }
[ -f "$TASKS" ]              || { echo "[ERR] $TASKS 없음"; exit 1; }

run_oneshot() { # $1 prompt  $2 model  $3 provider
  hermes -z "$1" -m "$2" --provider "$3"
}

count="$(jq '.tasks | length' "$TASKS")"
for i in $(seq 0 $((count - 1))); do
  t="$(jq ".tasks[$i]" "$TASKS")"
  [ "$(jq -r '.status' <<<"$t")" = "todo" ] || continue

  id="$(jq -r '.id' <<<"$t")"
  title="$(jq -r '.title' <<<"$t")"
  gen_m="$(jq -r '.model_roles.generator.model' <<<"$t")";  gen_p="$(jq -r '.model_roles.generator.provider' <<<"$t")"
  ver_m="$(jq -r '.model_roles.verifier.model'  <<<"$t")";  ver_p="$(jq -r '.model_roles.verifier.provider'  <<<"$t")"
  max_iter="$(jq -r '.loop.max_iterations' <<<"$t")"
  test_cmd="$(jq -r '.gate.test_command' <<<"$t")"
  human_gate="$(jq -r '.human_gate // false' <<<"$t")"
  ac="$(jq -r '.acceptance_criteria | map("- " + .) | join("\n")' <<<"$t")"

  # 불변 규칙: Generator ≠ Verifier (같으면 분리 의미 없음 → 스킵)
  if [ "$gen_m" = "$ver_m" ] && [ "$gen_p" = "$ver_p" ]; then
    echo "[$id] SKIP: generator == verifier ($gen_p/$gen_m) — 분리 위반"; continue
  fi

  echo "=== [$id] $title"
  echo "    generator=$gen_p/$gen_m   verifier=$ver_p/$ver_m   max_iter=$max_iter"
  stop_reason=""; iter=0
  while [ "$iter" -lt "$max_iter" ]; do
    iter=$((iter + 1))
    echo "--- [$id] iter $iter/$max_iter ---"

    # 1) 생성 (Generator 모델)
    gen_prompt="다음 TASK를 ${WORKDIR}에 구현하라. 스펙 밖 추측 금지. 테스트 디렉터리는 수정 금지.
TASK: ${title}
Acceptance:
${ac}
직전 반복의 코드/테스트 실패가 있으면 그것을 보고 고쳐라. 변경 요약만 출력하라."
    run_oneshot "$gen_prompt" "$gen_m" "$gen_p" || true

    # 2) 객관 게이트 (테스트) — 통과해야만 검증 단계로
    if ! bash -c "$test_cmd"; then
      echo "[$id] gate FAIL (test) → 다음 반복"
      continue
    fi

    # 3) 검증 (Verifier 모델 = Generator와 다른 모델, 적대적)
    diff_stat="$(git -C "$WORKDIR" diff --stat 2>/dev/null || true)"
    ver_prompt="너는 적대적 코드 검증자다. 아래 TASK의 Acceptance 위반, 보안/엣지케이스 결함을 '반증'하라.
TASK: ${title}
Acceptance:
${ac}
변경 요약: ${diff_stat}
결함이 없으면 마지막 줄에 정확히 'VERDICT: APPROVE', 있으면 'VERDICT: REJECT'와 이유를 출력하라."
    ver_out="$(run_oneshot "$ver_prompt" "$ver_m" "$ver_p" || true)"
    printf '%s\n' "$ver_out" | tail -n 6

    if printf '%s' "$ver_out" | grep -q 'VERDICT: APPROVE'; then
      stop_reason="success"; break
    fi
    echo "[$id] verify REJECT → 다음 반복"
  done

  [ -n "$stop_reason" ] || stop_reason="max_iter"
  echo "=== [$id] stop_reason=${stop_reason} (iter=${iter}/${max_iter})"
  if [ "$human_gate" = "true" ]; then
    echo "🚦 [$id] human_gate=true → prod 영향: 자동 배포 금지, 사람 승인 필요"
  fi
done

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
# 요구: python3, hermes(컨테이너 내), OpenRouter 키(~/.hermes/.env)   ← jq 불필요
# 사용: cd <repo 루트> && ./poc/hermes-agent/ralph_loop.sh poc/hermes-agent/tasks.smoke.json
#
# 한계/주의:
#  - 비용 킬스위치는 hermes oneshot에서 토큰비용을 직접 못 받으므로 max_iterations로 근사
#    (정밀 비용은 `hermes insights`/대시보드로 별도 관측).
#  - 게이트 test_command는 실제 프로젝트 명령으로 교체(스모크는 의존성 없는 예시).
#  - prod 영향(human_gate=true)은 배포 자동화하지 않고 사람 승인으로 넘긴다.
set -Eeuo pipefail

TASKS="${1:-tasks.json}"
WORKDIR="${WORKDIR:-$PWD}"
command -v python3 >/dev/null || { echo "[ERR] python3 필요"; exit 1; }
command -v hermes  >/dev/null || { echo "[ERR] hermes 필요"; exit 1; }
[ -f "$TASKS" ]               || { echo "[ERR] tasks 파일 없음: $TASKS"; exit 1; }

# python3로 task 필드를 안전하게(shlex) 추출해 shell 변수로 eval
read_task() { # $1 tasks.json  $2 index  → ID/TITLE/STATUS/GEN_*/VER_*/MAX_ITER/TEST_CMD/HUMAN_GATE/AC 출력
  python3 - "$1" "$2" <<'PY'
import json, shlex, sys
d = json.load(open(sys.argv[1])); t = d["tasks"][int(sys.argv[2])]
q = lambda x: shlex.quote(str(x))
mr = t.get("model_roles", {}); g = mr.get("generator", {}); v = mr.get("verifier", {})
ac = "\n".join("- " + a for a in t.get("acceptance_criteria", []))
out = {
  "ID": t.get("id",""), "TITLE": t.get("title",""), "STATUS": t.get("status",""),
  "GEN_M": g.get("model",""), "GEN_P": g.get("provider",""),
  "VER_M": v.get("model",""), "VER_P": v.get("provider",""),
  "MAX_ITER": t.get("loop",{}).get("max_iterations",1),
  "TEST_CMD": t.get("gate",{}).get("test_command",""),
  "HUMAN_GATE": str(t.get("human_gate", False)).lower(),
  "AC": ac,
}
for k, val in out.items():
    print(f"{k}={q(val)}")
PY
}

run_oneshot() { hermes -z "$1" -m "$2" --provider "$3"; }  # prompt model provider

COUNT="$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))['tasks']))" "$TASKS")"
for i in $(seq 0 $((COUNT - 1))); do
  eval "$(read_task "$TASKS" "$i")"
  [ "$STATUS" = "todo" ] || continue

  if [ "$GEN_M" = "$VER_M" ] && [ "$GEN_P" = "$VER_P" ]; then
    echo "[$ID] SKIP: generator == verifier ($GEN_P/$GEN_M) — 분리 위반"; continue
  fi

  echo "=== [$ID] $TITLE"
  echo "    generator=$GEN_P/$GEN_M   verifier=$VER_P/$VER_M   max_iter=$MAX_ITER"
  stop_reason=""; iter=0
  while [ "$iter" -lt "$MAX_ITER" ]; do
    iter=$((iter + 1))
    echo "--- [$ID] iter $iter/$MAX_ITER ---"

    # 1) 생성 (Generator 모델)
    gen_prompt="다음 TASK를 구현하라. 스펙 밖 추측 금지. 테스트 디렉터리는 수정 금지.
TASK: ${TITLE}
Acceptance:
${AC}
직전 반복의 코드/테스트 실패가 있으면 그것을 보고 고쳐라. 변경 요약만 출력하라."
    run_oneshot "$gen_prompt" "$GEN_M" "$GEN_P" || true

    # 2) 객관 게이트 (테스트) — 통과해야만 검증 단계로
    if ! ( cd "$WORKDIR" && bash -c "$TEST_CMD" ); then
      echo "[$ID] gate FAIL (test) → 다음 반복"
      continue
    fi
    echo "[$ID] gate PASS"

    # 3) 검증 (Verifier 모델 = Generator와 다른 모델, 적대적)
    diff_stat="$(git -C "$WORKDIR" diff --stat 2>/dev/null || true)"
    ver_prompt="너는 적대적 코드 검증자다. 아래 TASK의 Acceptance 위반, 보안/엣지케이스 결함을 '반증'하라.
TASK: ${TITLE}
Acceptance:
${AC}
변경 요약: ${diff_stat}
결함이 없으면 마지막 줄에 정확히 'VERDICT: APPROVE', 있으면 'VERDICT: REJECT'와 이유를 출력하라."
    ver_out="$(run_oneshot "$ver_prompt" "$VER_M" "$VER_P" || true)"
    printf '%s\n' "$ver_out" | tail -n 6

    if printf '%s' "$ver_out" | grep -q 'VERDICT: APPROVE'; then
      stop_reason="success"; break
    fi
    echo "[$ID] verify REJECT → 다음 반복"
  done

  [ -n "$stop_reason" ] || stop_reason="max_iter"
  echo "=== [$ID] stop_reason=${stop_reason} (iter=${iter}/${MAX_ITER})"
  [ "$HUMAN_GATE" = "true" ] && echo "🚦 [$ID] human_gate=true → prod 영향: 자동 배포 금지, 사람 승인 필요"
done

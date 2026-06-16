#!/usr/bin/env bash
# ralph 래퍼 — tasks.json 기반 "역할별 모델/runner" 루프
#
# 핵심: ralph는 외부 오케스트레이터이고 실행기(runner)는 교체 가능하다.
#   - 빌드 모드 = 구독 기반 CLI(codex/claude/gemini)로 호출 → 추가 API 비용 0
#   - 운영/무인 = hermes(API) → 토큰 과금(필요할 때만)
# 역할별 모델 분리(Generator≠Verifier)는 어느 모드든 유지된다.
#
# 흐름(한 TASK): [생성:Generator] → [객관 게이트:테스트] → [검증:Verifier(다른 모델/runner)]
#               게이트+검증 통과 시 success, 아니면 max_iterations까지 반복.
#
# 요구: python3, 사용하는 runner(아래). jq 불필요.
# 사용: cd <repo 루트> && ./poc/hermes-agent/ralph_loop.sh poc/hermes-agent/tasks.smoke.json
set -Eeuo pipefail

TASKS="${1:-tasks.json}"
WORKDIR="${WORKDIR:-$PWD}"
command -v python3 >/dev/null || { echo "[ERR] python3 필요"; exit 1; }
[ -f "$TASKS" ]               || { echo "[ERR] tasks 파일 없음: $TASKS"; exit 1; }

# runner 디스패치 — $1 runner  $2 model  $3 provider  $4 prompt
# 구독 CLI는 계정 기본 모델을 사용(모델 필드는 의도 기록용). 정확한 플래그는 환경에 맞게 조정.
run_role() {
  case "$1" in
    hermes) command -v hermes >/dev/null || { echo "[ERR] hermes 미설치"; return 1; }
            hermes -z "$4" -m "$2" --provider "$3" ;;
    codex)  command -v codex  >/dev/null || { echo "[ERR] codex 미설치"; return 1; }
            # 생성 역할은 파일 쓰기 필요 → workspace-write 샌드박스. (기본은 read-only라 생성 불가)
            codex exec --skip-git-repo-check --sandbox workspace-write "$4" ;;   # ChatGPT 구독(codex login). -m 무시(계정 모델 사용)
    claude) command -v claude >/dev/null || { echo "[ERR] claude 미설치"; return 1; }
            claude -p "$4" ;;                                    # Claude 구독(Claude Code). 생성 역할이면 권한 플래그 필요  # 확인 필요
    gemini) command -v gemini >/dev/null || { echo "[ERR] gemini 미설치"; return 1; }
            gemini -p "$4" ;;                                    # Gemini 구독. 정확한 비대화 플래그 확인  # 확인 필요
    *) echo "[ERR] unknown runner: $1"; return 1 ;;
  esac
}

read_task() { # $1 tasks.json  $2 index
  python3 - "$1" "$2" <<'PY'
import json, shlex, sys
d = json.load(open(sys.argv[1])); t = d["tasks"][int(sys.argv[2])]
q = lambda x: shlex.quote(str(x))
mr = t.get("model_roles", {}); g = mr.get("generator", {}); v = mr.get("verifier", {})
ac = "\n".join("- " + a for a in t.get("acceptance_criteria", []))
out = {
  "ID": t.get("id",""), "TITLE": t.get("title",""), "STATUS": t.get("status",""),
  "GEN_RUNNER": g.get("runner","hermes"), "GEN_M": g.get("model",""), "GEN_P": g.get("provider",""),
  "VER_RUNNER": v.get("runner","hermes"), "VER_M": v.get("model",""), "VER_P": v.get("provider",""),
  "MAX_ITER": t.get("loop",{}).get("max_iterations",1),
  "TEST_CMD": t.get("gate",{}).get("test_command",""),
  "HUMAN_GATE": str(t.get("human_gate", False)).lower(),
  "AC": ac,
}
for k, val in out.items():
    print(f"{k}={q(val)}")
PY
}

COUNT="$(python3 -c "import json,sys;print(len(json.load(open(sys.argv[1]))['tasks']))" "$TASKS")"
for i in $(seq 0 $((COUNT - 1))); do
  eval "$(read_task "$TASKS" "$i")"
  [ "$STATUS" = "todo" ] || continue

  # 불변 규칙: Generator ≠ Verifier (runner+model 조합이 같으면 분리 위반)
  if [ "$GEN_RUNNER/$GEN_M" = "$VER_RUNNER/$VER_M" ]; then
    echo "[$ID] SKIP: generator == verifier ($GEN_RUNNER/$GEN_M) — 분리 위반"; continue
  fi

  echo "=== [$ID] $TITLE"
  echo "    generator=$GEN_RUNNER:$GEN_M   verifier=$VER_RUNNER:$VER_M   max_iter=$MAX_ITER"
  stop_reason=""; iter=0
  while [ "$iter" -lt "$MAX_ITER" ]; do
    iter=$((iter + 1))
    echo "--- [$ID] iter $iter/$MAX_ITER ---"

    gen_prompt="다음 TASK를 구현하라. 스펙 밖 추측 금지. 테스트 디렉터리는 수정 금지.
TASK: ${TITLE}
Acceptance:
${AC}
직전 반복의 코드/테스트 실패가 있으면 그것을 보고 고쳐라. 변경 요약만 출력하라."
    run_role "$GEN_RUNNER" "$GEN_M" "$GEN_P" "$gen_prompt" || true

    if ! ( cd "$WORKDIR" && bash -c "$TEST_CMD" ); then
      echo "[$ID] gate FAIL (test) → 다음 반복"; continue
    fi
    echo "[$ID] gate PASS"

    diff_stat="$(git -C "$WORKDIR" diff --stat 2>/dev/null || true)"
    ver_prompt="너는 적대적 코드 검증자다. 아래 TASK의 Acceptance 위반, 보안/엣지케이스 결함을 '반증'하라.
TASK: ${TITLE}
Acceptance:
${AC}
변경 요약: ${diff_stat}
결함이 없으면 마지막 줄에 정확히 'VERDICT: APPROVE', 있으면 'VERDICT: REJECT'와 이유를 출력하라."
    ver_out="$(run_role "$VER_RUNNER" "$VER_M" "$VER_P" "$ver_prompt" || true)"
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

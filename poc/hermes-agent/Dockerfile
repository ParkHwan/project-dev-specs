# hermes-agent 격리 실행 샌드박스
# 원칙: 비루트 실행 / 최소 권한 / 아웃바운드는 런타임에서 통제(README의 docker run 참고)
FROM python:3.12-slim

# 기본 도구 (git: post-merge 훅·patch mode, 빌드 의존성 최소)
RUN apt-get update \
 && apt-get install -y --no-install-recommends git ca-certificates curl jq \
 && rm -rf /var/lib/apt/lists/*

# 비루트 사용자
RUN useradd -m -u 10001 agent
USER agent
WORKDIR /workspace

# hermes 설치
# 확인 필요: 공식 설치 방법(아래 중 실제 방식으로 확정). 패키지명/명령은 hermes README 기준.
#   옵션 A) PyPI:    RUN pip install --user --no-cache-dir hermes-agent
#   옵션 B) GitHub:  RUN pip install --user --no-cache-dir "git+https://github.com/NousResearch/hermes-agent.git"
# PoC에서는 옵션 B로 시도하고, 실패 시 README의 정확한 명령으로 교체한다.
RUN pip install --user --no-cache-dir "git+https://github.com/NousResearch/hermes-agent.git" \
 || echo "[WARN] hermes 설치 실패 — README의 정확한 설치 명령으로 교체할 것"
ENV PATH="/home/agent/.local/bin:${PATH}"

# hermes 설정 디렉터리 (config.yaml/.env는 런타임에 마운트하거나 secret으로 주입)
#   ~/.hermes/config.yaml  ← config.example.yaml 참고
#   ~/.hermes/.env         ← API 키 (이미지에 굽지 않는다)
RUN mkdir -p /home/agent/.hermes

# 기본 진입점: 대화형 TUI. 무인 실행 시 CMD를 hermes 실행 커맨드로 교체.
# 확인 필요: 실제 CLI 진입 명령(예: `hermes`, `hermes run`).
CMD ["bash"]

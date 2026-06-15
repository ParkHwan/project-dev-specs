# Suggested Commands

> 실행 위치는 repo 루트(`project-dev-specs` = `.../Project_Specification_Enhancement`).

## 탐색
* `rg --files` / `grep -rn "패턴" docs` : 파일·패턴 검색.

## 게이트 / 정합성 검사
* **플레이스홀더 게이트**(Build-Ready, 매칭 0이어야 통과):
  `grep -rInE 'TODO|TBD|FIXME|XXX|\[[^]]*\]|\{[^}]*\}|example\.com|YYYY-MM-DD' docs | grep -v 'gate:ignore'`
* **번호 헤딩 재유입 검사**(0이어야 함): `grep -rnE '^#{2,6} [0-9]' docs`
* **숫자 앵커 링크 검사**(0이어야 함): `grep -rnoE '\]\([^)]*#[0-9]' docs`
* **그래프 노드 ↔ 스킬 디렉터리 일치**:
  `diff <(awk '/^nodes:/{f=1;next}/^edges:/{f=0}f&&/^  - /{gsub(/^  - /,"");print}' skills/skill_graph.yaml|sort) <(ls -d skills/*/|sed 's#skills/##;s#/##'|sort)`
* **링크 실재 검증**: 각 문서 `dirname` 기준으로 `]( ... .md)` 상대경로가 존재하는지 확인.

## Git
* 변경 후: `git add -A && git commit && git push origin main` (커밋 메시지 끝에 Co-Authored-By 라인).
* 원격: `origin` = https://github.com/ParkHwan/project-dev-specs (브랜치 `main`).

## Diagram
* 미리보기: [Mermaid Live](https://mermaid.live/) 또는 GitHub 렌더.

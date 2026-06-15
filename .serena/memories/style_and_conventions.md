# Styles and Conventions

## Documentation Style
* **Language**: 한국어 우선, 기술 용어는 영어 병기.
* **Format**: GitHub Flavored Markdown (GFM).
* **Tone**: 전문적·지시적.
* **SoT**: 모듈형 `docs/`가 단일 진실 출처. 수정은 항상 여기서 → 필요 시 `archive/`의 영문본 동기화. `archive/`(monolith·EN·reviews)는 직접 수정 금지.

## Heading / Section IDs
* **글로벌 섹션 번호 금지**: 헤딩은 설명형(예: `## 기술 스택 요약`). 과거 `6.6`/`8.7` 같은 하드코딩 번호는 비번호화로 제거됨(반복 충돌의 근본 원인이었음).
* 문서 간 참조는 **번호가 아니라 섹션명/파일 링크**로 한다.
* 각 도메인 문서 H1 아래 메타데이터 헤더: `> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]` (허브·ADR 템플릿 제외).

## Paths / Links
* 스킬·그래프·템플릿의 문서 참조는 **repo 루트 상대경로**(`docs/...`, `BUILD_SPEC_TEMPLATE.md`). `Project_Specification_Enhancement/`·`Development_Project_Guide/` 접두어 금지.
* `docs/` 내부 문서 간 링크는 상대(`./`, `../`). 가능하면 **양방향**(강결합 짝은 서로 링크).

## Naming / Placeholders
* 템플릿 플레이스홀더: `[브래킷]` 또는 `{예시}`. 게이트는 실제 프로젝트에 채운 사본에 적용(템플릿 자체는 통과 대상 아님).

## Diagramming
* **Tool**: Mermaid. flowchart/sequence/erd/gantt/quadrant. 계층=`TB`, 흐름=`LR`.

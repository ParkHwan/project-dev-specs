# 📚 Appendix & References

---

## A. Architecture Decision Records (ADR)

> 💡 **작성 가이드**: 중요한 기술 결정을 기록합니다. ADR은 하위 폴더 [`adr/`](./adr/)에 파일로 누적합니다.

- 템플릿: [`adr/ADR-000-template.md`](./adr/ADR-000-template.md)
- 새 결정은 `adr/ADR-00N-<slug>.md`로 복사해 작성하고, 번호는 1부터 순차 증가합니다.
- 기존 결정은 수정하지 않고 새 ADR로 대체(Superseded)하며 상호 링크합니다.

| ADR | 제목 | 상태 |
|-----|------|------|
| [ADR-000](./adr/ADR-000-template.md) | 템플릿 | - |

---

## A-2. 문서 동기화 정책 (한/영)

- **원본(Source of Truth)**: 한국어 모듈형 `docs/` (이 트리).
- **파생본**: `archive/PROJECT_SPECIFICATION.monolith.md`(monolith, deprecated), `archive/PROJECT_SPECIFICATION_EN.md`(영문 번역, stale).
- **규칙**: 모든 내용 변경은 한국어 원본을 먼저 수정한다. 영문본은 원본 변경 후 동기화하며, 상단에 "마지막 원본 동기화일 / 기준 원본 버전"을 갱신한다.
- **검증**: 릴리스 전 한/영 버전·동기화일이 일치하는지 확인한다.

---

## B. 참고 자료
- [Google API Design Guide](https://cloud.google.com/apis/design)
- [Google SRE Book](https://sre.google/sre-book/table-of-contents/)
- [Microsoft SDL](https://www.microsoft.com/en-us/securityengineering/sdl)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [memsearch (GitHub)](https://github.com/zilliztech/memsearch)
- [memsearch (Documentation)](https://zilliztech.github.io/memsearch/)
- [Milvus Documentation](https://milvus.io/docs)

---

## C. 관련 문서 링크
| 문서 | 위치 | 설명 |
|------|------|------|
| API 문서 | [링크] | OpenAPI 스펙 |
| 운영 플레이북 | [링크] | 장애 대응 가이드 |
| 온보딩 가이드 | [링크] | 신규 팀원 가이드 |

---

## D. Mermaid 다이어그램 가이드
본 템플릿에서 사용된 다이어그램 문법:
- Flowchart: `flowchart TB/LR`
- Sequence: `sequenceDiagram`
- ERD: `erDiagram`
- Gantt: `gantt`
- Quadrant: `quadrantChart`

---

## 🔗 관련 문서
- [전체 명세서 허브 (Hub)](../PROJECT_SPECIFICATION.md)
- [로드맵 및 마일스톤](../07_risk_roadmap/roadmap.md)
- [Agent Long-term Memory (memsearch)](../03_data/memsearch_memory.md)

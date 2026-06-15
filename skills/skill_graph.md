# Development Project Skill Graph

## Root

- Root Spec: `BUILD_SPEC_TEMPLATE.md`
- Root Skill: `build-spec-gate`

## Graph (Mermaid)

```mermaid
flowchart TD
    A[build-spec-gate] --> B[requirements-problem-goals]
    A --> C[requirements-stakeholders]
    A --> D[requirements-functional]
    A --> E[requirements-non-functional]

    C --> D

    B --> F[architecture-tech-stack]
    D --> F
    E --> F

    F --> G[architecture-system-design]
    G --> H[architecture-deployment]

    D --> I[data-model]
    I --> J[data-migration]
    I --> W[data-pipeline]
    I --> V[agent-memory-memsearch]

    D --> K[api-guidelines]
    K --> L[api-endpoints]
    I --> L
    K --> V

    E --> M[security-spec]
    E --> N[engineering-testing-strategy]
    D --> O[engineering-coding-style]

    D --> X[ux-ui-spec]
    E --> X
    X --> N

    G --> P[operations-observability]
    W --> P
    H --> Q[operations-deployment-release]
    P --> Q
    H --> Y[operations-iac]
    Y --> Q
    H --> Z[operations-cost-management]
    Y --> Z

    M --> R[risk-management]
    N --> R
    Q --> R
    V --> R
    W --> R
    Z --> R

    R --> S[roadmap]
    S --> T[glossary]
    T --> U[appendix-references]

    Q --> AO[agent-operating-model]
    V --> AO
    AO --> LG[agent-loop-memory-governance]
```

> `agent-operating-model` → `agent-loop-memory-governance`는 명세를 **에이전트가 실행하는 방법**(반자율 운영)을 정의하는 실행 레이어다. 명세 완성(위 그래프) 이후 적용한다.

## Execution Order (Recommended)

1. `build-spec-gate`
2. `requirements-*`
3. `architecture-*`
4. `data-*` (`data-model` -> `data-migration` / `data-pipeline`) + `api-*`
5. `agent-memory-memsearch`
6. `engineering-*` + `ux-ui-spec` + `security-spec`
7. `operations-*` (`observability` / `deployment-release` / `iac` / `cost-management`)
8. `risk-management` -> `roadmap` -> `glossary` -> `appendix-references`
9. (실행 레이어) `agent-operating-model` -> `agent-loop-memory-governance` — 명세 완성 후, 에이전트 반자율 실행 규칙 적용

# 🏗️ System Design

> 💡 **작성 가이드**: 시스템 구조를 다양한 관점에서 시각화합니다. (C4 Model 권장)

---

## 6.1 High-Level Architecture

> 💡 **작성 가이드**: 전체 시스템의 주요 구성요소와 외부 시스템 연동을 표현합니다.

```mermaid
flowchart TB
    subgraph External["External Systems"]
        Client["Client<br/>(Web/Mobile/API)"]
        ExtService1["External Service 1"]
        ExtService2["External Service 2"]
    end

    subgraph Gateway["API Gateway Layer"]
        LB["Load Balancer"]
        WAF["WAF / Rate Limiter"]
    end

    subgraph Application["Application Layer"]
        API["API Server"]
        Worker["Background Worker"]
        Scheduler["Scheduler"]
    end

    subgraph Data["Data Layer"]
        DB[(Primary DB)]
        Cache[(Cache)]
        Queue[(Message Queue)]
        Storage[(Object Storage)]
        Memory[(memsearch + Milvus)]
    end

    subgraph Monitoring["Observability"]
        Logs["Logging"]
        Metrics["Metrics"]
        Traces["Tracing"]
    end

    Client --> LB
    ExtService1 --> LB
    LB --> WAF --> API
    
    API --> DB
    API --> Cache
    API --> Queue
    API --> Memory
    
    Queue --> Worker
    Scheduler --> Worker
    Worker --> DB
    Worker --> Storage
    Worker --> Memory
    
    API --> ExtService2
    
    Application --> Monitoring
```

---

## 6.2 Component Diagram

> 💡 **작성 가이드**: 애플리케이션 내부의 레이어/모듈 구조를 표현합니다.

```mermaid
flowchart TB
    subgraph Presentation["Presentation Layer"]
        Controllers["Controllers / Routers"]
        Middleware["Middleware<br/>(Auth, Logging, Error)"]
    end

    subgraph Application["Application Layer"]
        Services["Services<br/>(Business Logic)"]
        UseCases["Use Cases"]
    end

    subgraph Domain["Domain Layer"]
        Entities["Entities / Models"]
        ValueObjects["Value Objects"]
        DomainServices["Domain Services"]
    end

    subgraph Infrastructure["Infrastructure Layer"]
        Repositories["Repositories"]
        ExternalClients["External API Clients"]
        Adapters["Adapters"]
    end

    subgraph External["External"]
        Database[(Database)]
        ExternalAPI["External APIs"]
        MessageQueue[(Message Queue)]
    end

    Controllers --> Middleware --> Services
    Services --> UseCases --> Entities
    UseCases --> DomainServices
    
    Services --> Repositories
    Services --> ExternalClients
    
    Repositories --> Database
    ExternalClients --> ExternalAPI
    Adapters --> MessageQueue
```

---

## 6.3 Data Flow Diagram

> 💡 **작성 가이드**: 주요 데이터의 흐름을 시퀀스 또는 플로우차트로 표현합니다.

#### 6.3.1 주요 플로우 (Flowchart)
```mermaid
flowchart LR
    A["1. 요청 수신"] --> B["2. 인증/인가"]
    B --> C["3. 데이터 검증"]
    C --> D["4. 비즈니스 로직"]
    D --> E["5. 데이터 저장"]
    E --> F["6. 응답 반환"]
    
    C -->|실패| G["에러 응답"]
    B -->|실패| G
```

#### 6.3.2 상세 시퀀스 (Sequence Diagram)
```mermaid
sequenceDiagram
    autonumber
    participant Client
    participant API as API Server
    participant Auth as Auth Service
    participant DB as Database
    participant Cache as Cache
    participant External as External API

    Client->>API: Request
    API->>Auth: Validate Token
    Auth-->>API: Token Valid
    
    API->>Cache: Check Cache
    alt Cache Hit
        Cache-->>API: Cached Data
    else Cache Miss
        API->>DB: Query Data
        DB-->>API: Data
        API->>Cache: Store in Cache
    end
    
    opt External Call Needed
        API->>External: External Request
        External-->>API: External Response
    end
    
    API-->>Client: Response
```

---

## 🔗 관련 문서
- [배포 아키텍처 (Deployment)](./deployment_arch.md)
- [기술 스택 요약 (Tech Stack)](./tech_stack.md)
- [데이터 모델 (Data Model)](../03_data/data_model.md)
- [Agent Long-term Memory (memsearch)](../03_data/memsearch_memory.md)

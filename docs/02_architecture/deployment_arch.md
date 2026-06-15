# 🚀 Deployment Architecture

> **Last Updated**: [YYYY-MM-DD] | **Status**: Draft | **Owner**: [담당자]

> 💡 **작성 가이드**: 인프라 배포 구조를 표현합니다.

---

## Cloud Deployment Architecture

```mermaid
flowchart TB
    subgraph Internet["Internet"]
        Users["Users"]
        CDN["CDN"]
    end

    subgraph Cloud["Cloud Provider"]
        subgraph Network["VPC / Network"]
            subgraph Public["Public Subnet"]
                LB["Load Balancer"]
                NAT["NAT Gateway"]
            end
            
            subgraph Private["Private Subnet"]
                subgraph Compute["Compute"]
                    App1["App Instance 1"]
                    App2["App Instance 2"]
                    Worker["Worker"]
                end
                
                subgraph DataStores["Data Stores"]
                    RDS[(RDS / Cloud SQL)]
                    ElastiCache[(Redis)]
                    S3[(Object Storage)]
                end
            end
        end
        
        subgraph Managed["Managed Services"]
            SQS["Message Queue"]
            Secrets["Secret Manager"]
            KMS["KMS"]
        end
    end

    Users --> CDN --> LB
    LB --> App1 & App2
    App1 & App2 --> RDS
    App1 & App2 --> ElastiCache
    App1 & App2 --> SQS
    SQS --> Worker
    Worker --> S3
    Compute --> Secrets
    Compute --> NAT --> Internet
```

---

## Kubernetes Deployment (Optional)

```mermaid
flowchart TB
    subgraph K8s["Kubernetes Cluster"]
        subgraph Ingress["Ingress"]
            IngressController["Ingress Controller"]
        end
        
        subgraph Namespace["Application Namespace"]
            subgraph Deployments["Deployments"]
                API["API Pods<br/>(replicas: 3)"]
                Worker["Worker Pods<br/>(replicas: 2)"]
            end
            
            subgraph Services["Services"]
                APISvc["API Service"]
                WorkerSvc["Worker Service"]
            end
            
            subgraph Config["Configuration"]
                ConfigMap["ConfigMap"]
                Secret["Secret"]
            end
        end
        
        subgraph Monitoring["Monitoring Namespace"]
            Prometheus["Prometheus"]
            Grafana["Grafana"]
        end
    end

    IngressController --> APISvc --> API
    WorkerSvc --> Worker
    API --> ConfigMap & Secret
    Worker --> ConfigMap & Secret
    API & Worker --> Prometheus --> Grafana
```

---

## 🔗 관련 문서
- [시스템 디자인 (System Design)](./system_design.md)
- [기술 스택 요약 (Tech Stack)](./tech_stack.md)
- [비용 관리 (FinOps)](../06_operations/cost_management.md)
- [Infrastructure as Code](../06_operations/infrastructure_as_code.md)

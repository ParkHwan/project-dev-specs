---
name: operations-iac
description: Define Infrastructure as Code tooling, environment separation, change workflow, and drift control.
---

# Operations IaC Skill

- Source Spec: `docs/06_operations/infrastructure_as_code.md`
- Upstream: `architecture-deployment`
- Downstream: `operations-deployment-release`, `operations-cost-management`

## Workflow
1. Choose IaC tool, remote state backend, and managed scope (exceptions noted).
2. Separate environments and keep secrets out of code.
3. Define plan→review→apply(CI-only) workflow and drift detection.
4. Align naming/tagging with cost-management policy.

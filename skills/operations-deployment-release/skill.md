---
name: operations-deployment-release
description: Execute deployment strategy, release controls, rollback, and runbook readiness.
---

# Operations Deployment Release Skill

- Source Spec: `docs/06_operations/deployment_release.md`
- Upstream: `architecture-deployment`, `operations-observability`
- Downstream: `risk-management`

## Workflow
1. Define release strategy (canary/rolling/blue-green).
2. Set rollback triggers and operational checks.
3. Validate required environment variables and secrets.
4. Output production release runbook.


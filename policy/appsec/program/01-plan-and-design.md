# Application security program — Phase 01: Plan and design

**Policy alignment:** Satisfies controls **A1, A2, B1, B2** — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Next: [Phase 02 — Build and commit](02-build-and-commit.md)

## Objective

Build security in before code is written by defining requirements, architecture controls, and risk decisions early.

## OWASP SAMM mapping

- **Primary SAMM functions:** Governance, Design
- **Primary SAMM practices:**
  - Governance: Strategy and Metrics, Policy and Compliance
  - Design: Threat Assessment, Security Requirements, Secure Architecture
- **Secondary SAMM practices:** Governance — Education and Guidance

## Scope

- New services and major feature designs
- Architecture changes with security impact
- Third-party dependency introduction

## Core activities

- Define security requirements by service type
- Perform threat modeling for high-risk flows
- Map trust boundaries and data classification
- Run architecture security review before implementation

## Reference controls

This phase is **process- and artifact-driven** (no mandatory CI scanners). Evidence includes registry metadata, threat models, design reviews, and recorded risks—mapped in [Policy evidence mapping](../framework/policy-evidence-mapping.yaml) (`AS-DES-*`, registry fields).

## Suggested tooling

- **Threat modeling**
  - **Default:** [Catalog lite](../templates/threat-model-catalog-lite.md) + [schema](../templates/threat-model-catalog-schema.yaml)
  - **Optional depth:** [Full threat model template](../templates/threat-model-template-full.md) (diagrams; Threat Dragon export via URL only)
- **Requirement baselines:** OWASP ASVS; NIST SSDF mapping; [data classification](../templates/data-classification-scheme.md); [risk tier rubric](../templates/risk-tier-rubric.md)
- **Workflow and review:** GitHub/Jira security design review templates; [PR security checklist](../templates/pr-security-checklist.md)
- **Decision tracking:** [ADR template](../templates/adr-template.md) with a **Security implications** section

## Minimum viable process

- One threat model per critical feature (catalog lite in registry)
- Security requirements in ticket acceptance criteria
- Security review required for auth or data-boundary changes
- Risks tracked in an issue board with owner and due date

## Common pitfalls

- Treating threat modeling as a one-time exercise
- Missing trust boundary updates after architecture changes
- No clear owner for accepted risks

## Inputs

- Architecture diagram or service boundaries
- Data classification and critical user flows
- Third-party dependency list

## Outputs

- Threat model artifact
- Security requirements checklist
- Design review outcome (approved / changes required)
- Recorded risks and exceptions with expiry

## Success metrics

- % high-risk features with threat model completed
- Median time to complete design security review
- # unresolved design-phase risks older than SLA

## Adoption paths

Choose a path by organizational size and regulatory pressure. Both paths use the [standard forms](../templates/) above.

### Minimum viable (fast to adopt)

- **Threat modeling:** [Catalog lite](../templates/threat-model-catalog-lite.md) in the application registry (STRIDE six-pack + trust boundaries; optional `diagram_url`). STRIDE-lite per critical feature is enough—**Threat Dragon is not required** for baseline compliance.
- **Security requirements:** OWASP ASVS (selected controls per app type); short security acceptance criteria in tickets or PRs.
- **Design review:** Issue template for security design review; [PR security checklist](../templates/pr-security-checklist.md) when boundaries change.
- **Decision tracking:** [ADR template](../templates/adr-template.md) with **Security implications**.
- **Risk tracking:** Lightweight risk register (spreadsheet or issue board).

### Scaled (larger teams or regulated context)

- **Threat modeling:** Threat Dragon or equivalent at scale; catalog lite metadata in inventory with linked diagrams.
- **Architecture governance:** Security architecture review board; **mandatory design gate** for high-risk systems before implementation.
- **Standards mapping:** ASVS + NIST SSDF mapped to the [policy baseline](../framework/appsec-policy-baseline.md).
- **Risk and exceptions:** [Exception request form](../templates/exception-request-form.md) with owner, expiry, compensating controls, audit links.
- **Third-party review:** OpenSSF Scorecard or deps.dev when adopting new dependencies or vendors.

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| Threat modeling and data-flow diagrams | OWASP Threat Dragon, Draw.io, Mermaid (URL in catalog lite when used) |
| Requirements and standards | OWASP ASVS, NIST SSDF, internal secure-design checklist |
| Workflow and governance | GitHub Issues/Projects, Jira, Linear |
| Decision and traceability | ADR markdown in the service repository |
| Risk register and exceptions | Issue templates + policy-driven labels/statuses |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | Threat model + PR checklist + ADR templates; minimum security criteria per service type |
| **60 days** | Risk register and exception templates; monthly design review for high-risk changes; ASVS mapping started |
| **90 days** | Architecture sign-off for critical systems; planning KPIs; artifacts linked to [release sign-off](../templates/release-sign-off-checklist.md) |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Next:** [Phase 02 — Build and commit](02-build-and-commit.md)

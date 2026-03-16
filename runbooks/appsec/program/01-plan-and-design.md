# AppSec Program: 01 Plan and Design

## Objective
Build security in before code is written by defining requirements, architecture controls, and risk decisions early.

## OWASP SAMM Mapping
- Primary SAMM functions:
  - Governance
  - Design
- Primary SAMM practices:
  - Governance: Strategy and Metrics, Policy and Compliance
  - Design: Threat Assessment, Security Requirements, Secure Architecture
- Secondary SAMM practice:
  - Governance: Education and Guidance

## Scope
- New services and major feature designs
- Architecture changes with security impact
- Third-party dependency introduction

## Core Activities
- Define security requirements by service type
- Perform threat modeling for high-risk flows
- Map trust boundaries and data classification
- Run architecture security review before implementation

## Suggested Tooling
- Threat modeling and diagrams:
  - OWASP Threat Dragon
  - Draw.io / Mermaid diagrams in-repo
- Requirement baselines:
  - OWASP ASVS
  - NIST SSDF mapping
- Workflow and review:
  - GitHub/Jira security design review templates
  - PR-level security impact checklist
- Decision tracking:
  - ADRs with "Security Implications" section

## Minimum Viable Process
- Create one threat model per critical feature
- Capture security requirements in ticket acceptance criteria
- Require security review for auth/data boundary changes
- Track risks in an issue board with owner and due date

## Common Pitfalls
- Treating threat modeling as a one-time exercise
- Missing trust boundary updates after architecture changes
- No clear owner for accepted risks

## Inputs
- Architecture diagram / service boundaries
- Data classification and critical user flows
- Third-party dependency list

## Outputs
- Threat model artifact
- Security requirements checklist
- Design review outcome (approved/changes required)
- Recorded risks and exceptions with expiry

## Success Metrics
- % high-risk features with threat model completed
- Median time to complete design security review
- # unresolved design-phase risks older than SLA

## Next Related Step
- `runbooks/appsec/program/02-build-and-commit.md`

# Framework Reference: OWASP SAMM

## Purpose
Provide a practical, local reference to OWASP SAMM so this repo's runbooks can be aligned to a recognized AppSec maturity framework.

This document is a working guide, not an official SAMM specification.

## What OWASP SAMM Is
OWASP SAMM (Software Assurance Maturity Model) is a framework for:
- assessing current AppSec maturity
- setting target maturity by business context
- planning incremental improvements

It is intentionally flexible so teams can adapt practices to their stack, risk profile, and delivery model.

## How SAMM Fits This Repo
- SAMM answers: "What capabilities should we mature?"
- This repo answers: "How do we implement and operate those capabilities?"

Use both together:
1. assess with SAMM,
2. prioritize gaps,
3. implement via runbooks and program phase docs in this repo.
4. track progress using `runbooks/appsec/program/samm-coverage-checklist.md`.
5. enforce policy controls using:
   - `runbooks/appsec/framework/appsec-policy-baseline.md`
   - `runbooks/appsec/framework/policy-evidence-mapping.yaml`

## SAMM Building Blocks (Practical View)

### Business Functions
SAMM groups practices into major areas:
- Governance
- Design
- Implementation
- Verification
- Operations

### Practices and Streams
Each function includes practices, and each practice has streams of activities that can be incrementally adopted.

### Maturity Levels
Typical progression:
- Level 1: foundational and repeatable basics
- Level 2: structured and consistently applied
- Level 3: measured, optimized, and broadly institutionalized

## Suggested SAMM Assessment Workflow

### 1) Establish Baseline
- Score current maturity by practice/stream
- Capture evidence from existing controls and reports

### 2) Set Target State
- Define target maturity by domain/service criticality
- Avoid one-size-fits-all targets

### 3) Build Improvement Plan
- Select a small number of high-impact gaps per quarter
- Assign owner, timeline, dependencies, and success metric

### 4) Execute and Reassess
- Implement improvements via runbooks and process updates
- Re-score periodically (for example quarterly)

## Example Mapping to Repo Phase Docs
- Governance + Design:
  - `01-plan-and-design.md`
  - `06-improve-and-govern.md`
- Implementation:
  - `02-build-and-commit.md`
- Verification:
  - `03-ci-gate.md`
  - scanner runbooks in `runbooks/appsec/`
- Operations:
  - `04-release-and-deploy.md`
  - `05-runtime-and-operate.md`

## Common Misuse Patterns
- Treating SAMM as a checklist to complete once
- Optimizing score without improving real risk outcomes
- Applying the same maturity target to all systems regardless of risk
- Running assessments without execution ownership

## Recommended Adoption Pattern for This Repo
- Keep `appsec-program-full-circle.md` as program strategy + backlog
- Keep phase docs as operating playbooks
- Use `samm-coverage-checklist.md` as the maturity tracking worksheet
- Use SAMM assessment snapshots to prioritize what to build next
- Review progress quarterly with explicit maturity and risk outcomes

## Notes
- For authoritative definitions and updates, refer to official OWASP SAMM materials.
- Keep this document concise and implementation-focused for local program use.

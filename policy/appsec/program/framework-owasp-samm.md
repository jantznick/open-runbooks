# Framework Reference: OWASP SAMM

## Purpose

Practical local reference to OWASP SAMM so the **application security program** can align maturity measurement with day-to-day operations.

This document is a **working guide**, not the official SAMM specification.

**Glossary:** Shared terms—[`../glossary.md`](../glossary.md).

## What OWASP SAMM Is
OWASP SAMM (Software Assurance Maturity Model) is a framework for:
- assessing current AppSec maturity
- setting target maturity by business context
- planning incremental improvements

It is intentionally flexible so teams can adapt practices to their stack, risk profile, and delivery model.

## How SAMM fits this program

- SAMM answers: "What capabilities should we mature?"
- This program answers: "How do we implement and operate those capabilities?"

Use both together:

1. Assess with SAMM.
2. Prioritize gaps.
3. Implement using phase playbooks and approved CI jobs.
4. Track progress using [`samm-coverage-checklist.md`](samm-coverage-checklist.md).
5. Enforce policy controls using:
   - [`../framework/appsec-policy-baseline.md`](../framework/appsec-policy-baseline.md)
   - [`../framework/severity-policy.yaml`](../framework/severity-policy.yaml)
   - [`../framework/policy-evidence-mapping.yaml`](../framework/policy-evidence-mapping.yaml)

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

## Example mapping to phase documents
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

## Recommended operating pattern

- Use [`../appsec-program-full-circle.md`](../appsec-program-full-circle.md) for lifecycle overview; [`implementation-master-checklist.md`](implementation-master-checklist.md) and [known gaps](../README.md#known-gaps-and-roadmap) for backlog.
- Use phase docs as operating playbooks.
- Use [`samm-coverage-checklist.md`](samm-coverage-checklist.md) as the maturity worksheet.
- Use SAMM assessments to choose the next concrete improvements.
- Review quarterly with explicit risk and maturity outcomes.

## Notes

- For authoritative SAMM definitions, use official OWASP SAMM materials.
- Keep this reference concise and aligned to your internal program.

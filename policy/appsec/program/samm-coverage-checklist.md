# OWASP SAMM Coverage Checklist (Working Template)

## Purpose
Track current and target SAMM coverage using practical, auditable checklist items tied to this repository.

Use this with:
- `runbooks/appsec/program/framework-owasp-samm.md`
- `runbooks/appsec/appsec-program-full-circle.md`

## How to Use
- Mark status for each checklist item:
  - `[ ]` not started
  - `[~]` in progress
  - `[x]` implemented
- Add owner, target quarter, and evidence link.
- Reassess quarterly.

## Current Maturity Reality Check
This repository provides strong implementation patterns, but does not by itself prove full SAMM completion across all functions and maturity levels.

In most teams, this content maps to:
- partial-to-strong Level 1 coverage in multiple practices
- selective Level 2 in areas with established process/evidence
- limited Level 3 without broad metrics/governance institutionalization

## Checklist by SAMM Function

### Governance
- [ ] Strategy and Metrics baseline defined (owner, KPIs, quarterly review)
  - Owner:
  - Target:
  - Evidence:
- [ ] Policy and Compliance controls documented and approved
  - Owner:
  - Target:
  - Evidence:
- [ ] Education and Guidance program active (training paths + champions)
  - Owner:
  - Target:
  - Evidence:
- [ ] Exception workflow enforced (expiry + compensating controls)
  - Owner:
  - Target:
  - Evidence:

### Design
- [ ] Threat modeling required for high-risk changes
  - Owner:
  - Target:
  - Evidence:
- [ ] Security requirements baseline adopted (for example ASVS mapping)
  - Owner:
  - Target:
  - Evidence:
- [ ] Secure architecture review gate operating for critical systems
  - Owner:
  - Target:
  - Evidence:

### Implementation
- [ ] Secure coding standards documented per stack
  - Owner:
  - Target:
  - Evidence:
- [ ] Dependency governance process (new package review + policy)
  - Owner:
  - Target:
  - Evidence:
- [ ] Build/deploy hardening controls defined and tested
  - Owner:
  - Target:
  - Evidence:
- [ ] Defect management workflow integrated with engineering tracking
  - Owner:
  - Target:
  - Evidence:

### Verification
- [ ] Required CI security gates enforced (SAST, secrets, SCA, DAST baseline)
  - Owner:
  - Target:
  - Evidence:
- [ ] Severity policy standardized across scanners
  - Owner:
  - Target:
  - Evidence:
- [ ] Evidence/artifact retention policy implemented
  - Owner:
  - Target:
  - Evidence:
- [ ] Validation quality process for false positives/tuning
  - Owner:
  - Target:
  - Evidence:

### Operations
- [ ] Release-time security checks for artifact + image + config
  - Owner:
  - Target:
  - Evidence:
- [ ] Runtime monitoring and incident response playbooks in use
  - Owner:
  - Target:
  - Evidence:
- [ ] Scheduled post-deploy scanning cadence established
  - Owner:
  - Target:
  - Evidence:
- [ ] Feedback loop from incidents into preventive controls
  - Owner:
  - Target:
  - Evidence:

## What Is Typically Still Needed for Fuller SAMM Coverage

### Process and Governance Depth
- Formal policy ownership and review cadence
- Standardized control evidence model
- Executive-level risk reporting and measurable targets

### Operational Maturity
- Production incident handling tied directly to AppSec controls
- Runtime posture management and drift response
- Defined SLAs and exception governance at org scale

### Consistent Measurement
- Maturity scoring per SAMM practice/stream
- Quarterly re-assessment with trend analysis
- Evidence-backed progression from foundational to managed/optimized levels

### Organizational Enablement
- Role-based secure development training
- Security champions coverage across teams
- Clear RACI model for AppSec responsibilities

## Suggested Next Step
Create a baseline scorecard from this checklist and attach evidence links for each checked item.

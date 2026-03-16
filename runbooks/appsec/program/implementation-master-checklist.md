# AppSec Program Implementation Master Checklist

## Purpose
Provide one execution tracker for implementing and customizing all AppSec program documents and controls in this repository.

Use this as the project plan for rollout across teams and organizations.

## How to Use
- Set a status for each item:
  - `[ ]` not started
  - `[~]` in progress
  - `[x]` completed
- Fill owner, target date, and evidence links.
- Review weekly during rollout; review monthly after stabilization.

## Program Metadata
- Program owner:
- AppSec lead:
- Platform/DevEx lead:
- Governance lead:
- Start date:
- Target v1 completion date:

## Workstream A: Foundation and Scope
- [ ] Confirm canonical doc structure and ownership
  - Owner:
  - Target:
  - Evidence:
- [ ] Define in-scope application types and exclusions
  - Owner:
  - Target:
  - Evidence:
- [ ] Define risk tiers and classification model
  - Owner:
  - Target:
  - Evidence:
- [ ] Define RACI by phase (`01`-`06`)
  - Owner:
  - Target:
  - Evidence:

## Workstream B: Policy and Control Layer
- [ ] Customize `framework/appsec-policy-baseline.md` to organization policy language
  - Owner:
  - Target:
  - Evidence:
- [ ] Lock mandatory vs recommended controls by risk tier
  - Owner:
  - Target:
  - Evidence:
- [ ] Finalize severity thresholds and fail criteria
  - Owner:
  - Target:
  - Evidence:
- [ ] Finalize exception process (approval, expiry, compensating controls)
  - Owner:
  - Target:
  - Evidence:

## Workstream C: Evidence and Metadata Integration
- [ ] Map policy controls to metadata schema in `framework/policy-evidence-mapping.yaml`
  - Owner:
  - Target:
  - Evidence:
- [ ] Validate required metadata fields exist in application registry/platform
  - Owner:
  - Target:
  - Evidence:
- [ ] Define evidence sources for each control (job IDs, artifacts, release records)
  - Owner:
  - Target:
  - Evidence:
- [ ] Validate pass criteria logic against real application data
  - Owner:
  - Target:
  - Evidence:

## Workstream D: Phase-Doc Customization (`01`-`06`)

### 01 Plan and Design
- [ ] Add org-specific process flow
- [ ] Add entry/exit criteria
- [ ] Add required artifacts
- [ ] Add escalation path
- [ ] Add KPIs and review cadence

### 02 Build and Commit
- [ ] Add secure coding standards references
- [ ] Add PR checklist and required fields
- [ ] Add developer workflow and ownership
- [ ] Add KPI targets

### 03 CI Gate
- [ ] Add required controls by profile
- [ ] Add blocking vs informational policy
- [ ] Add artifact retention requirements
- [ ] Add SLA and exception handling details

### 04 Release and Deploy
- [ ] Add release security bundle requirements
- [ ] Add SBOM/image/IaC expectations by profile
- [ ] Add release sign-off criteria

### 05 Runtime and Operate
- [ ] Add scheduled re-scan frequencies by risk tier
- [ ] Add incident response integration details
- [ ] Add runtime ownership and escalation model

### 06 Improve and Govern
- [ ] Add monthly/quarterly governance review format
- [ ] Add exception and policy audit cadence
- [ ] Add scorecard template references

For each phase section above, record:
- Owner:
- Target:
- Evidence:

## Workstream E: Technical Control Rollout
- [ ] Implement required CI controls in baseline profile:
  - SAST
  - Secrets
  - SCA
  - DAST baseline
  - DAST template layer
  - Owner:
  - Target:
  - Evidence:
- [ ] Define optional/non-blocking controls:
  - deep active DAST
  - unstable/environment-sensitive scans
  - Owner:
  - Target:
  - Evidence:
- [ ] Standardize artifact naming and storage
  - Owner:
  - Target:
  - Evidence:
- [ ] Standardize scanner env var contracts and defaults
  - Owner:
  - Target:
  - Evidence:

## Workstream F: Pilot and Calibration
- [ ] Select pilot applications (at least low/medium/high risk)
  - Owner:
  - Target:
  - Evidence:
- [ ] Execute pilot against all required controls
  - Owner:
  - Target:
  - Evidence:
- [ ] Record tuning changes (false positives, thresholds, exceptions)
  - Owner:
  - Target:
  - Evidence:
- [ ] Sign off v1 baseline after pilot review
  - Owner:
  - Target:
  - Evidence:

## Workstream G: SAMM Alignment and Maturity
- [ ] Complete initial `samm-coverage-checklist.md` with owners and evidence
  - Owner:
  - Target:
  - Evidence:
- [ ] Define target maturity levels by SAMM function/practice
  - Owner:
  - Target:
  - Evidence:
- [ ] Define quarterly reassessment schedule
  - Owner:
  - Target:
  - Evidence:

## Workstream H: Program Operations
- [ ] Launch recurring operating cadence (weekly delivery, monthly governance)
  - Owner:
  - Target:
  - Evidence:
- [ ] Publish KPI dashboard/report format
  - Owner:
  - Target:
  - Evidence:
- [ ] Implement exception expiry monitoring
  - Owner:
  - Target:
  - Evidence:
- [ ] Define annual policy review process
  - Owner:
  - Target:
  - Evidence:

## v1 Completion Criteria
- [ ] Policy baseline approved and published
- [ ] Evidence mapping integrated with metadata platform
- [ ] Phase docs customized with ownership, artifacts, and cadence
- [ ] Required controls active for target profile
- [ ] Pilot complete and tuning decisions documented
- [ ] SAMM checklist baseline scored with evidence links

## Backlog for v2+
- [ ] IaC runbook
- [ ] Container image runbook
- [ ] SBOM/provenance runbook
- [ ] Runtime posture playbooks
- [ ] Training and champions rollout package

# AppSec Policy Baseline — Controls only (minified)

Normative **requirements** and **actions** only. For scope, roles, definitions, metadata registry, evidence tables, severity examples, retention, and Layer 2 mapping, see [`appsec-policy-baseline.md`](appsec-policy-baseline.md).

---

## A: Governance and inventory

### A1: Application metadata maintained
- **Requirement:** Application metadata MUST be maintained (owner, criticality, data classification, internet exposure, repository, CI pipeline).
- **Actions:**
  1. Register the application in the approved catalog or registry before first production release.
  2. Update metadata within **[e.g. 5]** business days of ownership, repo, exposure, or data-classification changes.
  3. Ensure CI evidence can be correlated to the app (repo, branch, pipeline identifiers).

### A2: Risk tier and review cadence
- **Requirement:** Each application MUST have a risk tier (`low`, `medium`, `high`) and review cadence.
- **Actions:**
  1. Assign tier using a documented rubric (data sensitivity, exposure, business impact, regulatory scope).
  2. Re-evaluate tier at least **[quarterly / annually]** or after major architecture or data-flow changes.
  3. Record tier in the registry; use it to select severity thresholds and required assessments.

---

## B: Plan and design

### B1: Security requirements for new and high-impact work
- **Requirement:** Security requirements MUST be defined for new services and high-impact changes.
- **Actions:**
  1. Before implementation, capture security requirements in work-tracking (epic/feature) or design doc: authN/Z model, sensitive data flows, trust boundaries, and relevant ASVS or internal control objectives.
  2. For regulated or high-tier apps, reference your org’s minimum ASVS level or control set.
  3. Block or escalate “start build” if requirements are missing for scoped work (process is org-specific).

### B2: Threat modeling for internet-facing and high-risk features
- **Requirement:** Threat modeling MUST be performed for internet-facing and high-risk features.
- **Actions:**
  1. Produce a lightweight model (e.g. data-flow diagram + STRIDE notes) covering trust boundaries and critical flows.
  2. Link mitigations to tickets or designs.
  3. Revisit when boundaries change (new integrations, auth changes, new data classes).

---

## C: Build and commit

### C1: Secure coding standards
- **Requirement:** Teams MUST follow secure coding standards for their language and framework.
- **Actions:**
  1. Adopt published secure coding guidelines (internal or OWASP language guides).
  2. Use dependency and secret hygiene aligned with **Secrets detection in CI** and **Software composition analysis (SCA)**.
  3. Train new developers on injection, auth, session management, and secret handling within **[e.g. 90 days]** of repo access.

### C2: Security impact on pull requests
- **Requirement:** Pull requests MUST include security-impact review checklist responses.
- **Actions:**
  1. Use a PR template or bot that asks: security impact (yes/no), data/auth boundary touched, new dependencies, config/secrets changed, need for AppSec consult.
  2. Reviewers verify checklist accuracy; escalate “yes” impacts per rubric.

---

## D: CI verification (minimum required gate)

### D1: Static application security testing (SAST)
- **Requirement:** SAST MUST run on pull requests and default branch.
- **Actions:**
  1. Run SAST on every PR and on default branch builds (or equivalent trunk policy).
  2. Store reports as CI artifacts with retention per the full baseline **Evidence retention** section.
  3. Remediate or triage per **Findings triage and closure** and **Enforce severity thresholds**.

### D2: Secrets detection in CI
- **Requirement:** Secrets scan MUST run on pull requests and default branch.
- **Actions:**
  1. Run a secrets scanner (entropy + known patterns) on the same events as **SAST**.
  2. Block commits or builds on high-confidence findings unless rotated and exception approved.
  3. Never merge verified live secrets—revoke and rotate first.

### D3: Software composition analysis (SCA)
- **Requirement:** SCA / dependency vulnerability scan MUST run on pull requests and default branch.
- **Actions:**
  1. Run SCA on PR and default branch (lockfiles or equivalent).
  2. Upgrade or justify vulnerable dependencies per severity policy.
  3. Separate SCA from SAST in evidence if your tools are distinct (both may live in one pipeline with two report types).

### D4: Baseline dynamic testing (DAST)
- **Requirement:** Baseline DAST MUST run for internet-facing applications before production release.
- **Actions:**
  1. Define a stable staging or test URL representative of production.
  2. Run baseline DAST before production release and on a schedule agreed with **Scheduled re-scanning (internet-facing)**.
  3. Record target URL and environment with evidence.

### D5: Enforce severity thresholds
- **Requirement:** Builds MUST fail on policy-defined severity thresholds (unless approved exception exists).
- **Actions:**
  1. Publish a severity matrix by risk tier (see full baseline **Baseline severity policy**).
  2. Configure pipelines to fail on blocker findings.
  3. Route exceptions through **Exception content and approval** and record exception reference in CI or release notes when used.

---

## E: Release and deploy

### E1: Release security evidence
- **Requirement:** Release artifacts MUST have security scan evidence attached to the release record.
- **Actions:**
  1. Attach or link latest SAST, secrets, SCA results; attach DAST when **Baseline dynamic testing (DAST)** applies.
  2. Include build/version identifiers so evidence maps to deployed bits.
  3. Store in release system, artifact store, or catalog per Layer 2.

### E2: Container and IaC scanning (SHOULD)
- **Requirement:** Container / IaC scanning SHOULD be enforced for deployable workloads.
- **Actions:**
  1. Scan images and IaC in CI or registry gate.
  2. Fail or warn per org policy on critical misconfigurations.
  3. Plan promotion to MUST if your org standardizes on containers.

### E3: SBOM for production (SHOULD)
- **Requirement:** SBOM generation SHOULD be enabled for production releases.
- **Actions:**
  1. Generate SBOM in SPDX or CycloneDX (or org standard) per release.
  2. Store with release artifact.
  3. Use for incident response and license/supply-chain review.

---

## F: Runtime and operations

### F1: Scheduled re-scanning (internet-facing)
- **Requirement:** Internet-facing applications MUST have scheduled security re-scans.
- **Actions:**
  1. Run DAST and/or other agreed tests on a schedule (e.g. weekly/monthly) independent of feature releases.
  2. Track drift when staging does not match production—document compensating monitoring if needed.

### F2: Findings triage and closure
- **Requirement:** Security findings MUST be triaged and tracked to closure with SLA targets.
- **Actions:**
  1. Create tickets for blocker/high findings within **[e.g. 1–2]** business days.
  2. Apply SLAs by severity and risk tier (define table internally).
  3. Record closure or exception before SLA breach escalation.

---

## Exceptions and risk acceptance

### Exception content and approval
- **Requirement:** Policy exceptions MUST include business justification, compensating controls, owner, and expiry date.
- **Actions:**
  1. File exception before relying on bypass in production path.
  2. Document compensating control (monitoring, manual review, time-bound waiver).
  3. Set expiry; no “indefinite” without executive policy.

### Expired exceptions
- **Requirement:** Expired exceptions MUST be re-approved or remediated before next release.
- **Actions:**
  1. Block release or fail pipeline if exception expired (automate if possible).
  2. Either remediate the underlying issue, renew exception with new review, or remove the bypass.

---

*Same normative content as the full baseline; omitting “Applies to,” “Primary owner,” “Evidence,” and “Done when” rows. Automation mapping: [`policy-evidence-mapping.yaml`](policy-evidence-mapping.yaml).*

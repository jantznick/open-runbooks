# Full-Circle AppSec Program (Draft)

## Goal
Define a practical end-to-end application security program that can start simple, run in CI/CD, and mature over time without blocking delivery.

This document captures:
- what is already implemented in this repo
- what each tool is good at
- known limitations/downfalls
- missing controls we should add next

## Framework Positioning (OWASP SAMM)
This repository does not replace OWASP SAMM. It implements the local "how" while SAMM provides the external maturity reference for the "what good looks like."

- OWASP SAMM:
  - maturity model, benchmark, and planning framework
- This repo:
  - practical runbooks, control implementations, and operating workflows

Use SAMM to assess and prioritize maturity improvements. Use these docs/runbooks to execute those improvements.

Policy-driven implementation references:
- `runbooks/appsec/framework/appsec-policy-baseline.md`
- `runbooks/appsec/framework/policy-evidence-mapping.yaml`
- `runbooks/appsec/program/implementation-master-checklist.md`

## Program Outcomes
- Prevent high-risk vulnerabilities from reaching production
- Detect issues early in developer workflow and CI
- Reduce false positives and triage time
- Create repeatable, auditable security controls
- Track risk and remediation with clear ownership

## Full-Circle Lifecycle

### 1) Plan and Design
- Security requirements per app/service
- Threat modeling for critical flows (auth, payment, admin, data export)
- Data classification and trust boundary mapping
- Secure architecture review for major changes
- Detailed phase guide: `runbooks/appsec/program/01-plan-and-design.md`

## Plan and Design Tooling Options

### Minimum Viable Stack (Fast to Adopt)
- Threat modeling:
  - OWASP Threat Dragon or Draw.io/Mermaid diagrams in-repo
  - STRIDE-lite checklist per critical feature
- Security requirements baseline:
  - OWASP ASVS (selected controls per app type)
  - Simple "security acceptance criteria" section in tickets/PRs
- Design review workflow:
  - GitHub issue template: security design review
  - PR checklist with security-impact prompts
- Decision tracking:
  - Architecture Decision Records (ADRs) with a "Security Implications" section
- Risk tracking:
  - Lightweight risk register (spreadsheet or issue tracker board)

### Scaled Stack (Larger Teams / Regulated Context)
- Threat modeling platform:
  - Threat Dragon at scale, or equivalent enterprise threat modeling tooling
- Architecture governance:
  - Security architecture review board workflow
  - Mandatory design gate for high-risk systems
- Standards mapping:
  - OWASP ASVS + NIST SSDF mapping to internal policy controls
- Risk and exception management:
  - Formal exception workflow with owner, expiry, compensating controls
  - Audit-friendly evidence links to PRs, tickets, and reports
- Dependency and supplier review:
  - OpenSSF Scorecard/deps.dev checks in design phase for new third-party adoption

### Tooling by Planning Use Case
- Threat modeling and DFDs:
  - OWASP Threat Dragon, Draw.io, Mermaid
- Requirements and standards:
  - OWASP ASVS, NIST SSDF, internal secure design checklist
- Workflow and governance:
  - GitHub Issues/Projects, Jira, Linear
- Decision and traceability:
  - ADR markdown files in repo
- Risk register and exceptions:
  - Issue templates + policy-driven labels/statuses

### Suggested 30/60/90 Day Rollout
- 30 days:
  - Add threat model template + PR security checklist
  - Add ADR template with security section
  - Define minimum required security criteria per service
- 60 days:
  - Add risk register and exception workflow template
  - Start monthly design review for high-risk changes
  - Map controls to ASVS categories
- 90 days:
  - Formalize security architecture sign-off for critical systems
  - Track planning-phase KPIs (review SLA, exception age, open design risks)
  - Integrate planning artifacts into release readiness evidence

### 2) Build and Commit
- Secure coding standards and guardrails
- Pre-commit checks (optional, fast feedback)
- SAST and secrets scanning in pull requests
- Dependency policy checks (license + vulnerable packages)
- Detailed phase guide: `runbooks/appsec/program/02-build-and-commit.md`

### 3) CI Gate
- Required checks: SAST, secrets, SCA, baseline DAST
- Optional deeper checks: heavy/less stable DAST, full active scanning
- Artifact retention for reports and audit trails
- Severity-based fail policy with exceptions process
- Detailed phase guide: `runbooks/appsec/program/03-ci-gate.md`

### 4) Release and Deploy
- Container/image scanning
- IaC misconfiguration scanning
- SBOM generation and storage
- Provenance/attestation (where possible)
- Detailed phase guide: `runbooks/appsec/program/04-release-and-deploy.md`

### 5) Runtime and Operate
- Continuous external attack surface scanning
- Cloud/Kubernetes posture monitoring
- Runtime alerting and incident response playbooks
- Vulnerability SLAs and re-scan cadence
- Detailed phase guide: `runbooks/appsec/program/05-runtime-and-operate.md`

### 6) Improve and Govern
- Metrics and KPIs (MTTR, open high/critical, false-positive rate)
- Security champions and training
- Quarterly control review and tuning
- Exception review with expiry and ownership
- Detailed phase guide: `runbooks/appsec/program/06-improve-and-govern.md`

## OWASP SAMM Alignment (High-Level)
Reference explainer: `runbooks/appsec/program/framework-owasp-samm.md`

Mapping intent:
- Governance:
  - `01-plan-and-design.md`
  - `06-improve-and-govern.md`
- Design:
  - `01-plan-and-design.md`
- Implementation:
  - `02-build-and-commit.md`
- Verification:
  - `03-ci-gate.md`
  - scanner runbooks under `runbooks/appsec/`
- Operations:
  - `04-release-and-deploy.md`
  - `05-runtime-and-operate.md`

## Current Tooling in This Repo

### SAST
- Semgrep/OpenGrep: `sast-semgrep-opengrep-basic.sh`
- Strengths: fast, shift-left, catches code-level anti-patterns
- Downfalls:
  - rule quality determines signal quality
  - can miss logic flaws without custom rules
  - false positives need tuning

### Secrets
- TruffleHog: `secrets-trufflehog-basic.sh`
- Strengths: strong secret detector ecosystem, verified findings support
- Downfalls:
  - not all hardcoded strings are detected as secrets
  - detector behavior can vary by token format and verification capability

### SCA
- Trivy filesystem SCA: `sca-trivy-basic.sh`
- Strengths: simple, broad package ecosystem coverage, CI-friendly
- Downfalls:
  - vulnerability context/exploitability still needs triage
  - database freshness and ecosystem lockfile quality affect results

### DAST
- ZAP baseline/full: `dast-zap-basic.sh`
- Nuclei: `dast-nuclei-basic.sh`
- Dastardly: `dast-dastardly-basic.sh`
- Strengths:
  - validates externally observable issues
  - good complement to SAST/SCA
- Downfalls:
  - browser-driven scans can be unstable on some runners/platforms
  - baseline/template scans will not find every custom app logic issue
  - active/full scans can be noisy and slower

## What We Have Today (Coverage Snapshot)
- SAST: yes
- Secrets: yes
- SCA: yes
- DAST baseline: yes
- DAST deeper/active: partial (runtime stability depends on environment)
- Program governance documentation: now started (this doc)

## Known Gaps (Documented for Next Iterations)

### Governance and Process Gaps
- Threat modeling runbook/template
- Risk acceptance/exception workflow runbook
- Vulnerability triage and SLA matrix
- Security sign-off criteria per release type

### SDLC Control Gaps
- Pre-commit developer workflow docs
- Branch protection and required-check policy examples
- Severity policy standardization across scanners
- Centralized findings aggregation pattern

### Technical Coverage Gaps
- IaC scanning runbook (Terraform/Kubernetes)
- Container image scanning runbook
- SBOM generation + vulnerability correlation runbook
- API-specific DAST coverage (OpenAPI-driven)
- Custom Nuclei/ZAP rules for deterministic demo coverage

### Runtime and Operations Gaps
- External attack surface monitoring runbook
- Cloud posture scanning runbook
- Incident response and validation drill runbook
- Scheduled re-scan governance and reporting cadence

## Recommended Baseline Program (Current State)
- Required CI checks:
  - SAST (Semgrep/OpenGrep)
  - Secrets (TruffleHog)
  - SCA (Trivy)
  - DAST (ZAP baseline)
  - DAST (Nuclei)
- Optional/non-blocking:
  - ZAP full active scan
  - Dastardly (until runtime stability is proven in target runners)

## Suggested Next Milestones

### Milestone 1 (Short Term)
- Add IaC scanning runbook
- Add container image scan runbook
- Standardize severity gates in one policy table

### Milestone 2 (Mid Term)
- Add threat model template + review process
- Add exception workflow docs
- Add consolidated report index per pipeline run

### Milestone 3 (Longer Term)
- Add SBOM + provenance controls
- Add runtime posture and attack surface controls
- Add AppSec metrics dashboard and quarterly review cadence

## Notes
- No single scanner will detect all vulnerability classes.
- Defense-in-depth plus process maturity is the target state.
- Use this document as the master backlog for missing AppSec controls.

## Future Program Components (Beyond Dev-Focused Controls)
This repo is currently weighted toward developer and CI/CD controls. As the program matures, add complementary non-dev components:

- Developer training and enablement:
  - Secure coding training paths by role/language
  - Just-in-time training tied to common findings
  - Security champions program and office hours
- Governance and policy:
  - Security policy lifecycle and standards ownership
  - Exception governance with approvals and expiry
  - Annual control reviews and audit readiness
- Incident readiness:
  - AppSec-specific incident response playbooks
  - Tabletop exercises and post-incident control updates
- Third-party and supply chain risk:
  - Vendor/security review workflow
  - OSS adoption policy and ongoing dependency health checks
- Identity and access program alignment:
  - Secure SDLC access model, secrets management ownership, privileged access review
- Executive reporting and culture:
  - KPI/OKR reporting to leadership
  - Communication cadence for risk posture and remediation progress

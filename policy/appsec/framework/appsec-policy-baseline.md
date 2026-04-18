# AppSec Policy Baseline (Template)

## Purpose
This is a reusable, policy-driven app sec baseline for development teams. This baseline is a minimum level of application security intended to be enhanced upon based on specific applications level of data collection and handling.

When your organization publishes this document, **Corporate Security** owns the authoritative text: **corporate policy** (this baseline, once customized and approved by legal/GRC) states what **operating companies and engineering teams must implement**. Teams may add **stricter** local rules; weaker thresholds require the corporate **exception** process.

Each control below includes a **short requirement** (MUST/SHOULD) plus **actionable guidance**: who acts, what to do, what “good” looks like, and where evidence is described in Layer 2.

**Quick reference:** Minified requirements and actions only (no tables)—[`appsec-policy-baseline-minified.md`](appsec-policy-baseline-minified.md).

**Optional extensions:** Recommendations by context (PII, health, payments, SaaS, AI, etc.)—[`appsec-policy-baseline-contextual-enhancements.md`](appsec-policy-baseline-contextual-enhancements.md).

## Reference Standards
This policy is aligned to commonly accepted best practices:
- OWASP SAMM (maturity and practice model)
- OWASP ASVS (application security verification baseline)
- NIST SSDF (secure software development framework)

## Scope
- All internally developed applications and APIs
- All production-bound code repositories and release pipelines
- All environments containing customer, regulated, or sensitive data

## Roles and accountability

| Role | Accountable for |
|------|-----------------|
| **Engineering teams** | Accurate registry metadata, secure implementation, running required CI jobs, remediating findings, requesting exceptions with technical detail. |
| **AppSec / security engineering** | Publishing standards and thresholds, triage support, approving or escalating exceptions, verifying evidence design, tuning false-positive handling. |
| **Product / business owners** | Prioritizing remediation within business constraints, approving residual risk when an exception is required, naming owners for production services. |
| **Platform / DevEx (if applicable)** | Supplying approved CI templates, secrets managers, and artifact retention so teams can comply without one-off pipelines. |

Escalation path and ticketing system are organization-specific—document yours in an internal appendix or runbook.

## Definitions
- **Application:** A deployable unit with its own lifecycle, repository(ies), and business purpose.
- **Production release:** A change promoted to an environment used by end users of the application.
- **High-impact change:** Changes to authentication, authorization, data handling, trust boundaries, or public exposure.
- **Approved exception:** Time-bound, documented deviation from a MUST control with owner, business justification, and expiry—see **Exception content and approval** below.
- **Risk tier:** `low` | `medium` | `high` drives scan strictness, review depth, and SLA expectations—see **Risk tier and review cadence** below.

## Control statements

### Governance and inventory

#### Metadata registry

**Required application fields** for inventory. At minimum, engineering MUST keep the following current for every in-scope application.:

| Field | What to record |
|-------|----------------|
| `app_id` / `app_name` | Stable identifier and display name. |
| `business_owner` | Accountable product or P&L owner. |
| `engineering_owner` | Primary engineering contact for security and releases. |
| `risk_tier` | `low` / `medium` / `high` per org criteria. |
| `data_classification` | e.g. public, internal, confidential, regulated (use your scheme). |
| `internet_facing` | Whether untrusted networks can reach the app or its APIs. |
| `repo_url` | Canonical source repository. |
| `default_branch` | Branch policy gates apply to. |
| `ci_provider` | Where CI runs (for evidence correlation). |

Optional fields (`runtime_environment`, `auth_model`, `compliance_tags`, `customer_data_types`) SHOULD be filled when they affect control applicability (e.g. DAST target, compliance scope).

#### Application metadata maintained
**Requirement:** Application metadata MUST be maintained (owner, criticality, data classification, internet exposure, repository, CI pipeline).

| | |
|--|--|
| **Applies to** | Every in-scope application. |
| **Primary owner** | Engineering (data); AppSec may define required fields. |
| **Actions** | (1) Register the application in the approved catalog or registry before first production release. (2) Update metadata within **[e.g. 5]** business days of ownership, repo, exposure, or data-classification changes. (3) Ensure CI evidence can be correlated to the app (repo, branch, pipeline identifiers). |
| **Evidence** | Layer 2: `application_registry_record`; required metadata fields non-empty. |
| **Done when** | All Layer 2 required fields are present and reviewed as part of **Risk tier and review cadence**. |

#### Risk tier and review cadence
**Requirement:** Each application MUST have a risk tier (`low`, `medium`, `high`) and review cadence.

| | |
|--|--|
| **Applies to** | Every in-scope application. |
| **Primary owner** | Business + engineering (propose); AppSec (challenge/align to org rubric). |
| **Actions** | (1) Assign tier using a documented rubric (data sensitivity, exposure, business impact, regulatory scope). (2) Re-evaluate tier at least **[quarterly / annually]** or after major architecture or data-flow changes. (3) Record tier in the registry; use it to select severity thresholds and required assessments. |
| **Evidence** | Registry field `risk_tier`; change history or review ticket for tier updates. |
| **Done when** | No in-scope app lacks a tier; stale tiers are flagged by your governance process. |

---

### Plan and design

#### Security requirements for new and high-impact work
**Requirement:** Security requirements MUST be defined for new services and high-impact changes.

| | |
|--|--|
| **Applies to** | New applications; greenfield services; high-impact changes (see Definitions). |
| **Primary owner** | Engineering + product; AppSec consults on sensitive patterns. |
| **Actions** | (1) Before implementation, capture security requirements in work-tracking (epic/feature) or design doc: authN/Z model, sensitive data flows, trust boundaries, and relevant ASVS or internal control objectives. (2) For regulated or high-tier apps, reference your org’s minimum ASVS level or control set. (3) Block or escalate “start build” if requirements are missing for scoped work (process is org-specific). |
| **Evidence** | Design doc, ticket fields, ADR, or security requirements section linked to the release. |
| **Done when** | Reviewers can find agreed requirements for the scoped change before merge to default branch or before release (pick the gate your org enforces). |

#### Threat modeling for internet-facing and high-risk features
**Requirement:** Threat modeling MUST be performed for internet-facing and high-risk features.

| | |
|--|--|
| **Applies to** | `internet_facing == true` OR `risk_tier` in (`medium`, `high`) for the relevant scope—align with Layer 2 `applies_when` for automation. |
| **Primary owner** | Engineering; AppSec may facilitate or review. |
| **Actions** | (1) Produce a lightweight model (e.g. data-flow diagram + STRIDE notes) covering trust boundaries and critical flows. (2) Link mitigations to tickets or designs. (3) Revisit when boundaries change (new integrations, auth changes, new data classes). |
| **Evidence** | Layer 2: `threat_model_document`, `design_review_record`; approval recorded per org process. |
| **Done when** | Layer 2 pass criteria met for the release scope: approved threat model on file for the change being released. |

---

### Build and commit

#### Secure coding standards
**Requirement:** Teams MUST follow secure coding standards for their language and framework.

| | |
|--|--|
| **Applies to** | All contributors to in-scope repositories. |
| **Primary owner** | Engineering leads; AppSec maintains org baseline. |
| **Actions** | (1) Adopt published secure coding guidelines (internal or OWASP language guides). (2) Use dependency and secret hygiene aligned with **Secrets detection in CI** and **Software composition analysis (SCA)**. (3) Train new developers on injection, auth, session management, and secret handling within **[e.g. 90 days]** of repo access. |
| **Evidence** | Published standard + training completion or acknowledgment where tracked. |
| **Done when** | Teams can cite the applicable standard; audits sample PRs against it. |

#### Security impact on pull requests
**Requirement:** Pull requests MUST include security-impact review checklist responses.

| | |
|--|--|
| **Applies to** | Pull requests as defined by your org (e.g. all PRs, or PRs touching security-sensitive paths). |
| **Primary owner** | Author + reviewer. |
| **Actions** | (1) Use a PR template or bot that asks: security impact (yes/no), data/auth boundary touched, new dependencies, config/secrets changed, need for AppSec consult. (2) Reviewers verify checklist accuracy; escalate “yes” impacts per rubric. |
| **Evidence** | PR body or check run stored with repository history. |
| **Done when** | No merged PR in scope lacks completed checklist (or documented exception). |

---

### CI verification (minimum required gate)

#### Static application security testing (SAST)
**Requirement:** SAST MUST run on pull requests and default branch.

| | |
|--|--|
| **Applies to** | All in-scope repositories producing application code. |
| **Primary owner** | Engineering; platform may provide template jobs. |
| **Actions** | (1) Run SAST on every PR and on default branch builds (or equivalent trunk policy). (2) Store reports as CI artifacts with retention per **Evidence Retention** below. (3) Remediate or triage per **Findings triage and closure** and **Enforce severity thresholds**. |
| **Evidence** | Layer 2: `ci_job_result:sast`, `sast_artifact`. |
| **Done when** | Job ran on required events; results meet pass criteria unless an **approved exception** applies. |

#### Secrets detection in CI
**Requirement:** Secrets scan MUST run on pull requests and default branch.

| | |
|--|--|
| **Applies to** | All in-scope repositories (including IaC repos if in scope). |
| **Primary owner** | Engineering. |
| **Actions** | (1) Run a secrets scanner (entropy + known patterns) on the same events as **SAST**. (2) Block commits or builds on high-confidence findings unless rotated and exception approved. (3) Never merge verified live secrets—revoke and rotate first. |
| **Evidence** | Layer 2: `ci_job_result:secrets`, `secrets_artifact`. |
| **Done when** | Scan runs on required events; policy violations are not silently ignored. |

#### Software composition analysis (SCA)
**Requirement:** SCA / dependency vulnerability scan MUST run on pull requests and default branch.

| | |
|--|--|
| **Applies to** | Repositories with third-party or internal package dependencies. |
| **Primary owner** | Engineering. |
| **Actions** | (1) Run SCA on PR and default branch (lockfiles or equivalent). (2) Upgrade or justify vulnerable dependencies per severity policy. (3) Separate SCA from SAST in evidence if your tools are distinct (both may live in one pipeline with two report types). |
| **Evidence** | Layer 2: `ci_job_result:sca`, `sca_artifact`. |
| **Done when** | Dependencies scanned on required events; gates per **Enforce severity thresholds**. |

#### Baseline dynamic testing (DAST)
**Requirement:** Baseline DAST MUST run for internet-facing applications before production release.

| | |
|--|--|
| **Applies to** | Applications with `internet_facing == true` (see Layer 2). |
| **Primary owner** | Engineering; AppSec may define scan profile. |
| **Actions** | (1) Define a stable staging or test URL representative of production. (2) Run baseline DAST before production release and on a schedule agreed with **Scheduled re-scanning (internet-facing)**. (3) Record target URL and environment with evidence. |
| **Evidence** | Layer 2: `ci_job_result:dast`, `dast_artifact`, `target_url_record`. |
| **Done when** | DAST executed against approved target; results triaged per **Findings triage and closure** and gates per **Enforce severity thresholds**. |

#### Enforce severity thresholds
**Requirement:** Builds MUST fail on policy-defined severity thresholds (unless approved exception exists).

| | |
|--|--|
| **Applies to** | All gated scan types (SAST, secrets, SCA, DAST as enabled). |
| **Primary owner** | AppSec defines defaults; engineering implements in CI. |
| **Actions** | (1) Publish a severity matrix by risk tier (see **Baseline Severity Policy**). (2) Configure pipelines to fail on blocker findings. (3) Route exceptions through **Exception content and approval** and record exception reference in CI or release notes when used. |
| **Evidence** | Layer 2: `policy_threshold_config`, `ci_enforcement_record`, optional `exception_record`. |
| **Done when** | No production release bypasses documented gates without an active approved exception. |

---

### Release and deploy

#### Release security evidence
**Requirement:** Release artifacts MUST have security scan evidence attached to the release record.

| | |
|--|--|
| **Applies to** | Every production release (or your defined release type). |
| **Primary owner** | Engineering (attach); release tooling may automate. |
| **Actions** | (1) Attach or link latest SAST, secrets, SCA results; attach DAST when **Baseline dynamic testing (DAST)** applies. (2) Include build/version identifiers so evidence maps to deployed bits. (3) Store in release system, artifact store, or catalog per Layer 2. |
| **Evidence** | Layer 2: `release_security_bundle`, `artifact_links`. |
| **Done when** | Release record contains required links; auditors can trace evidence to version. |

#### Container and IaC scanning (SHOULD)
**Requirement:** Container / IaC scanning SHOULD be enforced for deployable workloads.

| | |
|--|--|
| **Applies to** | Teams shipping containers or infrastructure-as-code that defines production posture. |
| **Primary owner** | Engineering + platform. |
| **Actions** | (1) Scan images and IaC in CI or registry gate. (2) Fail or warn per org policy on critical misconfigurations. (3) Plan promotion to MUST if your org standardizes on containers. |
| **Evidence** | CI job results, registry scan reports, or policy-as-code check results. |
| **Done when** | Documented in release evidence where applicable; path to MUST documented in roadmap. |

#### SBOM for production (SHOULD)
**Requirement:** SBOM generation SHOULD be enabled for production releases.

| | |
|--|--|
| **Applies to** | Applications with meaningful dependency trees. |
| **Primary owner** | Engineering + platform. |
| **Actions** | (1) Generate SBOM in SPDX or CycloneDX (or org standard) per release. (2) Store with release artifact. (3) Use for incident response and license/supply-chain review. |
| **Evidence** | SBOM artifact linked from release record. |
| **Done when** | SBOM available for sampled releases; expand coverage over time. |

---

### Runtime and operations

#### Scheduled re-scanning (internet-facing)
**Requirement:** Internet-facing applications MUST have scheduled security re-scans.

| | |
|--|--|
| **Applies to** | `internet_facing == true` applications. |
| **Primary owner** | Engineering schedules; AppSec may define frequency. |
| **Actions** | (1) Run DAST and/or other agreed tests on a schedule (e.g. weekly/monthly) independent of feature releases. (2) Track drift when staging does not match production—document compensating monitoring if needed. |
| **Evidence** | Scheduled job history, latest reports linked in registry or ops system. |
| **Done when** | Cadence documented and evidence shows scans within agreed window. |

#### Findings triage and closure
**Requirement:** Security findings MUST be triaged and tracked to closure with SLA targets.

| | |
|--|--|
| **Applies to** | All findings from mandated scans and critical manual findings. |
| **Primary owner** | Engineering (fix); AppSec (severity disputes, exceptions). |
| **Actions** | (1) Create tickets for blocker/high findings within **[e.g. 1–2]** business days. (2) Apply SLAs by severity and risk tier (define table internally). (3) Record closure or exception before SLA breach escalation. |
| **Evidence** | Layer 2: `ticket_reference`, `sla_state`, `closure_record`. |
| **Done when** | No untriaged critical/high findings past SLA without approved risk decision. |

---

### Exceptions and risk acceptance

#### Exception content and approval
**Requirement:** Policy exceptions MUST include business justification, compensating controls, owner, and expiry date.

| | |
|--|--|
| **Applies to** | Any deliberate bypass of a MUST in this baseline. |
| **Primary owner** | Requesting engineering + business owner; AppSec/approver per RACI. |
| **Actions** | (1) File exception before relying on bypass in production path. (2) Document compensating control (monitoring, manual review, time-bound waiver). (3) Set expiry; no “indefinite” without executive policy. |
| **Evidence** | Layer 2: `exception_request`, `compensating_controls`, `approval_record`, `expiry_date`. |
| **Done when** | Exception is approved, scoped to control + app/repo, and visible to auditors. |

#### Expired exceptions
**Requirement:** Expired exceptions MUST be re-approved or remediated before next release.

| | |
|--|--|
| **Applies to** | Any release attempted while a relied-on exception has expired. |
| **Primary owner** | Engineering + business owner. |
| **Actions** | (1) Block release or fail pipeline if exception expired (automate if possible). (2) Either remediate the underlying issue, renew exception with new review, or remove the bypass. |
| **Evidence** | Release checklist or CI gate showing exception validity; renewal ticket. |
| **Done when** | No release uses stale exceptions; compliance reports show zero expired-but-active waivers. |

---

## Baseline severity policy (template)
- **Blocker severities (default):** Critical, High  
- **Warning severities (default):** Medium  
- **Informational:** Low / Info  

Teams MAY adopt **stricter** thresholds by `risk_tier`. **Weaker** thresholds (e.g. not failing on High) require the **Exception content and approval** process with business sign-off.

**Example (customize):**

| Risk tier | Block merge on | Time to fix High (target SLA) |
|-----------|----------------|-------------------------------|
| High | Critical, High | **[e.g. 30 days]** |
| Medium | Critical, High (Medium warn) | **[e.g. 60 days]** |
| Low | Critical (High per exception) | **[e.g. 90 days]** |

---

## Evidence retention (template)
- CI scan artifacts: minimum **90 days** (or longer if compliance requires).  
- Release security evidence bundle: minimum **1 year**.  
- Exception records: retained through expiry plus **one** review cycle.  

---

## Review cadence
- **Quarterly:** Policy and control review with AppSec and engineering representatives; review false-positive rates and threshold fit.  
- **Ad hoc:** After major incidents, regulatory change, or material shift in threat model for critical apps.  

---

## Implementation note
Tool choice is **implementation detail**. Controls are **capability-based**: equivalent tools satisfy a requirement if they produce comparable evidence and meet the same pass criteria (document equivalents in Layer 2 or an internal tool matrix).

When integrating with an **AppSec catalog** or metadata platform, map registry fields and CI job types to this baseline. Extend `policy-evidence-mapping.yaml` when you add new automated checks or evidence types—keep YAML entries aligned with the **requirement titles** in this document (and with your parent cyber policy’s numbering scheme, if applicable).

# AppSec Policy Baseline (Template)

## Purpose
Define a reusable, policy-driven AppSec baseline for development teams.  
This is a normative policy template intended for adaptation by organization.

## Model (2 Layers)
- **Layer 1: Policy Controls (this document)**  
  Defines mandatory AppSec requirements.
- **Layer 2: Evidence and Governance Mapping**  
  See `runbooks/appsec/framework/policy-evidence-mapping.yaml` for metadata and evidence alignment.

## Reference Standards
This policy is aligned to commonly accepted best practices:
- OWASP SAMM (maturity and practice model)
- OWASP ASVS (application security verification baseline)
- NIST SSDF (secure software development framework)

## Scope
- All internally developed applications and APIs
- All production-bound code repositories and release pipelines
- All environments containing customer, regulated, or sensitive data

## Roles and Accountability
- **Engineering teams** implement and remediate controls in scope.
- **AppSec team** maintains standards, triage guidance, and exceptions.
- **Product/business owners** accept approved residual risk with expiry.

## Control Statements (Normative)

### Governance and Inventory
- `AS-POL-001` Application metadata MUST be maintained (owner, criticality, data classification, internet exposure, repository, CI pipeline).
- `AS-POL-002` Each application MUST have a risk tier (`low`, `medium`, `high`) and review cadence.

### Plan and Design
- `AS-DES-001` Security requirements MUST be defined for new services and high-impact changes.
- `AS-DES-002` Threat modeling MUST be performed for internet-facing and high-risk features.

### Build and Commit
- `AS-DEV-001` Teams MUST follow secure coding standards for their language and framework.
- `AS-DEV-002` Pull requests MUST include security-impact review checklist responses.

### CI Verification (Minimum Required Gate)
- `AS-CI-001` SAST scan MUST run on pull requests and default branch.
- `AS-CI-002` Secrets scan MUST run on pull requests and default branch.
- `AS-CI-003` SCA/dependency vulnerability scan MUST run on pull requests and default branch.
- `AS-CI-004` Baseline DAST MUST run for internet-facing applications before production release.
- `AS-CI-005` Builds MUST fail on policy-defined severity thresholds (unless approved exception exists).

### Release and Deploy
- `AS-REL-001` Release artifacts MUST have security scan evidence attached to release record.
- `AS-REL-002` Container/IaC scanning SHOULD be enforced for deployable workloads.
- `AS-REL-003` SBOM generation SHOULD be enabled for production releases.

### Runtime and Operations
- `AS-OPS-001` Internet-facing applications MUST have scheduled security re-scans.
- `AS-OPS-002` Security findings MUST be triaged and tracked to closure with SLA targets.

### Exceptions and Risk Acceptance
- `AS-GOV-001` Policy exceptions MUST include business justification, compensating controls, owner, and expiry date.
- `AS-GOV-002` Expired exceptions MUST be re-approved or remediated before next release.

## Baseline Severity Policy (Template)
- **Blocker severities (default):** Critical, High
- **Warning severities (default):** Medium
- **Informational:** Low/Info

Teams may adopt stricter thresholds by risk tier. Weaker thresholds require documented exception.

## Evidence Retention (Template)
- CI scan artifacts: minimum 90 days
- Release security evidence bundle: minimum 1 year
- Exception records: retained through expiry plus 1 review cycle

## Review Cadence
- Quarterly policy and control review by AppSec + engineering representatives
- Immediate update when major regulatory or threat model changes occur

## Implementation Note
Tool choice is implementation detail. Controls are capability-based and can be met with equivalent tools if evidence requirements are satisfied.

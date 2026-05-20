# Application security program — Phase 04: Release and deploy

**Policy alignment:** Satisfies **E1**; **D4** pre-release; **E2, E3** (SHOULD) on roadmap — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Previous: [Phase 03 — CI gate](03-ci-gate.md) · Next: [Phase 05 — Runtime and operate](05-runtime-and-operate.md)

## Objective

Ensure deployable artifacts and deployment configurations are security-validated before production.

## OWASP SAMM mapping

- **Primary SAMM functions:** Implementation, Operations
- **Primary SAMM practices:**
  - Implementation: Secure Deployment
  - Operations: Environment Management
- **Secondary SAMM practices:** Governance — Policy and Compliance; Verification — Security Testing

## Scope

- Container image builds and release artifacts
- Infrastructure and deployment manifests (IaC, Kubernetes, cloud templates)
- Release readiness, approvals, and promotion to production

## Core activities

- Scan release artifacts and container images
- Scan IaC and manifests for misconfigurations
- Generate and retain SBOMs where policy requires
- Apply release security sign-off criteria and link CI evidence

## Reference controls

Several **SHOULD** controls in this phase are on the program [roadmap](../README.md#known-gaps-and-roadmap) as first-class runbooks. Minimum today: **pre-release DAST** (Phase 03) plus **[release sign-off](../templates/release-sign-off-checklist.md)** with linked SAST/SCA/secrets (and DAST when applicable) artifacts.

| Control | Policy ID | Status in reference package |
|---------|-----------|------------------------------|
| Release sign-off | E1 | [Template](../templates/release-sign-off-checklist.md) |
| Pre-release DAST | D4 | [ZAP](../../runbooks/appsec/dast-zap-basic.md) · [Nuclei](../../runbooks/appsec/dast-nuclei-basic.md) |
| Container image scan | E2 (SHOULD) | Roadmap — Trivy image mode |
| IaC scan | E2 (SHOULD) | Roadmap — Trivy config, Checkov, tfsec |
| SBOM | E3 (SHOULD) | Roadmap — Syft, Trivy SBOM |

## Suggested tooling

- **Today:** Release pipeline reuses Phase 03 artifacts; [release sign-off checklist](../templates/release-sign-off-checklist.md); version/build IDs on all reports
- **Roadmap / scaled:** Trivy (image + config), Checkov, tfsec, Syft, OPA/Conftest, SLSA/provenance tooling where adopted

## Minimum viable process

- Every production release has a completed [release sign-off](../templates/release-sign-off-checklist.md)
- Latest SAST, secrets, SCA results attached or linked; DAST when internet-facing per baseline
- Critical/high release blockers are explicit and owned
- Build/version identifiers map evidence to deployed bits

## Common pitfalls

- Scanning source only but not the **release artifact** (image, bundle)
- Missing asset-version linkage in reports
- No ownership for release exceptions
- Treating SHOULD controls (SBOM, IaC) as satisfied without evidence

## Inputs

- Built artifacts and container images
- Deployment manifests and environment configuration
- Release version metadata and change record
- Phase 03 pipeline artifacts for the same commit/tag

## Outputs

- Release-time scan reports (as available)
- SBOM files (when required)
- Security release decision record (sign-off)

## Success metrics

- % releases with complete security evidence package
- # post-release vulnerabilities traceable to missing pre-release controls
- Time to produce audit evidence for a given release tag

## Adoption paths

### Minimum viable (fast to adopt)

- **Sign-off:** Mandatory [release sign-off checklist](../templates/release-sign-off-checklist.md) in release ticket or workflow.
- **Evidence:** Link Phase 03 artifacts (commit SHA, pipeline run ID); attach DAST for internet-facing apps.
- **Blockers:** Document critical/high criteria aligned with [severity policy](../framework/severity-policy.md).
- **Ownership:** Named approver (engineering + AppSec where required by tier).

### Scaled (larger teams or regulated context)

- **Artifact scanning:** Container image scan on every promoted image; fail on critical unmitigated CVEs per policy.
- **IaC:** Scan Terraform/Kubernetes/cloud manifests in release pipeline before apply.
- **Supply chain:** SBOM per release stored in artifact registry; optional provenance/attestation.
- **Policy:** OPA/Conftest gates on deployment labels, network policy, and privileged workloads.

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| Image vulnerability scan | Trivy, Grype, Clair, cloud-native scanner |
| IaC misconfiguration | Checkov, tfsec, Trivy config, cloud CSPM export |
| SBOM | Syft, CycloneDX tooling, Trivy SBOM |
| Release workflow | GitHub Releases, GitLab deploy tokens, Argo CD, Spinnaker |
| Sign-off and audit | Ticketing, change management, signed checklist in repo |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | Release sign-off template mandatory; evidence links to Phase 03 runs |
| **60 days** | Image scan in build pipeline for containerized apps; IaC scan pilot on one stack |
| **90 days** | SBOM stored per release for tier-2+; provenance pilot; release evidence audit drill |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Previous:** [Phase 03 — CI gate](03-ci-gate.md) · **Next:** [Phase 05 — Runtime and operate](05-runtime-and-operate.md)

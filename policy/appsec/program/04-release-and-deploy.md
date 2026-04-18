# AppSec Program: 04 Release and Deploy

## Objective
Ensure deployable artifacts and deployment configurations are security-validated before production.

## OWASP SAMM Mapping
- Primary SAMM functions:
  - Implementation
  - Operations
- Primary SAMM practices:
  - Implementation: Secure Deployment
  - Operations: Environment Management
- Secondary SAMM practices:
  - Governance: Policy and Compliance
  - Verification: Security Testing

## Scope
- Container image builds and releases
- Infrastructure and deployment manifests
- Release readiness and approvals

## Core Activities
- Scan release artifacts and images
- Scan IaC/manifests for misconfigurations
- Generate and retain SBOMs
- Apply release security sign-off criteria

## Suggested Tooling (Roadmap)
- Container image scanning: Trivy image mode
- IaC scanning: Trivy config / Checkov / tfsec
- SBOM generation: Syft, Trivy SBOM
- Policy checks: OPA/Conftest (optional)

## Minimum Viable Process
- Every release artifact has vulnerability scan evidence
- Critical/high release blockers are explicit
- SBOM generated and stored per release

## Common Pitfalls
- Scanning source only but not release artifact
- Missing asset-version linkage in reports
- No ownership for release exceptions

## Inputs
- Built artifacts/images
- Deployment manifests and environment configs
- Release version metadata

## Outputs
- Release-time scan reports
- SBOM files
- Security release decision record

## Success Metrics
- % releases with complete security evidence package
- # post-release vulns traceable to missing pre-release controls
- Time to produce audit evidence for a release

## Next Related Step
- `runbooks/appsec/program/05-runtime-and-operate.md`

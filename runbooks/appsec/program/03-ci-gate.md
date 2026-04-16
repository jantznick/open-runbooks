# AppSec Program: 03 CI Gate

## Objective
Provide deterministic, auditable security quality gates before merge/release progression.

## OWASP SAMM Mapping
- Primary SAMM functions:
  - Verification
  - Governance
- Primary SAMM practices:
  - Verification: Security Testing, Requirements-driven Testing
  - Governance: Policy and Compliance
- Secondary SAMM practices:
  - Implementation: Defect Management
  - Governance: Strategy and Metrics

## Scope
- Pull request CI pipelines
- Main branch and release candidate pipelines

## Core Activities
- Run required security checks with fail policies
- Store artifacts for audit and troubleshooting
- Apply severity thresholds and exception handling
- Separate required vs non-blocking deeper scans

## How controls land in service repositories

Scanner jobs in this program are implemented as **shell runbooks** plus optional **CI YAML** that invokes them from the repo root (`./runbooks/appsec/...`). **Corporate Security** provides these templates; **engineering teams copy** what **corporate policy** requires for their application tier into service repositories. The canonical checklist is [Using these runbooks in your own repository](../README.md#using-these-runbooks-in-your-own-repository). Where **Corporate Security** maintains an internal **golden repo**, teams may sync from that instead of pasting from the public catalog—see [Staying current with upstream runbooks](../README.md#staying-current-with-upstream-runbooks) (including divisional forks).

## Suggested Tooling in This Repo
- Required:
  - SAST (Semgrep/OpenGrep, or Snyk Code — `sast-snyk-code-basic.md`)
  - Secrets (TruffleHog)
  - SCA (Trivy, or Snyk Open Source — `sca-snyk-basic.md`)
  - DAST baseline (ZAP)
  - DAST template layer (Nuclei)
- Optional/non-blocking:
  - LLM-assisted PR security review (advisory narrative; not a substitute for scanners) — see `runbooks/appsec/pr-llm-security-review.md`
  - ZAP full
  - Dastardly (until runner stability is proven)

## Minimum Viable Process
- Required checks must pass for merge
- All scanners upload artifacts on success/failure
- Exception process documented with owner and expiry

## Common Pitfalls
- Treating unstable scans as required gates
- Inconsistent severity policies across tools
- No evidence retention for failed jobs

## Inputs
- Built application/test target endpoint
- Scanner configs, env vars, and policy thresholds

## Outputs
- Pipeline pass/fail status by control
- Security artifacts per run
- Triage tickets and exception records

## Success Metrics
- Gate reliability (false fail rate)
- % runs with full artifact availability
- % findings triaged within SLA

## Next Related Step
- `runbooks/appsec/program/04-release-and-deploy.md`

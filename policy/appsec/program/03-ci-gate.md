# Application security program — Phase 03: CI gate

**Policy alignment:** Satisfies **D1–D5, F2**; exceptions per **EX** — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Previous: [Phase 02 — Build and commit](02-build-and-commit.md) · Next: [Phase 04 — Release and deploy](04-release-and-deploy.md)

## Objective

Provide deterministic, auditable security quality gates before merge and release progression.

## OWASP SAMM mapping

- **Primary SAMM functions:** Verification, Governance
- **Primary SAMM practices:**
  - Verification: Security Testing, Requirements-driven Testing
  - Governance: Policy and Compliance
- **Secondary SAMM practices:** Implementation — Defect Management; Governance — Strategy and Metrics

## Scope

- Pull request CI pipelines
- Default branch and release-candidate pipelines
- Severity-based merge and promotion rules

## Core activities

- Run required security checks with fail policies per `risk_tier`
- Store artifacts for audit and troubleshooting
- Apply [severity thresholds](../framework/severity-policy.md) and exception handling
- Separate required vs non-blocking deeper scans

## Reference controls

Scanner jobs are **shell runbooks** plus **CI YAML** invoked from the repository root (`./runbooks/appsec/...`). **Corporate Security** publishes approved templates; teams install what policy requires per tier—see [CI integration](../README.md#using-these-runbooks-in-your-own-repository) and [Staying current](../README.md#staying-current-with-upstream-runbooks). Full job matrix: [Scanner runbooks and CI templates](../README.md#scanner-runbooks-and-ci-templates).

| Control | Policy IDs | Reference implementation |
|---------|------------|---------------------------|
| SAST | D1 | [Semgrep/OpenGrep](../../runbooks/appsec/sast-semgrep-opengrep-basic.md) · [Snyk Code](../../runbooks/appsec/sast-snyk-code-basic.md) |
| Secrets | D2 | [TruffleHog](../../runbooks/appsec/secrets-trufflehog-basic.md) |
| SCA | D3 | [Trivy](../../runbooks/appsec/sca-trivy-basic.md) · [Snyk Open Source](../../runbooks/appsec/sca-snyk-basic.md) |
| DAST baseline | D4 | [ZAP](../../runbooks/appsec/dast-zap-basic.md) |
| DAST templates | D4 | [Nuclei](../../runbooks/appsec/dast-nuclei-basic.md) |
| Severity gates | D5 | [severity-policy.md](../framework/severity-policy.md) · [severity-policy.yaml](../framework/severity-policy.yaml) |

## Suggested tooling

- **Required (typical tier):** SAST, secrets, SCA, DAST baseline (ZAP), DAST template layer (Nuclei)—per [policy baseline](../framework/appsec-policy-baseline.md) and app exposure
- **Optional / non-blocking:** [LLM-assisted PR review](../../runbooks/appsec/pr-llm-security-review.md) (advisory only); ZAP full active scan; Dastardly (until runner stability is proven)
- **Governance:** [Exception request form](../templates/exception-request-form.md); branch protection with required checks

## Minimum viable process

- Severity gates match application `risk_tier` per [severity policy](../framework/severity-policy.md)
- Required checks must pass for merge (or documented exception with expiry)
- All scanners upload artifacts on success **and** failure
- Exceptions recorded with owner, compensating controls, and expiry

## Common pitfalls

- Treating unstable scans as required merge gates
- Inconsistent severity mapping across tools
- No evidence retention for failed jobs
- Running DAST without a reachable test target (use `host.docker.internal` when app runs on host)

## Inputs

- Built application or test target endpoint
- Scanner configs, secrets, and policy thresholds
- Application metadata (`app_id`, `risk_tier`, exposure)

## Outputs

- Pipeline pass/fail status by control
- Security artifacts per run (SARIF, logs, reports)
- Triage tickets and exception records

## Success metrics

- Gate reliability (unplanned false-fail rate)
- % runs with complete artifact retention
- % findings triaged within SLA

## Adoption paths

### Minimum viable (fast to adopt)

- **Required jobs:** SAST + secrets + SCA on PR and default branch; DAST baseline for internet-facing apps.
- **Policy:** Wire fail thresholds to [severity-policy.yaml](../framework/severity-policy.yaml); block merge on policy violations without exception.
- **Evidence:** Upload artifacts every run; correlate to `app_id` in registry.
- **Exceptions:** [Exception form](../templates/exception-request-form.md) with expiry—no permanent waivers in CI.

### Scaled (larger teams or regulated context)

- **Pipeline design:** Separate fast PR stage vs nightly deep scan (ZAP full, extended Nuclei profiles).
- **Platform:** Central findings aggregation; managed scanners (Snyk, etc.) acceptable if evidence matches mapping YAML.
- **Governance:** Branch protection on default branch; release candidates re-run full gate set.
- **Advisory:** LLM PR review only where data-handling policy permits external models.

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| SAST | Semgrep, SonarQube, CodeQL, Snyk Code |
| Secrets | TruffleHog, Gitleaks, GitHub secret scanning |
| SCA | Trivy, Dependabot, Snyk Open Source |
| DAST | OWASP ZAP, Nuclei, Burp automation |
| Policy as code | OPA on pipeline metadata, custom gate scripts |
| Orchestration | GitHub Actions, GitLab CI, Jenkins, Azure Pipelines |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | SAST + secrets + SCA required; artifacts on every run; severity YAML wired |
| **60 days** | DAST baseline for internet-facing; branch protection; exception register live |
| **90 days** | Nuclei layer + optional deep scans; false-positive tuning review; gate reliability KPI |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Previous:** [Phase 02 — Build and commit](02-build-and-commit.md) · **Next:** [Phase 04 — Release and deploy](04-release-and-deploy.md)

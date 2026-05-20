# Application security program — Phase 02: Build and commit

**Policy alignment:** Satisfies **C1, C2**; supports **D1–D3** — see [Policy and process alignment](../policy-process-alignment.md#process-phase-to-policy).

**Navigation:** [Program overview](../appsec-program-full-circle.md) · Previous: [Phase 01 — Plan and design](01-plan-and-design.md) · Next: [Phase 03 — CI gate](03-ci-gate.md)

## Objective

Catch issues as early as possible in developer workflows before CI and release.

## OWASP SAMM mapping

- **Primary SAMM functions:** Implementation, Governance
- **Primary SAMM practices:**
  - Implementation: Secure Build, Defect Management
  - Governance: Education and Guidance
- **Secondary SAMM practices:** Governance — Policy and Compliance; Verification — Security Testing

## Scope

- Local development workflows
- Pull request creation and update cycle
- Dependency and package changes introduced on branches

## Core activities

- Apply secure coding standards
- Run lightweight checks pre-commit or pre-push (where appropriate)
- Execute SAST and secrets scanning on pull requests
- Enforce dependency policy for new packages

## Reference controls

**Corporate Security** publishes runnable jobs under `runbooks/appsec/` (shell scripts + CI templates). Engineering teams install them in service repositories per **corporate policy** and [CI integration](../README.md#using-these-runbooks-in-your-own-repository) (or an internal golden repository). This phase typically runs **SAST** and **secrets** on PRs; full gate enforcement is in [Phase 03](03-ci-gate.md).

| Control | Reference implementation |
|---------|---------------------------|
| SAST | [Semgrep/OpenGrep](../../runbooks/appsec/sast-semgrep-opengrep-basic.md) · [Snyk Code](../../runbooks/appsec/sast-snyk-code-basic.md) |
| Secrets | [TruffleHog](../../runbooks/appsec/secrets-trufflehog-basic.md) |

## Suggested tooling

- **SAST:** Semgrep/OpenGrep or Snyk Code (see reference table)
- **Secrets:** TruffleHog
- **Quality guardrails:** Linting, formatting, unit tests
- **Workflow hooks:** pre-commit, Husky, or CI-required checks on PR open/update
- **Standards:** [PR security checklist](../templates/pr-security-checklist.md); secure coding guidance tied to [severity policy](../framework/severity-policy.md)

## Minimum viable process

- PR template includes [PR security checklist](../templates/pr-security-checklist.md)
- Required PR checks: **SAST** and **secrets** (or equivalent managed tools with same evidence)
- New dependency additions require justification and owner
- Findings triaged with owner before merge (deferrals follow exception process)

## Common pitfalls

- Overly noisy rules causing alert fatigue
- Running heavy scans too early and slowing feedback
- No triage ownership for scanner findings
- Duplicating Phase 03 gates only on `main` while PRs stay unscoped

## Inputs

- Code changes in branch/PR
- Application `risk_tier` and scanner rule baselines
- Secure coding standards acknowledgment (where tracked)

## Outputs

- PR scan artifacts and findings
- Triage decisions (fix / suppress with ticket / defer with exception)
- Updated remediation issues linked to the PR

## Success metrics

- PR security check pass rate
- False-positive rate over time (by rule set)
- Median remediation time for PR-blocker findings

## Adoption paths

### Minimum viable (fast to adopt)

- **Developer workflow:** Optional pre-commit for secrets; mandatory PR checks for SAST + secrets.
- **Standards:** Link [secure coding](../framework/appsec-policy-baseline.md) expectations in PR template; use checklist for auth, crypto, and input-handling changes.
- **Dependencies:** Manual review for new packages; document in PR description.
- **Triage:** Engineering owner for each finding class; suppressions require ticket ID.

### Scaled (larger teams or regulated context)

- **Developer workflow:** Mandatory pre-commit/pre-push for secrets and formatting; IDE plugins aligned with SAST rulesets.
- **PR checks:** Add **SCA** on PR where policy requires early dependency signal (full enforcement still in Phase 03).
- **Training:** Just-in-time training links from top finding categories; champions office hours.
- **Governance:** Branch protection preview—required checks on PR before Phase 03 hardening.

### Tooling by use case

| Use case | Examples (tool-agnostic) |
|----------|---------------------------|
| Local fast feedback | pre-commit, Husky, git-secrets, IDE plugins |
| PR security checks | GitHub Actions, GitLab CI, Azure Pipelines |
| SAST | Semgrep, OpenGrep, SonarQube, Snyk Code |
| Secrets | TruffleHog, Gitleaks, platform secret scanning |
| Standards and checklist | PR template, [PR security checklist](../templates/pr-security-checklist.md) |

### Suggested rollout (30 / 60 / 90 days)

| Horizon | Focus |
|---------|--------|
| **30 days** | PR template + SAST + secrets on every PR; triage owner named per repo |
| **60 days** | Tune rules to reduce false positives; optional pre-commit; dependency justification enforced |
| **90 days** | SCA on PR for tier-2+ apps; training tied to top 5 finding types; metrics on PR remediation time |

---

**Navigation:** [Program overview](../appsec-program-full-circle.md) · **Previous:** [Phase 01 — Plan and design](01-plan-and-design.md) · **Next:** [Phase 03 — CI gate](03-ci-gate.md)

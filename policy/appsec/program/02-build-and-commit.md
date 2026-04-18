# AppSec Program: 02 Build and Commit

## Objective
Catch issues as early as possible in developer workflows before CI and release.

## OWASP SAMM Mapping
- Primary SAMM functions:
  - Implementation
  - Governance
- Primary SAMM practices:
  - Implementation: Secure Build, Defect Management
  - Governance: Education and Guidance
- Secondary SAMM practices:
  - Governance: Policy and Compliance
  - Verification: Security Testing

## Scope
- Local development workflows
- Pull request creation and update cycle

## Core Activities
- Apply secure coding standards
- Run lightweight checks pre-commit/pre-push
- Execute SAST and secrets scanning on PRs
- Enforce dependency policy for new packages

## Suggested Tooling
- SAST: Semgrep/OpenGrep
- Secrets: TruffleHog
- Quality guardrails: linting/formatting/test checks
- Workflow hooks: pre-commit, Husky, or CI-required checks

**Corporate Security** publishes runnable implementations under `runbooks/appsec/` (shell + CI templates). Engineering teams put them in service repositories per **corporate policy** and [Using these runbooks in your own repository](../README.md#using-these-runbooks-in-your-own-repository) (or your internal golden repo).

## Minimum Viable Process
- PR template includes security checklist
- Required PR checks:
  - SAST
  - Secrets
- New dependency additions require justification

## Common Pitfalls
- Overly noisy rules causing alert fatigue
- Running heavy scans too early and slowing feedback
- No triage ownership for scanner findings

## Inputs
- Code changes in branch/PR
- Current scanner rule/config baselines

## Outputs
- PR scan artifacts and findings
- Triage decisions (fix/suppress/defer)
- Updated issues for accepted remediation work

## Success Metrics
- PR scan pass rate
- False-positive rate over time
- Median remediation time for PR findings

## Next Related Step
- `runbooks/appsec/program/03-ci-gate.md`

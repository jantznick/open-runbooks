# Runbook: Basic SAST Scan with Semgrep/OpenGrep

## Purpose
Run a lightweight static application security test (SAST) in CI/CD using Semgrep-compatible rules.

## Standalone Runner (Recommended)
Use the executable runbook script:

- `runbooks/appsec/sast-semgrep-opengrep-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `returntocorp/semgrep:latest`
- no local Semgrep/OpenGrep installation requirements

## Scope
- Source code repositories for application services
- Fast, baseline security scanning in pull requests and main branch builds
- CI-friendly output artifacts

## When to Use
- New repository onboarding
- Pull request checks
- Scheduled security scans
- Before release candidates

## Preconditions
- Repository code is checked out
- CI runner has network access to pull Semgrep rules
- Docker is available in the runner

## Inputs
- `SAST_SCAN_PATH` (default `.`)
- `SAST_RULESET` (default `p/security-audit`)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `SAST_OUTPUT_FILE` (default `./artifacts/security/sast-results.json`)
- `SAST_FAIL_ON_FINDINGS` (`true` or `false`, default `true`)

Legacy env vars remain supported for compatibility:
- `SCAN_PATH`, `RULESET`, `OUTPUT_DIR`, `OUTPUT_FILE`, `FAIL_ON_FINDINGS`

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
./runbooks/appsec/sast-semgrep-opengrep-basic.sh
```

To scan only the vulnerable demo app:

```bash
SAST_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
```

If you want report-only mode:

```bash
SAST_FAIL_ON_FINDINGS=false ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
```

## CI/CD Recommendation
For consistency across environments, call the standalone script from your pipeline:

```bash
chmod +x ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
SAST_SCAN_PATH=. SAST_RULESET=p/security-audit SAST_FAIL_ON_FINDINGS=true ./runbooks/appsec/sast-semgrep-opengrep-basic.sh
```

Ready-to-copy pipeline files are included:
- GitHub Actions: `runbooks/appsec/github-actions-sast.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-sast.yml`

To use them, copy into your repo as:
- `.github/workflows/sast.yml` (GitHub Actions)
- `.gitlab-ci.yml` or include as a child config (GitLab CI)

## GitHub Actions Example
```yaml
name: sast-scan

on:
  pull_request:
  push:
    branches:
      - main

jobs:
  sast:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Ensure runbook script executable
        run: chmod +x ./runbooks/appsec/sast-semgrep-opengrep-basic.sh

      - name: Run SAST runbook
        env:
          SAST_SCAN_PATH: ${{ vars.SAST_SCAN_PATH || '.' }}
          SAST_RULESET: ${{ vars.SAST_RULESET || 'p/security-audit' }}
          SEC_OUTPUT_DIR: ./artifacts/security
          SAST_FAIL_ON_FINDINGS: "true"
        run: ./runbooks/appsec/sast-semgrep-opengrep-basic.sh

      - name: Upload SAST artifact
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: sast-results
          path: artifacts/security/sast-results.json
```

## Triage Guidance
- Review findings by severity and confidence first
- Suppress only with justification and expiry date
- Convert recurring true positives into backlog items with owners
- Create custom rules after repeated patterns are discovered

## Suggested Next Improvements
- Add language-specific rulesets (for example `p/javascript`, `p/python`)
- Add secrets scanning and dependency scanning runbooks
- Add SARIF output and code scanning integration
- Add baseline comparison to reduce noise in legacy repos


# Runbook: Basic SAST with Snyk Code

## Purpose

Run static application security testing (SAST) in CI/CD using **Snyk Code** via the Snyk CLI. This is the Snyk counterpart to the Semgrep/OpenGrep runbook (`sast-semgrep-opengrep-basic.md`).

## Standalone runner (recommended)

Use the executable runbook script:

- `runbooks/appsec/sast-snyk-code-basic.sh`

This script is CI/CD standalone and uses:

- Docker image `snyk/snyk:node` by default (override with `SAST_SNYK_DOCKER_IMAGE` for other stacks, for example `snyk/snyk:python`)
- no local Snyk CLI installation required
- **`SNYK_TOKEN` required** (API token; never commit—use CI secrets)

## Scope

- Application source repositories (languages supported by Snyk Code)
- Pull requests and default-branch builds
- JSON reports for evidence and triage (`sast_artifact` in your evidence mapping)

## When to Use

- New repository onboarding where Snyk is the approved SAST tool
- PR checks aligned to your AppSec policy (see `framework/appsec-policy-baseline.md`)
- When you want SAST findings in the same Snyk org as SCA and other products

## Preconditions

- Repository code is checked out
- Docker is available on the runner (same model as Semgrep/Trivy runbooks here)
- `SNYK_TOKEN` is available to the job (GitHub `secrets.SNYK_TOKEN`, GitLab masked variable, etc.)
- Network access from the runner to Snyk APIs

## Inputs

- `SNYK_TOKEN` (**required**)
- `SAST_SCAN_PATH` (default `.`)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `SAST_OUTPUT_FILE` (default `./artifacts/security/sast-snyk-code.json`)
- `SAST_FAIL_ON_FINDINGS` (`true` or `false`, default `true`)
- `SAST_SNYK_DOCKER_IMAGE` (default `snyk/snyk:node`)
- `SAST_SNYK_SEVERITY_THRESHOLD` (`low|medium|high|critical`, default `high`)
- `SNYK_ORG` (optional; passed as `--org` when you have multiple orgs)
- `SAST_SNYK_EXTRA_ARGS` (optional extra arguments to `snyk code test`, space-separated)

## Quick start

From repo root:

```bash
export SNYK_TOKEN=...   # from Snyk account / service account
chmod +x ./runbooks/appsec/sast-snyk-code-basic.sh
./runbooks/appsec/sast-snyk-code-basic.sh
```

Scan only a subdirectory (for example the demo app):

```bash
SNYK_TOKEN=... SAST_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sast-snyk-code-basic.sh
```

Report-only (do not fail the job on findings):

```bash
SNYK_TOKEN=... SAST_FAIL_ON_FINDINGS=false ./runbooks/appsec/sast-snyk-code-basic.sh
```

## CI/CD recommendation

Call the standalone script from your pipeline for consistent behavior:

```bash
chmod +x ./runbooks/appsec/sast-snyk-code-basic.sh
SNYK_TOKEN=... ./runbooks/appsec/sast-snyk-code-basic.sh
```

Ready-to-copy pipeline files are included:

- GitHub Actions: `runbooks/appsec/github-actions-sast-snyk.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-sast-snyk.yml`

Copy into your repo as `.github/workflows/...` or include from `.gitlab-ci.yml` as you do for the Semgrep templates.

### GitHub Actions notes

- Add repository secret **`SNYK_TOKEN`** (required).
- Optional: set repository variable `SAST_SCAN_PATH` if the app is not at the repo root.

## Manual CLI (no Docker)

If your policy requires a natively installed CLI instead of the Docker runner, install the [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli) and run:

```bash
snyk code test --severity-threshold=high --json-file-output=./artifacts/security/sast-snyk-code.json
```

Use the same `SNYK_TOKEN` / `snyk auth` model as in CI.

## Triage guidance

- Triage by severity first, then by reachability in your architecture
- Use Snyk ignores only with owner, reason, and expiry per your process
- Feed recurring false positives back into policy tuning with AppSec

## Strengths and limitations (summary)

| Strengths | Limitations |
|-----------|-------------|
| Semantic analysis; same platform as Snyk Open Source | Requires org and token governance |
| JSON/SARIF available from CLI | Findings depend on language support and configuration |
| Works well in unified Snyk rollouts | CI must receive `SNYK_TOKEN` securely |

## Suggested next improvements

- SARIF upload to your code scanning or PR annotations if required by policy
- Align `--severity-threshold` with `framework/appsec-policy-baseline.md` and your exception process
- Pair with `sca-snyk-basic.md` for dependency scanning

# Runbook: Basic SCA with Snyk Open Source

## Purpose

Run software composition analysis (SCA) in CI/CD using **Snyk Open Source** (`snyk test`). This is the Snyk counterpart to the Trivy SCA runbook (`sca-trivy-basic.md`).

## Standalone runner

Use:

- `runbooks/appsec/sca-snyk-basic.sh`

This script is CI/CD standalone and uses:

- Docker image `snyk/snyk:node` by default (override with `SCA_SNYK_DOCKER_IMAGE` when your manifest ecosystem matches another image, for example `snyk/snyk:maven`)
- no local Snyk CLI installation required
- **`SNYK_TOKEN` required** (API token; never commit—use CI secrets)

## Scope

- Repositories with supported dependency manifests and lockfiles
- Pull requests and default-branch builds
- JSON reports for evidence (`sca_artifact`)

## When to Use

- Dependency vulnerability gates where Snyk is the approved SCA tool
- License policy enforcement configured in Snyk (if your org uses it)
- Same Snyk org and evidence pattern as Snyk Code (`sast-snyk-code-basic.md`)

## Preconditions

- Repository code is checked out (include lockfiles when your policy requires deterministic scans)
- Docker is available on the runner
- `SNYK_TOKEN` is available to the job
- Network access to Snyk APIs

Some ecosystems resolve dependencies more accurately after an install step (for example `npm ci` before `snyk test`). If results look empty or wrong, add the appropriate install step **before** this runbook in CI.

## Inputs

- `SNYK_TOKEN` (**required**)
- `SCA_SCAN_PATH` (default `.`)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `SCA_REPORT_PREFIX` (default `sca-snyk` → `artifacts/security/sca-snyk.json`)
- `SCA_SNYK_DOCKER_IMAGE` (default `snyk/snyk:node`)
- `SCA_FAIL_ON_FAILS` (`true|false`, default `true`)
- `SCA_SNYK_SEVERITY_THRESHOLD` (`low|medium|high|critical`, default `high`)
- `SCA_SNYK_ALL_PROJECTS` (`true|false`, default `false` — when `true`, adds `--all-projects` for monorepos)
- `SNYK_ORG` (optional; passed as `--org`)
- `SCA_SNYK_EXTRA_ARGS` (optional extra arguments to `snyk test`, space-separated)

`SCA_FAIL_ON_WARNINGS` (used in the Trivy runbook) does not map one-to-one to Snyk’s single severity threshold; tune policy with `SCA_SNYK_SEVERITY_THRESHOLD` and Snyk org settings instead.

CLI options are also supported:

- `--scan-path`
- `--output-dir`
- `--report-prefix`

## Quick start

From repo root:

```bash
export SNYK_TOKEN=...
chmod +x ./runbooks/appsec/sca-snyk-basic.sh
./runbooks/appsec/sca-snyk-basic.sh
```

Scan only the demo app folder:

```bash
SNYK_TOKEN=... SCA_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sca-snyk-basic.sh
```

## Output artifacts

By default:

- `artifacts/security/sca-snyk.json`

## CI/CD usage

```bash
chmod +x ./runbooks/appsec/sca-snyk-basic.sh
SNYK_TOKEN=... ./runbooks/appsec/sca-snyk-basic.sh
```

Ready-to-copy pipeline files:

- GitHub Actions: `runbooks/appsec/github-actions-sca-snyk.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-sca-snyk.yml`

### GitHub Actions notes

- Add repository secret **`SNYK_TOKEN`** (required).
- Optional: set `SCA_SNYK_ALL_PROJECTS` via repository variable if you scan a monorepo from the root.

## Manual CLI (no Docker)

Install the [Snyk CLI](https://docs.snyk.io/snyk-cli/install-the-snyk-cli), then from the project directory:

```bash
snyk test --severity-threshold=high --json-file-output=./artifacts/security/sca-snyk.json
```

## Policy and ignore files

- **`.snyk`** — ignore rules with metadata; use only with your org’s exception process
- **Snyk UI policies** — may affect what fails in the platform versus raw CLI exit codes; document the authoritative layer for CI

## Triage guidance

- Prefer upgrading dependencies when a fix exists; use Snyk fix PRs if enabled
- Transitive issues may need upstream fixes or overrides—record decisions in your register
- License findings: route per legal/OSPO policy

## Strengths and limitations (summary)

| Strengths | Limitations |
|-----------|-------------|
| Rich vulnerability data in one platform with Snyk Code | Requires token and correct project/org context |
| `--all-projects` for monorepos | Best results often need lockfiles and sometimes a prior install step |
| Integrations for PR feedback | Org-level policy can change effective gates—document yours |

## Suggested next improvements

- `snyk monitor` on default branch if you need continuous drift tracking between PRs
- Align severity and license rules with `framework/appsec-policy-baseline.md`
- Pair with `sast-snyk-code-basic.md` for combined Snyk SAST + SCA evidence

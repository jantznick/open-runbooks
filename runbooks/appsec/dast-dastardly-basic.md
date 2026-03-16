# Runbook: Basic DAST Scan with Burp Dastardly

## Purpose
Run a lightweight dynamic application security test (DAST) in CI/CD using Burp Dastardly.

## Standalone Runner
Use:

- `runbooks/appsec/dast-dastardly-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `public.ecr.aws/portswigger/dastardly:latest`
- no local Burp installation requirements

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/dast-dastardly-basic.sh
./runbooks/appsec/dast-dastardly-basic.sh https://your-app-url.example
```

## Inputs
- `DAST_TARGET_URL` (required)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `DAST_REPORT_PREFIX` (default `dastardly-report`)
- `DAST_FAIL_ON_FAILS` (`true|false`, default `true`)
- `DAST_FAIL_ON_WARNINGS` (`true|false`, default `false`)
- `DAST_DOCKER_IMAGE` (default `public.ecr.aws/portswigger/dastardly:latest`)
- `DAST_DOCKER_PLATFORM` (optional, for example `linux/amd64`)

Legacy env vars remain supported for compatibility:
- `TARGET_URL`, `OUTPUT_DIR`, `REPORT_PREFIX`, `DASTARDLY_IMAGE`
- `FAIL_ON_FAILS`, `FAIL_ON_WARNINGS`

CLI options are also supported:
- `--target-url` / `-t`
- `--output-dir`
- `--report-prefix`
- `--docker-platform`

## Target URL Requirement
- `DAST_TARGET_URL` must be reachable from inside the Docker scanner container.
- Do not use `localhost` or `127.0.0.1` for CI/CD runs.
- Use an environment URL accessible from the runner, such as `https://your-app-url.example`.
- For local-only Docker testing, use `http://host.docker.internal:<port>`.

## Browser Startup Issues (ARM / Apple Silicon)
If you see errors like "browser could not be started" and summary shows:
- `tests: 0`

then the scanner likely failed before running checks (runtime/platform issue, not app findings).

Try forcing amd64 emulation:

```bash
DAST_DOCKER_PLATFORM=linux/amd64 ./runbooks/appsec/dast-dastardly-basic.sh http://host.docker.internal:3001
```

Equivalent CLI form:

```bash
./runbooks/appsec/dast-dastardly-basic.sh --docker-platform linux/amd64 http://host.docker.internal:3001
```

## Output Artifacts
By default:
- `artifacts/security/dastardly-report.xml`

The script prints a console summary from the XML report:
- total tests
- failures/errors/skipped counts
- top failure messages

## CI/CD Usage
Use the same standalone script in CI for consistent behavior:

```bash
chmod +x ./runbooks/appsec/dast-dastardly-basic.sh
DAST_TARGET_URL=https://your-app-url.example ./runbooks/appsec/dast-dastardly-basic.sh
```

Ready-to-copy pipeline files:
- GitHub Actions: `runbooks/appsec/github-actions-dast-dastardly.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-dast-dastardly.yml`

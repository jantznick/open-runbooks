# Runbook: Basic DAST Scan with OWASP ZAP

## Purpose
Run a lightweight dynamic application security test (DAST) against a running URL using OWASP ZAP baseline scanning.

## Standalone Runner (Recommended)
Use:

- `runbooks/appsec/dast-zap-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `ghcr.io/zaproxy/zaproxy:stable`
- no local ZAP installation requirements

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/dast-zap-basic.sh
./runbooks/appsec/dast-zap-basic.sh https://your-app-url.example
```

You can also pass URL via env var:

```bash
DAST_TARGET_URL=https://your-app-url.example ./runbooks/appsec/dast-zap-basic.sh
```

You can also pass scan mode as a CLI option:

```bash
./runbooks/appsec/dast-zap-basic.sh --mode full --minutes 5 https://your-app-url.example
```

## Inputs
- `DAST_TARGET_URL` (required)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `DAST_REPORT_PREFIX` (default `zap-baseline`)
- `DAST_SCAN_MINUTES` (default `1`)
- `DAST_SCAN_MODE` (`baseline` or `full`, default `baseline`)
- `DAST_FAIL_ON_FAILS` (`true|false`, default `true`)
- `DAST_FAIL_ON_WARNINGS` (`true|false`, default `false`)
- `DAST_ALLOW_PARTIAL_RESULTS` (`true|false`, default `false`)

Legacy env vars remain supported for compatibility:
- `TARGET_URL`, `OUTPUT_DIR`, `REPORT_PREFIX`, `ZAP_MINUTES`
- `FAIL_ON_FAILS`, `FAIL_ON_WARNINGS`

CLI options are also supported:
- `--target-url` / `-t`
- `--mode` / `-m`
- `--minutes` / `-n`
- `--output-dir`
- `--report-prefix`

## Target URL Requirement
- `TARGET_URL` must be reachable from inside the Docker scanner container.
- Do not use `localhost` or `127.0.0.1` for CI/CD runs.
- Use an environment URL accessible from the runner, such as `https://your-app-url.example`.
- For local-only Docker testing, use `http://host.docker.internal:<port>`.
- `host.docker.internal` is a container networking hostname; it may not resolve in your regular browser on the host machine.

## CI/CD Usage
Use the same standalone script in CI for consistent behavior:

```bash
chmod +x ./runbooks/appsec/dast-zap-basic.sh
DAST_TARGET_URL=https://your-app-url.example ./runbooks/appsec/dast-zap-basic.sh
```

Ready-to-copy pipeline files:
- GitHub Actions: `runbooks/appsec/github-actions-dast-zap.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-dast-zap.yml`

## Output Artifacts
By default:
- `artifacts/security/zap-baseline.json`
- `artifacts/security/zap-baseline.md`
- `artifacts/security/zap-baseline.html`

## Why Baseline May Show No Findings
`baseline` mode primarily spiders and runs passive checks. For intentionally vulnerable apps, this can still return few or zero findings.

To get deeper results, run active scan mode:

```bash
DAST_TARGET_URL=http://host.docker.internal:3001 DAST_SCAN_MODE=full DAST_SCAN_MINUTES=5 ./runbooks/appsec/dast-zap-basic.sh
```

Equivalent CLI form:

```bash
./runbooks/appsec/dast-zap-basic.sh --mode full --minutes 5 http://host.docker.internal:3001
```

You can also inspect raw results in:
- `artifacts/security/zap-baseline.json`
- `artifacts/security/zap-baseline.html`

The script now prints a console summary after each run:
- total alert types
- alert counts by risk
- top findings (up to 10)

## Full Scan WebDriver Errors
In some environments (especially ARM-based hosts), `full` mode can complete with findings but still exit with a runtime error due to browser/WebDriver addon issues.

If you want to tolerate that case and keep CI decisions based on generated report risk levels, set:

```bash
DAST_ALLOW_PARTIAL_RESULTS=true
```

When enabled, if ZAP exits with a runtime error but JSON report data is present:
- report with `High`/`Medium` alerts maps to exit `1`
- report with only `Low`/`Informational` maps to exit `2`
- no alerts maps to exit `0`

## Suggested Next Improvements
- Add authenticated scan mode
- Add API (OpenAPI) scan mode
- Add fail thresholds by risk or rule ID

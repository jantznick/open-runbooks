# Runbook: Basic DAST Scan with Nuclei

## Purpose
Run a lightweight but reliable dynamic application security test (DAST) in CI/CD using Nuclei HTTP templates.

## Standalone Runner
Use:

- `runbooks/appsec/dast-nuclei-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `projectdiscovery/nuclei:latest`
- no local Nuclei installation requirements

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/dast-nuclei-basic.sh
./runbooks/appsec/dast-nuclei-basic.sh https://your-app-url.example
```

For local Docker-to-host testing:

```bash
./runbooks/appsec/dast-nuclei-basic.sh http://host.docker.internal:3001
```

## Inputs
- `DAST_TARGET_URL` (required)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `DAST_REPORT_PREFIX` (default `nuclei-report`)
- `DAST_DOCKER_IMAGE` (default `projectdiscovery/nuclei:latest`)
- `DAST_FAIL_ON_FAILS` (`true|false`, default `true`)
- `DAST_FAIL_ON_WARNINGS` (`true|false`, default `false`)

## Nuclei Tuning Inputs
- `DAST_NUCLEI_PROFILE` (`baseline|balanced|aggressive`, default `balanced`)
- `DAST_NUCLEI_SEVERITY` (severity override)
- `DAST_NUCLEI_RATE_LIMIT` (rate limit override)
- `DAST_NUCLEI_TIMEOUT` (timeout override)
- `DAST_NUCLEI_TAGS` (optional include tags)
- `DAST_NUCLEI_TEMPLATES` (optional template path/filter)
- `DAST_NUCLEI_EXCLUDE_TAGS` (optional exclude tags)
- `DAST_NUCLEI_AUTO_SCAN` (`true|false`, enables `-as`)
- `DAST_NUCLEI_UPDATE_TEMPLATES` (`true|false`, enables `-ut`)
- `DAST_NUCLEI_EXTRA_ARGS` (additional nuclei args)

Profile defaults:
- `baseline`: faster/lower noise, no auto-scan, no template update
- `balanced`: general default, auto-scan + template update
- `aggressive`: higher depth, broader security tags, higher rate/timeout

Legacy env vars remain supported for compatibility:
- `TARGET_URL`, `OUTPUT_DIR`, `REPORT_PREFIX`, `NUCLEI_IMAGE`
- `FAIL_ON_FAILS`, `FAIL_ON_WARNINGS`

CLI options are also supported:
- `--target-url` / `-t`
- `--output-dir`
- `--report-prefix`
- `--profile`

## Recommended Commands For This Test App

Balanced scan:

```bash
DAST_TARGET_URL=http://host.docker.internal:3001 ./runbooks/appsec/dast-nuclei-basic.sh
```

Aggressive scan:

```bash
DAST_TARGET_URL=http://host.docker.internal:3001 \
DAST_NUCLEI_PROFILE=aggressive \
./runbooks/appsec/dast-nuclei-basic.sh
```

Aggressive with explicit tags:

```bash
DAST_TARGET_URL=http://host.docker.internal:3001 \
DAST_NUCLEI_PROFILE=aggressive \
DAST_NUCLEI_TAGS=xss,sqli,lfi,rce,ssrf,cors,redirect,exposure,misconfig \
./runbooks/appsec/dast-nuclei-basic.sh
```

## Target URL Requirement
- `DAST_TARGET_URL` must be reachable from inside the Docker scanner container.
- Do not use `localhost` or `127.0.0.1` for CI/CD runs.
- Use an environment URL accessible from the runner, such as `https://your-app-url.example`.
- For local-only Docker testing, use `http://host.docker.internal:<port>`.

## Output Artifacts
By default:
- `artifacts/security/nuclei-report.jsonl`

The script prints a console summary after each run:
- finding count by severity
- top findings (up to 10)

## CI/CD Usage
Use the same standalone script in CI for consistent behavior:

```bash
chmod +x ./runbooks/appsec/dast-nuclei-basic.sh
DAST_TARGET_URL=https://your-app-url.example ./runbooks/appsec/dast-nuclei-basic.sh
```

Ready-to-copy pipeline files:
- GitHub Actions: `runbooks/appsec/github-actions-dast-nuclei.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-dast-nuclei.yml`

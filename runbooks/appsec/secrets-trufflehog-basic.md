# Runbook: Basic Secrets Scan with TruffleHog

## Purpose
Run lightweight secrets detection in CI/CD using TruffleHog.

## Standalone Runner
Use:

- `runbooks/appsec/secrets-trufflehog-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `trufflesecurity/trufflehog:latest`
- no local TruffleHog installation requirements

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/secrets-trufflehog-basic.sh
./runbooks/appsec/secrets-trufflehog-basic.sh
```

Scan only the vulnerable test app folder:

```bash
SECRETS_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/secrets-trufflehog-basic.sh
```

## Inputs
- `SECRETS_SCAN_PATH` (default `.`)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `SECRETS_REPORT_PREFIX` (default `trufflehog-results`)
- `SECRETS_DOCKER_IMAGE` (default `trufflesecurity/trufflehog:latest`)
- `SECRETS_FAIL_ON_FINDINGS` (`true|false`, default `true`)

## TruffleHog Tuning Inputs
- `SECRETS_ONLY_VERIFIED` (`true|false`, default `false`)
- `SECRETS_NO_VERIFICATION` (`true|false`, default `false`)
- `SECRETS_TRUFFLEHOG_EXTRA_ARGS` (optional extra CLI args)

Legacy env vars remain supported for compatibility:
- `SCAN_PATH`, `OUTPUT_DIR`, `REPORT_PREFIX`, `TRUFFLEHOG_IMAGE`, `FAIL_ON_FINDINGS`

CLI options are also supported:
- `--scan-path`
- `--output-dir`
- `--report-prefix`

## Output Artifacts
By default:
- `artifacts/security/trufflehog-results.jsonl`

The script prints a console summary:
- findings count
- verified/unverified counts
- top detector counts
- top findings

## CI/CD Usage
Use the same standalone script in CI for consistent behavior:

```bash
chmod +x ./runbooks/appsec/secrets-trufflehog-basic.sh
./runbooks/appsec/secrets-trufflehog-basic.sh
```

Ready-to-copy pipeline files:
- GitHub Actions: `runbooks/appsec/github-actions-secrets-trufflehog.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-secrets-trufflehog.yml`

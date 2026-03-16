# Runbook: Basic SCA Scan with Trivy

## Purpose
Run software composition analysis (SCA) in CI/CD using Trivy filesystem dependency vulnerability scanning.

## Standalone Runner
Use:

- `runbooks/appsec/sca-trivy-basic.sh`

This script is CI/CD standalone and uses:
- Docker image `aquasec/trivy:latest`
- no local Trivy installation requirements

## Quick Start
From repo root:

```bash
chmod +x ./runbooks/appsec/sca-trivy-basic.sh
./runbooks/appsec/sca-trivy-basic.sh
```

Scan only the vulnerable test app folder:

```bash
SCA_SCAN_PATH=./test-app-vulnerable-todo ./runbooks/appsec/sca-trivy-basic.sh
```

## Inputs
- `SCA_SCAN_PATH` (default `.`)
- `SEC_OUTPUT_DIR` (default `./artifacts/security`)
- `SCA_REPORT_PREFIX` (default `trivy-sca`)
- `SCA_DOCKER_IMAGE` (default `aquasec/trivy:latest`)
- `SCA_FAIL_ON_FAILS` (`true|false`, default `true`)
- `SCA_FAIL_ON_WARNINGS` (`true|false`, default `false`)

## Trivy Tuning Inputs
- `SCA_TRIVY_SEVERITY` (default `CRITICAL,HIGH,MEDIUM,LOW`)
- `SCA_TRIVY_IGNORE_UNFIXED` (`true|false`, default `false`)
- `SCA_TRIVY_SKIP_DB_UPDATE` (`true|false`, default `false`)
- `SCA_TRIVY_EXTRA_ARGS` (optional extra CLI args)

Legacy env vars remain supported for compatibility:
- `SCAN_PATH`, `OUTPUT_DIR`, `REPORT_PREFIX`, `TRIVY_IMAGE`, `FAIL_ON_FAILS`, `FAIL_ON_WARNINGS`

CLI options are also supported:
- `--scan-path`
- `--output-dir`
- `--report-prefix`

## Output Artifacts
By default:
- `artifacts/security/trivy-sca.json`

The script prints a console summary:
- vulnerabilities count
- severity distribution
- top vulnerabilities (up to 10)

## CI/CD Usage
Use the same standalone script in CI for consistent behavior:

```bash
chmod +x ./runbooks/appsec/sca-trivy-basic.sh
./runbooks/appsec/sca-trivy-basic.sh
```

Ready-to-copy pipeline files:
- GitHub Actions: `runbooks/appsec/github-actions-sca-trivy.yml`
- GitLab CI: `runbooks/appsec/gitlab-ci-sca-trivy.yml`

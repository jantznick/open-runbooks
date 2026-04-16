# Open Runbooks

Practical, standalone security runbooks for CI/CD pipelines.

## AppSec program (start here)

**Main user flow and navigation:** [`runbooks/appsec/README.md`](runbooks/appsec/README.md) — journey from policy → lifecycle phases → scanners → SAMM, plus repository layout and **known gaps**.

Quick pointers:

- Program overview: [`runbooks/appsec/appsec-program-full-circle.md`](runbooks/appsec/appsec-program-full-circle.md)
- Implementation tracker: [`runbooks/appsec/program/implementation-master-checklist.md`](runbooks/appsec/program/implementation-master-checklist.md)
- Policy baseline: [`runbooks/appsec/framework/appsec-policy-baseline.md`](runbooks/appsec/framework/appsec-policy-baseline.md)
- Evidence mapping (YAML): [`runbooks/appsec/framework/policy-evidence-mapping.yaml`](runbooks/appsec/framework/policy-evidence-mapping.yaml)

Phase guides (`01`–`06`), SAMM docs, and scanner tables are linked from the AppSec README above. This root README stays a short index.

## Runbook Index

### SAST
- Semgrep/OpenGrep:
  - Script: `runbooks/appsec/sast-semgrep-opengrep-basic.sh`
  - Guide: `runbooks/appsec/sast-semgrep-opengrep-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-sast.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-sast.yml`

### Secrets
- TruffleHog:
  - Script: `runbooks/appsec/secrets-trufflehog-basic.sh`
  - Guide: `runbooks/appsec/secrets-trufflehog-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-secrets-trufflehog.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-secrets-trufflehog.yml`

### SCA
- Trivy:
  - Script: `runbooks/appsec/sca-trivy-basic.sh`
  - Guide: `runbooks/appsec/sca-trivy-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-sca-trivy.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-sca-trivy.yml`

### DAST
- OWASP ZAP:
  - Script: `runbooks/appsec/dast-zap-basic.sh`
  - Guide: `runbooks/appsec/dast-zap-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-dast-zap.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-dast-zap.yml`

- Burp Dastardly:
  - Script: `runbooks/appsec/dast-dastardly-basic.sh`
  - Guide: `runbooks/appsec/dast-dastardly-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-dast-dastardly.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-dast-dastardly.yml`

- Nuclei:
  - Script: `runbooks/appsec/dast-nuclei-basic.sh`
  - Guide: `runbooks/appsec/dast-nuclei-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-dast-nuclei.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-dast-nuclei.yml`

## Local Test App
- `test-app-vulnerable-todo`
- Guide: `test-app-vulnerable-todo/README.md`

## Local Docker Targeting
If the target app runs on your host machine, use:
- `http://host.docker.internal:<port>`

instead of:
- `http://localhost:<port>`

Example:
```bash
./runbooks/appsec/dast-zap-basic.sh http://host.docker.internal:3001
./runbooks/appsec/dast-dastardly-basic.sh http://host.docker.internal:3001
./runbooks/appsec/dast-nuclei-basic.sh http://host.docker.internal:3001
```

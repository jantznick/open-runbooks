# Open Runbooks

Practical, standalone security runbooks for CI/CD pipelines.

## AppSec Program Docs (Canonical)
- Program overview and roadmap: `runbooks/appsec/appsec-program-full-circle.md`
- OWASP SAMM reference and local alignment: `runbooks/appsec/program/framework-owasp-samm.md`
- OWASP SAMM coverage checklist template: `runbooks/appsec/program/samm-coverage-checklist.md`
- Program implementation tracker: `runbooks/appsec/program/implementation-master-checklist.md`
- Policy baseline (normative controls): `runbooks/appsec/framework/appsec-policy-baseline.md`
- Policy-to-evidence mapping template: `runbooks/appsec/framework/policy-evidence-mapping.yaml`
- Phase guides:
  - `runbooks/appsec/program/01-plan-and-design.md`
  - `runbooks/appsec/program/02-build-and-commit.md`
  - `runbooks/appsec/program/03-ci-gate.md`
  - `runbooks/appsec/program/04-release-and-deploy.md`
  - `runbooks/appsec/program/05-runtime-and-operate.md`
  - `runbooks/appsec/program/06-improve-and-govern.md`

Use those files for full lifecycle/process detail. This README is intentionally a quick index.

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

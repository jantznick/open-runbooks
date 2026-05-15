# Open Runbooks

Practical security runbooks and reference CI jobs for pipelines. This repository also hosts **corporate application security program documentation** under [`policy/appsec/`](policy/appsec/README.md).

## Application security program (documentation)

**Primary documentation:** [`policy/appsec/README.md`](policy/appsec/README.md) — policy baseline, full-circle operating model (phases 01–06), policy ↔ process alignment, standard forms, and links to reference scanner jobs.

Quick pointers:

- **CI setup (GitHub Actions):** [`runbooks/appsec/setup-github-actions.md`](runbooks/appsec/setup-github-actions.md)
- **Optional validation walkthrough:** [`runbooks/appsec/demo-github-security-ci-walkthrough.md`](runbooks/appsec/demo-github-security-ci-walkthrough.md)
- Program overview: [`policy/appsec/appsec-program-full-circle.md`](policy/appsec/appsec-program-full-circle.md)
- Implementation checklist: [`policy/appsec/program/implementation-master-checklist.md`](policy/appsec/program/implementation-master-checklist.md)
- Policy baseline: [`policy/appsec/framework/appsec-policy-baseline.md`](policy/appsec/framework/appsec-policy-baseline.md)
- Evidence mapping (YAML): [`policy/appsec/framework/policy-evidence-mapping.yaml`](policy/appsec/framework/policy-evidence-mapping.yaml)

Phase guides, SAMM reference, and scanner tables are linked from the documentation home above.

## Runbook index

Reference shell scripts and workflow templates live under `runbooks/appsec/`. **Corporate Security** may publish this tree (or an internal fork) as the **approved job package** for engineering; service teams install jobs per [CI integration](policy/appsec/README.md#using-these-runbooks-in-your-own-repository).

**Quick install:** [`runbooks/appsec/setup-github-actions.md`](runbooks/appsec/setup-github-actions.md)

### SAST
- Semgrep/OpenGrep:
  - Script: `runbooks/appsec/sast-semgrep-opengrep-basic.sh`
  - Guide: `runbooks/appsec/sast-semgrep-opengrep-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-sast.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-sast.yml`

- Snyk Code:
  - Script: `runbooks/appsec/sast-snyk-code-basic.sh`
  - Guide: `runbooks/appsec/sast-snyk-code-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-sast-snyk.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-sast-snyk.yml`

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

- Snyk Open Source:
  - Script: `runbooks/appsec/sca-snyk-basic.sh`
  - Guide: `runbooks/appsec/sca-snyk-basic.md`
  - GitHub Actions: `runbooks/appsec/github-actions-sca-snyk.yml`
  - GitLab CI: `runbooks/appsec/gitlab-ci-sca-snyk.yml`

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

### PR review (LLM, advisory)
- Guide: `runbooks/appsec/pr-llm-security-review.md`
- GitHub Actions (diff): `runbooks/appsec/github-actions-pr-llm-security-review.yml`
- GitHub Actions (SAST/SCA findings): `runbooks/appsec/github-actions-pr-llm-security-review-findings.yml`

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

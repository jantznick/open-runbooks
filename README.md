# Open Runbooks

Practical, standalone security runbooks for CI/CD pipelines.

**Corporate Security** can publish this repository (or a private fork) as the **authoritative program and runbook bundle** for **operating companies and internal engineering**. We provide the lifecycle docs, policy baseline template, and runnable scanner jobs; **corporate policy** (your customized baseline) states what is mandatory by tier. Teams adopt controls by copying files per **[Using these runbooks in your own repository](runbooks/appsec/README.md#using-these-runbooks-in-your-own-repository)**, or by consuming a **[corporate golden repo](runbooks/appsec/README.md#staying-current-with-upstream-runbooks)** that we keep current. **Subsidiary or divisional** teams may maintain their own internal golden fork as described there, subject to corporate minimums.

## AppSec program (start here)

**Main user flow and navigation:** [`runbooks/appsec/README.md`](runbooks/appsec/README.md) — journey from policy → lifecycle phases → scanners → SAMM, plus repository layout and **known gaps**.

Quick pointers:

- **GitHub Actions demo (fork → scans → artifacts):** [`runbooks/appsec/demo-github-security-ci-walkthrough.md`](runbooks/appsec/demo-github-security-ci-walkthrough.md) — workflow: [`.github/workflows/security-demo-gate.yml`](.github/workflows/security-demo-gate.yml)
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

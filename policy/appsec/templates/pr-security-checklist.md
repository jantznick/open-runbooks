# Pull request — security checklist (template)

**Purpose:** Satisfy [Security impact on pull requests](../framework/appsec-policy-baseline.md) (PR template or checklist on every in-scope PR).

**How to use:** Copy this file to `.github/PULL_REQUEST_TEMPLATE.md`, `.gitlab/merge_request_templates/default.md`, or paste into the PR description. Reviewers must verify answers before merge.

---

## Change summary

**Title / ticket:** 

**Type:** Feature | Bugfix | Refactor | Dependency | Config / infra | Docs only

---

## Security impact

- [ ] **No material security impact** — docs-only, tests-only, or cosmetic with no auth/data/config change  
- [ ] **Security impact** — complete the sections below

---

## Checklist (complete when security impact applies)

| # | Question | Yes | No | N/A | Notes |
|---|----------|-----|----|-----|-------|
| 1 | Does this change touch **authentication, authorization, or session** handling? | | | | |
| 2 | Does it change **trust boundaries** (new API, integration, network path, tenant boundary)? | | | | |
| 3 | Does it process, store, or transmit **sensitive or regulated data**? (see [data-classification-scheme.md](data-classification-scheme.md)) | | | | |
| 4 | Are **new dependencies** added or materially upgraded? (name + justification) | | | | |
| 5 | Are **secrets, keys, tokens, or credentials** introduced or changed? (must not commit secrets) | | | | |
| 6 | Does it change **security-relevant configuration** (CORS, CSP, TLS, IAM, feature flags)? | | | | |
| 7 | Is **user input** handled in a new path (injection, XSS, SSRF, deserialization)? | | | | |
| 8 | Are **errors and logs** free of sensitive data? | | | | |
| 9 | Do **tests** cover security-sensitive behavior where applicable? | | | | |
| 10 | Is **AppSec consult** required per rubric? (tier high, regulated data, or unsure) | | | | |

**New dependencies (if yes to #4):**

| Package | Version | License OK? | Known vulns reviewed? |
|---------|---------|-------------|------------------------|
| | | | |

**Threat model / ADR (if yes to #1, #2, or #3 on medium/high tier apps):**

- [ ] Existing threat model still valid  
- [ ] Threat model updated — link (catalog record or doc):  
- [ ] ADR filed — link:  

---

## CI and evidence

- [ ] Required CI jobs ran (SAST, secrets, SCA — and DAST if applicable)  
- [ ] No **blocker** findings without fix or approved [exception](exception-request-form.md) (reference ID: ______)  
- [ ] Scan artifacts available in CI for this commit/PR  

---

## Reviewer sign-off

| Reviewer | Role | Date | OK to merge? |
|----------|------|------|--------------|
| | Code owner | | Yes / No — reason: |
| | AppSec (if consulted) | | |

**Escalation:** If any “Yes” in rows 1–3 or 10 on a **high**-tier or **regulated** app, do not merge without AppSec or documented exception.

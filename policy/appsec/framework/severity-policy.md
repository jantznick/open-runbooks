# Severity and CI gate policy

**Canonical source:** This document and [`severity-policy.yaml`](severity-policy.yaml) together define how scanner findings map to **merge blocks**, **warnings**, and **remediation SLAs**. Corporate Security publishes both; engineering implements gates in CI and tracks SLAs in ticketing.

**Related:** [AppSec policy baseline](appsec-policy-baseline.md) (control **Enforce severity thresholds**) · [Exception request](../templates/exception-request-form.md) · [Risk tier rubric](../templates/risk-tier-rubric.md) · [Glossary](../glossary.md)

---

## Purpose

- One **severity vocabulary** across SAST, secrets, SCA, and DAST.
- Predictable **CI behavior** by `risk_tier` (`low` | `medium` | `high`).
- Clear **remediation SLAs** for triage and audit.

Teams MAY be **stricter** than this policy. **Weaker** gates (e.g. not blocking on High for a `high`-tier app) require an approved [exception](../templates/exception-request-form.md).

---

## Severity scale

| Canonical ID | Display | Typical meaning | Default gate role |
|--------------|---------|-----------------|-------------------|
| `critical` | Critical | Exploitable or severe imminent harm | Block merge (all tiers) |
| `high` | High | Serious weakness; fix within SLA | Block per tier profile |
| `medium` | Medium | Material issue; track to closure | Warn (or block if you tighten policy) |
| `low` | Low | Limited impact | Log / backlog |
| `info` | Informational | Hygiene, style, hardening ideas | Log only |

Vendor tools use different labels. Normalize to this scale in pipelines and dashboards using `tool_normalization` in [`severity-policy.yaml`](severity-policy.yaml).

---

## CI gate behavior by risk tier

**Block merge** = pipeline fails unless finding is fixed, suppressed with false-positive approval, or covered by a **non-expired** exception.

| `risk_tier` | Block merge on | Warn on | Log only |
|-------------|----------------|---------|----------|
| **high** | Critical, High | Medium | Low, Info |
| **medium** | Critical, High | Medium | Low, Info |
| **low** | Critical only | High, Medium | Low, Info |

### Overrides

| Condition | Behavior |
|-----------|----------|
| **Verified secret** in repo or artifact | **Always block** — rotate/revoke; no routine waiver without exception |
| **Expired exception** | Treat as no waiver — block release/merge per [Expired exceptions](appsec-policy-baseline.md) |

Configure jobs to read `risk_tier` from application metadata (registry) or repository variable. Record effective thresholds as `policy_threshold_config` evidence (`AS-CI-005`).

---

## Remediation SLAs (calendar days)

Target **time to fix** from triage acceptance, by canonical severity and tier. Customize in YAML before publish.

| Severity | `high` tier | `medium` tier | `low` tier |
|----------|-------------|---------------|------------|
| Critical | 7 | 14 | 30 |
| High | 30 | 60 | 90 |
| Medium | 90 | 120 | — (backlog) |
| Low | Backlog | Backlog | Backlog |

**Triage:** Open tickets for Critical/High within **[1–2]** business days (`high`/`medium` tier) per [`severity-policy.yaml`](severity-policy.yaml) `triage_ticket_within_business_days`.

---

## Implementation checklist

1. **Publish** customized [`severity-policy.yaml`](severity-policy.yaml) (dates, SLAs, any extra `block_on` rules).
2. **Map** each scanner output to canonical severities (extend `tool_normalization` for your stack).
3. **Wire CI** so `SAST_FAIL_ON_FINDINGS`, Trivy exit codes, or equivalent enforce `ci_gate.block_on` for the app’s `risk_tier`.
4. **Document** effective config per repo or catalog entry (`policy_threshold_config`).
5. **Route** waivers through [exception-request-form.md](../templates/exception-request-form.md); cite exception ID in PR or [release sign-off](../templates/release-sign-off-checklist.md).
6. **Review** quarterly in [06 Improve and Govern](../program/06-improve-and-govern.md) — false-positive rate, SLA attainment, tier fit.

---

## Automation

[`policy-evidence-mapping.yaml`](policy-evidence-mapping.yaml) control `AS-CI-005` references this policy. Pipelines and catalogs SHOULD load thresholds from `severity-policy.yaml` (or a generated config) rather than duplicating severity tables in each repo.

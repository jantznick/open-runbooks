# Policy exception / risk acceptance request (template)

**Purpose:** Document a time-bound bypass of a **MUST** control or weaker severity gate. Aligns with [Exception content and approval](../framework/appsec-policy-baseline.md) and evidence type `AS-GOV-001`.

**Rule:** No production reliance on a bypass until **approved**. Expired exceptions block release until remediated, renewed, or removed.

---

## Request metadata

| Field | Value |
|-------|--------|
| Exception ID | `EXC-YYYY-NNNN` (assign when filed) |
| Request date | |
| Requestor | |
| Engineering owner | |
| Business owner | |
| Application `app_id` / name | |
| `risk_tier` | low / medium / high |
| Repository / service | |
| Environment | Production / Staging / CI only |

---

## Control being excepted

| Field | Value |
|-------|--------|
| Policy control | e.g. SAST in CI, secrets scan, DAST, severity fail on High |
| Automation ID (if used) | e.g. `AS-CI-001`, `AS-CI-005` |
| Specific finding or gate | Scanner, rule ID, CVE, pipeline job |
| Scope | Single repo / branch / release / org-wide |

**Current state (evidence):**

- Link to scan report, ticket, or pipeline run:
- Severity / count:

---

## Business justification

Why is the exception needed now? Why not fix immediately?

**Business impact if blocked:**

**Planned remediation date (target fix):**

---

## Compensating controls

What reduces risk while the exception is active?

| Compensating control | Owner | How verified |
|----------------------|-------|--------------|
| e.g. Manual code review | | |
| e.g. WAF rule, monitoring alert | | |
| e.g. Network restriction | | |

---

## Risk assessment

| | |
|--|--|
| **Likelihood** (if exploited) | Low / Medium / High |
| **Impact** | Low / Medium / High |
| **Residual risk summary** | |

**Affected data / users:**

---

## Duration

| | |
|--|--|
| **Effective from** | |
| **Expiry date** | *(required — no indefinite without executive policy)* |
| **Maximum renewal** | e.g. one renewal only; 90-day max |

**Renewal of prior exception ID (if any):**

---

## Approvals

| Role | Name | Date | Decision (Approve / Deny) | Comments |
|------|------|------|---------------------------|----------|
| Engineering lead | | | | |
| Business owner | | | | |
| AppSec / security | | | | |
| Risk / compliance (if regulated) | | | | |
| Executive (if required by policy) | | | | |

**Conditions of approval:**

---

## Operations

- [ ] Exception ID recorded in registry / release system / CI variable  
- [ ] Expiry reminder scheduled **[e.g. 14 days before]**  
- [ ] Linked in release notes or PR when used for merge/release  
- [ ] Retention: store through expiry plus one review cycle  

**On expiry:** Remediate, renew with new approval, or remove bypass — see [release-sign-off-checklist.md](release-sign-off-checklist.md).

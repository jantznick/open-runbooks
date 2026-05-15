# Application risk tier rubric (template)

**Purpose:** Assign and document `risk_tier` (`low` | `medium` | `high`) for each in-scope application. Aligns with [AppSec policy baseline — Risk tier and review cadence](../framework/appsec-policy-baseline.md).

**Owners:** Business + engineering propose; AppSec validates. Re-evaluate **[quarterly / annually]** or after major architecture, data-flow, or exposure changes.

---

## Application record

| Field | Value |
|-------|--------|
| `app_id` / `app_name` | |
| `business_owner` | |
| `engineering_owner` | |
| `data_classification` | (see [data-classification-scheme.md](data-classification-scheme.md)) |
| `internet_facing` | Yes / No |
| `compliance_tags` | e.g. PCI, HIPAA, GDPR — or None |
| Assessment date | |
| Assessed by | |

---

## Scoring dimensions

Score each dimension **0–2**. Sum the row scores (max **10**). Map total to proposed tier using the table below.

| Dimension | 0 — Minimal | 1 — Moderate | 2 — Elevated |
|-----------|-------------|--------------|--------------|
| **Data sensitivity** | Public or non-sensitive internal only | Confidential business data; limited PII | Regulated, financial, health, or high-volume sensitive PII |
| **Exposure** | Internal-only; no untrusted network path | Limited external APIs or partner access | Internet-facing or broad anonymous/unauthenticated access |
| **Business impact** | Degraded service acceptable; no material revenue/compliance harm | Noticeable customer or ops impact | Critical revenue, safety, legal, or brand impact if compromised |
| **Auth / privilege** | Standard workforce SSO; no privileged in-app roles | Role-based access; some admin functions | Break-glass, impersonation, payment, or cross-tenant admin |
| **Change velocity / complexity** | Infrequent releases; simple stack | Regular releases; multiple integrations | High change rate; many third parties, microservices, or legacy debt |

| Dimension | Score (0–2) | Notes |
|-----------|-------------|-------|
| Data sensitivity | | |
| Exposure | | |
| Business impact | | |
| Auth / privilege | | |
| Change velocity / complexity | | |
| **Total** | **/10** | |

---

## Tier mapping (customize thresholds)

| Total score | Proposed `risk_tier` | Typical program expectations |
|-------------|----------------------|------------------------------|
| 0–3 | `low` | Baseline CI; lighter design review |
| 4–6 | `medium` | Threat model for major changes; standard CI gates |
| 7–10 | `high` | Threat model + design review; stricter SLAs; DAST if internet-facing |

**Overrides:** AppSec or risk committee may set tier **higher** than the score (never lower without documented exception). Document override rationale below.

---

## Tier assignment

| | |
|--|--|
| **Proposed tier** | `low` / `medium` / `high` |
| **Approved tier** | |
| **Approved by** | |
| **Approval date** | |
| **Next review date** | |
| **Override rationale** (if any) | |

---

## Linked controls (by tier — customize)

Reference your [severity policy](../framework/severity-policy.md) and [implementation checklist](../program/implementation-master-checklist.md).

| Control area | `low` | `medium` | `high` |
|--------------|-------|----------|--------|
| Threat model (major change) | As needed | Required | Required + AppSec review |
| Design / arch review | Optional | High-impact changes | Critical systems |
| CI: SAST, secrets, SCA | Required | Required | Required |
| CI: baseline DAST | If internet-facing | If internet-facing | Required + scheduled re-scan |
| Finding SLA (High) | [e.g. 90 days] | [e.g. 60 days] | [e.g. 30 days] |
| Exception approval | Engineering lead + AppSec | + business owner | + risk committee |

---

## Evidence

- Store completed rubric in application registry or linked ticket.
- Registry field: `risk_tier` updated within **[e.g. 5]** business days of approval.

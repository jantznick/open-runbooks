# Data classification scheme (template)

**Purpose:** Define labels for `data_classification` in the application registry and in threat models, ADRs, and release records. Customize labels and examples for your legal, privacy, and industry context.

**Not legal advice.** Engage privacy, compliance, and counsel before publishing as corporate policy.

---

## Classification levels

| Label | Definition | Examples | Minimum handling |
|-------|------------|----------|------------------|
| **Public** | Approved for public disclosure; no harm if published | Marketing copy, public API docs, open-source samples | Integrity controls; no confidentiality requirement |
| **Internal** | Not for public release; low impact if disclosed to workforce | Internal roadmaps, non-sensitive operational metrics | Access limited to workforce; encrypt in transit on corporate networks |
| **Confidential** | Sensitive business or customer data; material harm if disclosed | Customer PII (name, email, address), contracts, unreleased product data | Need-to-know access; encryption at rest and in transit; audit logging for access |
| **Regulated** | Subject to specific legal/regulatory regimes or contractual duties | PHI, PCI cardholder data, children’s data, export-controlled data | Controls per applicable regime; see [contextual enhancements](../framework/appsec-policy-baseline-contextual-enhancements.md) |

**Optional tags** (use in `compliance_tags` or `customer_data_types` metadata): `pci_scope`, `phi`, `gdpr_relevant`, `financial`, `children`, `ai_training_data`.

---

## Handling requirements by label

| Requirement | Public | Internal | Confidential | Regulated |
|-------------|--------|----------|--------------|-----------|
| Encryption in transit (TLS 1.2+) | Recommended | Required | Required | Required |
| Encryption at rest for stores | — | Recommended | Required | Required |
| Production data in non-prod | Allowed | Masked preferred | Prohibited without approval | Prohibited; synthetic/de-identified only |
| Logging: no sensitive payload | N/A | Recommended | Required | Required + field-level rules |
| Retention / deletion | Per policy | Per policy | Defined schedule | Legal/regulatory schedule |
| Third-party sharing | N/A | Vendor review | DPA + security review | BAA / PCI / SCC as applicable |
| Breach notification | Low | Internal process | Escalate to security + legal | Regulatory timelines |

---

## Labeling rules

1. **Classify the highest sensitivity** present in the application or data store (“high water mark”).
2. **Document data flows** in threat models and architecture diagrams with classification per flow.
3. **Re-classify** when the app gains new data types, integrations, or geographic scope.
4. **Map to risk tier:** Regulated or large-volume Confidential data often drives `risk_tier` **medium** or **high** — use [risk-tier-rubric.md](risk-tier-rubric.md).

---

## Registry mapping

| Registry field | How to populate |
|----------------|-----------------|
| `data_classification` | One primary label: `public` \| `internal` \| `confidential` \| `regulated` |
| `customer_data_types` | Optional list: e.g. `email`, `payment`, `health`, `government_id` |
| `compliance_tags` | Optional: regimes or frameworks that apply |

---

## Examples (customize)

| Application type | Typical classification | Notes |
|------------------|------------------------|-------|
| Public marketing site | Public | No authenticated customer data |
| Internal admin tool | Internal or Confidential | Depends on data shown |
| Customer SaaS with accounts | Confidential | PII + credentials |
| Payment checkout | Regulated | PCI scope — document scope reduction (tokenization) |
| Clinical portal | Regulated | PHI — BAA and audit controls |

---

## Review

- **Owner:** Data governance or AppSec with privacy/legal input.
- **Cadence:** Annual, or when regulations or product surface change materially.

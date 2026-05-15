# ADR-NNNN: [Short title]

**Status:** Proposed | Accepted | Deprecated | Superseded by [ADR-XXXX]

**Date:** YYYY-MM-DD

**Deciders:** [names or roles]

**Consulted:** [AppSec, platform, legal — as applicable]

---

## Context

What is the issue or driver? What constraints exist (timeline, compliance, existing stack)?

---

## Decision

What did we decide? State clearly — one or two paragraphs.

---

## Consequences

**Positive:**

-

**Negative / tradeoffs:**

-

**Neutral:**

-

---

## Security implications

*Required for AppSec program alignment. If “None,” state why.*

| Topic | Impact | Follow-up |
|-------|--------|-----------|
| **Trust boundaries** | Changed / unchanged — describe | |
| **Data classification** | Classes touched; flows affected | See [data-classification-scheme.md](data-classification-scheme.md) |
| **Authentication / authorization** | | |
| **Secrets / crypto** | New keys, algorithms, storage | |
| **Logging / privacy** | PII in logs, retention | |
| **Dependencies / supply chain** | New vendors or packages | |
| **Exposure** | Internet-facing, new APIs, admin surfaces | |

**Threat model:** Required? Yes / No — link: [threat-model-template.md](threat-model-template.md) instance or ticket

**Security requirements / tickets:**

| ID | Action | Owner | Due |
|----|--------|-------|-----|
| | | | |

**Residual risk / exceptions:** None, or link [exception-request-form.md](exception-request-form.md)

---

## Compliance and policy

| Control / standard | Notes |
|--------------------|-------|
| AppSec policy baseline | e.g. triggers CI gate, DAST, release evidence |
| ASVS / SSDF (optional) | |

---

## References

- Related ADRs:
- Design docs / diagrams:
- Tickets:

---

## Storage

Place under `docs/adr/` (or your org’s ADR path). Number sequentially (`ADR-0001`, …).

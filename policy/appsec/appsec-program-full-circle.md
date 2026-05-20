# Application security program — full-circle overview

**Navigation:** Start at the [documentation home](README.md) for adoption order, policy links, and CI reference.

**Policy alignment:** Normative requirements are in the [policy baseline](framework/appsec-policy-baseline.md). [**Policy and process alignment**](policy-process-alignment.md) maps phases 01–06 to controls, evidence, and known gaps.

**How to use this page:** This document explains the **end-to-end operating model**—what happens in each SDLC phase and how the phases connect. **Operational detail** (activities, tooling, pitfalls, metrics) lives in the phase guides [`01`](program/01-plan-and-design.md) through [`06`](program/06-improve-and-govern.md). **Runnable CI jobs** are documented in the [scanner reference](README.md#scanner-runbooks-and-ci-templates) and [CI integration](README.md#using-these-runbooks-in-your-own-repository) (reference implementations under `runbooks/appsec/` in the program source tree).

---

## Goal

Define a practical application security program that can start simple, run in CI/CD, and mature over time without blocking delivery.

Corporate Security publishes this model for **operating companies and engineering**. Teams implement controls approved for each **risk tier**; consumption may be from a **corporate golden repository** or a divisional package that meets or exceeds corporate minimums.

---

## Program outcomes

- Prevent high-risk vulnerabilities from reaching production
- Detect issues early in the developer workflow and in CI
- Reduce false positives and triage time with clear severity policy
- Create repeatable, auditable security controls
- Track risk and remediation with clear ownership

---

## Framework positioning (OWASP SAMM)

OWASP SAMM describes **maturity** (“what good looks like” at scale). This program describes **how** teams operate day to day and how controls are evidenced.

| Lens | Where to read |
|------|----------------|
| **Maturity assessment** | [OWASP SAMM reference](program/framework-owasp-samm.md) · [SAMM coverage checklist](program/samm-coverage-checklist.md) |
| **Normative requirements** | [Policy baseline](framework/appsec-policy-baseline.md) · [Severity policy](framework/severity-policy.md) |
| **Evidence and automation** | [Policy evidence mapping](framework/policy-evidence-mapping.yaml) |
| **Rollout tracking** | [Implementation master checklist](program/implementation-master-checklist.md) |

Use SAMM to assess and prioritize improvements. Use the phase guides and approved jobs to execute them.

---

## Full-circle lifecycle (phases 01–06)

Security work runs **continuously** across the SDLC—not only at release. Each phase has a dedicated guide; follow the links for objectives, tooling, minimum process, and success metrics.

**Flow:** 01 → 02 → 03 → 04 → 05 across delivery; **06** governs and improves all phases on a recurring cadence.

| Phase | Purpose (summary) | Phase guide |
|-------|-------------------|-------------|
| **01 — Plan and design** | Requirements, threat modeling, classification, architecture review before build | [01-plan-and-design](program/01-plan-and-design.md) |
| **02 — Build and commit** | Secure coding, fast feedback, SAST/secrets/dependency checks on PRs | [02-build-and-commit](program/02-build-and-commit.md) |
| **03 — CI gate** | Required scanners, severity gates, artifacts, exceptions before merge/release | [03-ci-gate](program/03-ci-gate.md) |
| **04 — Release and deploy** | Artifact/image/IaC validation, SBOM, release sign-off | [04-release-and-deploy](program/04-release-and-deploy.md) |
| **05 — Runtime and operate** | External exposure, scheduled rescans, alerts, incident response | [05-runtime-and-operate](program/05-runtime-and-operate.md) |
| **06 — Improve and govern** | Metrics, tuning, exceptions, training, quarterly review, roadmap | [06-improve-and-govern](program/06-improve-and-govern.md) |

Phase **06** feeds back into all earlier phases: rule tuning, policy updates, training, and maturity planning close the loop.

---

## OWASP SAMM mapping (high level)

| SAMM area | Primary phase guides |
|-----------|----------------------|
| **Governance** | [01](program/01-plan-and-design.md), [06](program/06-improve-and-govern.md) |
| **Design** | [01](program/01-plan-and-design.md) |
| **Implementation** | [02](program/02-build-and-commit.md) |
| **Verification** | [03](program/03-ci-gate.md) + [scanner runbooks](README.md#scanner-runbooks-and-ci-templates) |
| **Operations** | [04](program/04-release-and-deploy.md), [05](program/05-runtime-and-operate.md) |

Deeper practice-level mapping: [framework-owasp-samm.md](program/framework-owasp-samm.md).

---

## Reference controls (today)

The corporate program is **capability-based** in policy; the **reference package** ships OSS-oriented jobs for common controls:

| Capability | Typical phase | Detail |
|------------|---------------|--------|
| SAST, secrets, SCA | 02, 03 | [03 CI gate](program/03-ci-gate.md) · [Scanner table](README.md#scanner-runbooks-and-ci-templates) |
| DAST (baseline + templates) | 03, 05 | Same |
| Severity normalization | 03, 06 | [Severity policy](framework/severity-policy.md) |
| Release / runtime (partial) | 04, 05 | Phase guides; several items on [roadmap](README.md#known-gaps-and-roadmap) |

No single scanner covers every vulnerability class; defense in depth plus process maturity is the target state.

---

## Roadmap and gaps

Items not yet fully packaged as first-class runbooks (IaC, image scan, SBOM, aggregation, training depth, etc.) are listed in [Known gaps and roadmap](README.md#known-gaps-and-roadmap). Assign owners and dates in the [implementation master checklist](program/implementation-master-checklist.md).

Program-level extensions (training paths, vendor review, executive reporting) are outlined in [06 — Improve and govern](program/06-improve-and-govern.md#adoption-paths) (scaled adoption path).

---

## Related documentation

- [Documentation home](README.md) — adoption order and audience guide
- [Policy ↔ process alignment](policy-process-alignment.md) — control crosswalk and minimum operating path
- [Glossary](glossary.md)

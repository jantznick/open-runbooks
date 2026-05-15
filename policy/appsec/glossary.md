# AppSec program glossary

Short, shared definitions for this repository’s policy, templates, and phase docs. For normative requirements, see the [policy baseline](framework/appsec-policy-baseline.md).

---

## A–C

**Application** — A deployable unit with its own lifecycle, repository(ies), and business purpose. Registered in the metadata catalog with `app_id`, owners, and `risk_tier`.

**AppSec (application security)** — Practices that reduce risk in how software is designed, built, verified, released, and operated. In this program, **Corporate Security** publishes the template; operating companies implement it.

**ASVS (OWASP Application Security Verification Standard)** — A checklist of security requirements used to define and verify what “secure enough” means for an app type or tier.

**CI gate** — Automated checks that must pass before merge or release (e.g. SAST, secrets, SCA, DAST, severity thresholds). See [severity policy](framework/severity-policy.md).

**Compensating control** — A measure that reduces risk when a primary control is waived (e.g. manual review, monitoring, network restriction). Required on [exceptions](templates/exception-request-form.md).

**DAST (dynamic application security testing)** — Testing a running application from the outside (HTTP/API) to find issues visible to an attacker. Baseline DAST is required for **internet-facing** apps before production.

---

## D–E

**Data classification** — Label for sensitivity of data handled by an app (`public`, `internal`, `confidential`, `regulated`). See [data-classification-scheme](templates/data-classification-scheme.md).

**Evidence** — Proof that a control ran and met pass criteria. **Layer 1** = policy text; **Layer 2** = artifacts and metadata (CI job results, tickets, threat models) mapped in [`policy-evidence-mapping.yaml`](framework/policy-evidence-mapping.yaml).

**Exception / risk acceptance** — Time-bound, approved bypass of a MUST control or severity gate, with owner, justification, compensating controls, and expiry. Not a substitute for fixing root cause.

---

## G–I

**Golden repo (corporate)** — Internal repository maintained by Corporate Security with approved runbooks and workflows; operating companies copy or submodule from it instead of ad-hoc paste from public upstream.

**High-impact change** — Work affecting authentication, authorization, sensitive data flows, trust boundaries, or public exposure. Triggers stronger design review and security requirements.

**Internet-facing** — Untrusted networks (e.g. public internet) can reach the application or its APIs. Metadata field `internet_facing`; drives DAST and threat-model expectations.

---

## L–P

**Layer 1 / Layer 2** — Layer 1 is normative policy (what you must do). Layer 2 is how you prove it (evidence types, pass criteria, registry fields). See [policy baseline](framework/appsec-policy-baseline.md) and [evidence mapping](framework/policy-evidence-mapping.yaml).

**Policy and process alignment** — Crosswalk linking [policy baseline](framework/appsec-policy-baseline.md) controls to [full-circle](appsec-program-full-circle.md) phases 01–06. See [policy-process-alignment.md](policy-process-alignment.md).

**Metadata registry / application catalog** — System of record for per-app fields (`risk_tier`, `data_classification`, `repo_url`, `ci_provider`, etc.). Used to scope controls and correlate CI evidence.

**OWASP SAMM** — Software Assurance Maturity Model: a framework to assess and improve AppSec capabilities over time. This repo uses SAMM for maturity; phase docs and runbooks for implementation. See [framework-owasp-samm.md](program/framework-owasp-samm.md).

**Production release** — A change promoted to an environment used by end users. Requires release security evidence per policy.

**PR security checklist** — Pull-request prompts for security impact (auth, data, dependencies, secrets). Template: [pr-security-checklist.md](templates/pr-security-checklist.md).

---

## R–S

**Risk tier** — Application criticality label: `low` | `medium` | `high`. Drives scan strictness, SLAs, and design-review depth. Assigned with [risk-tier-rubric.md](templates/risk-tier-rubric.md).

**SAST (static application security testing)** — Analysis of source or bytecode without running the app (e.g. Semgrep, Snyk Code).

**SBOM (software bill of materials)** — Machine-readable inventory of components in a build (SPDX, CycloneDX). SHOULD for production releases; supports supply-chain and incident response.

**SCA (software composition analysis)** — Scanning dependencies for known vulnerabilities and license issues (e.g. Trivy, Snyk Open Source).

**Secrets scanning** — Detecting credentials, API keys, and tokens in code and history. Distinct from SAST; both are required in CI. Verified live secrets **always block** merge per [severity policy](framework/severity-policy.md).

**Severity** — Normalized finding criticality: `critical`, `high`, `medium`, `low`, `info`. Gates and SLAs are defined in [severity-policy.yaml](framework/severity-policy.yaml).

**SSDF (NIST Secure Software Development Framework)** — Practices for secure software development; referenced alongside ASVS in policy.

**STRIDE** — Threat-modeling mnemonic (Spoofing, Tampering, Repudiation, Information disclosure, Denial of service, Elevation of privilege). Used in [threat-model-template.md](templates/threat-model-template.md).

---

## T–Z

**Threat modeling** — Structured analysis of assets, trust boundaries, and threats before or during implementation. Required for internet-facing and medium/high-tier scope per policy.

**Trust boundary** — Line where trust level changes (e.g. user browser → API, API → database). Documented in threat models and architecture diagrams.

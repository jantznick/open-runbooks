# Corporate application security program — documentation

This is the **documentation home** for the corporate application security (AppSec) program. It links **normative policy**, the **end-to-end operating model** (phases 01–06), **policy ↔ process alignment**, reference **CI controls**, and **standard forms**. Use it as the primary entry point when browsing this documentation set in a portal or catalog.

**Corporate Security** maintains this material for **operating companies and engineering**. **Subsidiary or divisional** security teams may tailor distribution paths while **meeting or exceeding** the corporate minimums described in the [policy baseline](framework/appsec-policy-baseline.md).

**Policy and process:** The [policy baseline](framework/appsec-policy-baseline.md) states *what* is required. The [full-circle program overview](appsec-program-full-circle.md) and phases `01`–`06` describe *how* to operate across the SDLC. [**Policy and process alignment**](policy-process-alignment.md) shows how following the program satisfies policy controls, where evidence is recorded, and what remains optional or in roadmap.

---

## What this documentation covers

1. **Policy and operating model** — Phases [`01`](program/01-plan-and-design.md) through [`06`](program/06-improve-and-govern.md) ([shared phase structure](program/README.md)), the [full-circle overview](appsec-program-full-circle.md), [OWASP SAMM reference](program/framework-owasp-samm.md), and rollout tracking ([implementation master checklist](program/implementation-master-checklist.md)).
2. **Normative controls** — [AppSec policy baseline](framework/appsec-policy-baseline.md), [severity and CI gates](framework/severity-policy.md), and [contextual enhancements](framework/appsec-policy-baseline-contextual-enhancements.md) where regulations or data types apply.
3. **Evidence and automation** — [Policy ↔ evidence mapping](framework/policy-evidence-mapping.yaml) (metadata fields, job types, pass criteria for catalogs and CI integration).
4. **Standard forms** — [Templates](templates/) (risk tier, classification, threat model, ADR, PR checklist, exceptions, release sign-off).
5. **Reference CI controls** — Runnable scanner jobs and pipeline snippets documented under [`runbooks/appsec/`](../../runbooks/appsec/) in the program source tree; engineering **installs** the jobs Corporate Security approves per application tier (see [Using these runbooks in your own repository](#using-these-runbooks-in-your-own-repository)).

Some sections describe **roadmap items** or **SHOULD** controls not yet packaged as first-class runbooks. Those are called out in [Known gaps and roadmap](#known-gaps-and-roadmap).

---

## Publishing in a documentation catalog

If you ingest only this documentation tree into a portal (Markdown → HTML):

- **Relative links** between pages assume the **same folder layout** as here (`framework/`, `program/`, `templates/`, etc.). Preserve paths when importing.
- Links to **`../../runbooks/appsec/`** or **`../../test-app-vulnerable-todo/`** point to **reference implementation** assets outside `/policy/appsec/`. Either copy those assets to a URL your catalog can reach and update links, or replace them with pointers to your **internal golden repository** where scanner jobs are hosted.

---

## Optional: validating CI controls (reference)

To exercise reference pipelines locally or in GitHub Actions, see the walkthrough and setup guides (paths are relative to the **program source repository**):

- [Demo: security CI walkthrough](../../runbooks/appsec/demo-github-security-ci-walkthrough.md)
- [Setup: GitHub Actions](../../runbooks/appsec/setup-github-actions.md)

Use an approved test application or sandbox; do not run ad hoc scans against production without authorization.

---

## Audience guide

| Role | Start here | Then |
|------|------------|------|
| **Corporate Security / central AppSec** | This page + [policy baseline](framework/appsec-policy-baseline.md) | Golden source for jobs, policy interpretation, rollouts |
| **Sponsor / leadership** | [Program overview](appsec-program-full-circle.md) | [Policy ↔ process alignment](policy-process-alignment.md) · [Policy baseline](framework/appsec-policy-baseline.md) |
| **AppSec program owner (BU or subsidiary)** | [Recommended adoption order](#recommended-adoption-order-policy-through-maturity) | [Implementation master checklist](program/implementation-master-checklist.md) |
| **Engineering lead / platform** | [03 CI Gate](program/03-ci-gate.md) + [Scanner runbooks and CI templates](#scanner-runbooks-and-ci-templates) | [Policy evidence mapping](framework/policy-evidence-mapping.yaml) |
| **Engineering teams (service repos)** | [Recommended adoption order](#recommended-adoption-order-policy-through-maturity) + [CI integration](#using-these-runbooks-in-your-own-repository) | Approved `*-basic.md` guides and tier configuration from Corporate Security |
| **Developers** | [02 Build and commit](program/02-build-and-commit.md) | Scanner guides linked from the table below |

---

## Recommended adoption order (policy through maturity)

Follow in order for initial rollout. **Corporate Security** typically leads steps 1–3 with policy and risk owners; operating units execute steps 4–6 with engineering.

### Step 1 — Understand the model

1. [Full-circle program overview](appsec-program-full-circle.md) — how phases 01–06 connect; SAMM positioning.
2. [OWASP SAMM reference](program/framework-owasp-samm.md) — maturity assessment versus day-to-day implementation.

**Outcome:** Shared vocabulary for “full circle” AppSec and how SAMM fits the program.

---

### Step 2 — Establish policy and evidence (Layer 1–2)

1. Adopt and publish the [AppSec policy baseline](framework/appsec-policy-baseline.md) with MUST/SHOULD, risk tiers, severities, and exceptions approved by **legal / GRC** as applicable.
2. Align [Policy evidence mapping](framework/policy-evidence-mapping.yaml) with the **application catalog or metadata platform** (fields, job types, artifacts, pass criteria).

**Outcome:** Normative policy and measurable evidence for compliance views.

---

### Step 3 — Plan the rollout

Use the [implementation master checklist](program/implementation-master-checklist.md) as the execution tracker (owners, dates, evidence per workstream).

**Outcome:** Controlled rollout without undocumented gaps.

---

### Step 4 — Run the lifecycle (phases 01–06)

Execute work **in lifecycle order**; each phase maps to SAMM practices.

| Order | Phase | Document |
|------:|-------|----------|
| 1 | Plan and design | [01-plan-and-design.md](program/01-plan-and-design.md) |
| 2 | Build and commit | [02-build-and-commit.md](program/02-build-and-commit.md) |
| 3 | CI gate | [03-ci-gate.md](program/03-ci-gate.md) |
| 4 | Release and deploy | [04-release-and-deploy.md](program/04-release-and-deploy.md) |
| 5 | Runtime and operate | [05-runtime-and-operate.md](program/05-runtime-and-operate.md) |
| 6 | Improve and govern | [06-improve-and-govern.md](program/06-improve-and-govern.md) |

**Outcome:** Repeatable process per team; scanners align with phase 3 (and parts of 4–5).

---

### Step 5 — Implement technical controls

Deploy the CI jobs **Corporate Security** mandates for each **risk tier**. Reference implementations use Docker-based shell runbooks and workflow templates.

See [Scanner runbooks and CI templates](#scanner-runbooks-and-ci-templates) and [Using these runbooks in your own repository](#using-these-runbooks-in-your-own-repository).

**Outcome:** Pipelines produce artifacts that match the evidence mapping.

---

### Step 6 — Measure maturity (SAMM)

1. Complete [SAMM coverage checklist](program/samm-coverage-checklist.md) with current/target state and evidence links.
2. Revisit on a quarterly cadence; feed gaps into the [implementation checklist](program/implementation-master-checklist.md).

**Outcome:** Visible improvement planning, not ad hoc effort.

---

## Documentation structure

Paths below are relative to the **application security program documentation** root (`policy/appsec/` in the source layout).

| Area | Path | Contents |
|------|------|----------|
| **Documentation home** | `README.md` (this page) | Navigation, adoption order, CI reference |
| **Program strategy** | `appsec-program-full-circle.md` | Lifecycle overview; links to phases 01–06 |
| **Policy and evidence** | `framework/` | Policy baseline, severity policy, evidence mapping YAML |
| **Lifecycle and SAMM** | `program/` | Phase guides `01`–`06`, SAMM reference, checklists |
| **Standard forms** | `templates/` | Risk tier, classification, threat model, ADR, PR, exception, release |
| **Alignment** | `policy-process-alignment.md` | Policy ↔ process crosswalk and assurance |
| **Glossary** | `glossary.md` | Shared definitions |
| **Reference CI jobs** | `runbooks/appsec/` (outside this tree in source) | Shell scripts, workflow templates, per-control guides |

Program documentation and reference jobs may live in separate repositories in your enterprise; cross-links should be adjusted when publishing.

---

## Using these runbooks in your own repository

**GitHub Actions (step-by-step):** [setup-github-actions.md](../../runbooks/appsec/setup-github-actions.md)

Approved workflow templates assume jobs run from the **service repository root** with shell scripts at **`runbooks/appsec/<name>.sh`** (see each `github-actions-*.yml` `run:` line). To adopt a control:

1. **Install** the shell scripts under **`runbooks/appsec/`** from the repository root (create directories if missing), unless Corporate Security publishes a different path—then update workflow `run:` lines consistently.
2. **Install** the matching GitHub Actions file from [`github-actions-*.yml`](../../runbooks/appsec/) into **`.github/workflows/`** (filename flexible; align `name:` and triggers with standards).
3. **GitLab:** merge the matching [`gitlab-ci-*.yml`](../../runbooks/appsec/) fragment into **`.gitlab-ci.yml`** or use `include:` per platform practice.
4. **Secrets and variables:** follow each control’s `*-basic.md` guide for approved secrets (e.g. `SNYK_TOKEN`) and optional variables (`SAST_SCAN_PATH`, etc.).
5. **LLM-assisted PR review:** add prompt files per [pr-llm-security-review.md](../../runbooks/appsec/pr-llm-security-review.md) only where policy permits external model processing.
6. **Program documentation** may be linked for context; it is **not** required inside the service repo for scanners to run.

### Staying current with upstream runbooks

The service repository **owns** the jobs it installs. Updates are distributed when **Corporate Security** (or divisional security) publishes a new **approved baseline**.

| Approach | Summary | Tradeoff |
|----------|---------|----------|
| **Controlled re-install** | Re-copy approved `.sh` and YAML when Corporate Security issues a release or bulletin. | Simple; depends on clear communication. |
| **Git submodule** | Vendor the golden package (e.g. under `vendor/…`) and point CI at that path; update submodule when approved. | Requires path discipline in workflows. |
| **`git subtree`** | Merge the runbook tree into a monorepo on an approved cadence. | Single repo; heavier history. |
| **Corporate golden repository (recommended at scale)** | Corporate Security maintains the canonical package; operating units install or invoke jobs from it. | Strongest alignment with policy and audit. |
| **Division fork** | A business unit maintains an approved fork with local tooling; must stay at or above corporate minimums. | Flexibility; reconcile drift periodically. |

Corporate policy should require **pinning** or subscribing to a **Corporate Security–approved** source—not unreviewed auto-tracking of external default branches.

---

## Scanner runbooks and CI templates

| Control | Script | Guide | GitHub Actions | GitLab CI |
|---------|--------|-------|----------------|-----------|
| SAST | [sast-semgrep-opengrep-basic.sh](../../runbooks/appsec/sast-semgrep-opengrep-basic.sh) | [sast-semgrep-opengrep-basic.md](../../runbooks/appsec/sast-semgrep-opengrep-basic.md) | [github-actions-sast.yml](../../runbooks/appsec/github-actions-sast.yml) | [gitlab-ci-sast.yml](../../runbooks/appsec/gitlab-ci-sast.yml) |
| SAST (Snyk Code) | [sast-snyk-code-basic.sh](../../runbooks/appsec/sast-snyk-code-basic.sh) | [sast-snyk-code-basic.md](../../runbooks/appsec/sast-snyk-code-basic.md) | [github-actions-sast-snyk.yml](../../runbooks/appsec/github-actions-sast-snyk.yml) | [gitlab-ci-sast-snyk.yml](../../runbooks/appsec/gitlab-ci-sast-snyk.yml) |
| Secrets | [secrets-trufflehog-basic.sh](../../runbooks/appsec/secrets-trufflehog-basic.sh) | [secrets-trufflehog-basic.md](../../runbooks/appsec/secrets-trufflehog-basic.md) | [github-actions-secrets-trufflehog.yml](../../runbooks/appsec/github-actions-secrets-trufflehog.yml) | [gitlab-ci-secrets-trufflehog.yml](../../runbooks/appsec/gitlab-ci-secrets-trufflehog.yml) |
| SCA | [sca-trivy-basic.sh](../../runbooks/appsec/sca-trivy-basic.sh) | [sca-trivy-basic.md](../../runbooks/appsec/sca-trivy-basic.md) | [github-actions-sca-trivy.yml](../../runbooks/appsec/github-actions-sca-trivy.yml) | [gitlab-ci-sca-trivy.yml](../../runbooks/appsec/gitlab-ci-sca-trivy.yml) |
| SCA (Snyk Open Source) | [sca-snyk-basic.sh](../../runbooks/appsec/sca-snyk-basic.sh) | [sca-snyk-basic.md](../../runbooks/appsec/sca-snyk-basic.md) | [github-actions-sca-snyk.yml](../../runbooks/appsec/github-actions-sca-snyk.yml) | [gitlab-ci-sca-snyk.yml](../../runbooks/appsec/gitlab-ci-sca-snyk.yml) |
| DAST (ZAP) | [dast-zap-basic.sh](../../runbooks/appsec/dast-zap-basic.sh) | [dast-zap-basic.md](../../runbooks/appsec/dast-zap-basic.md) | [github-actions-dast-zap.yml](../../runbooks/appsec/github-actions-dast-zap.yml) | [gitlab-ci-dast-zap.yml](../../runbooks/appsec/gitlab-ci-dast-zap.yml) |
| DAST (Nuclei) | [dast-nuclei-basic.sh](../../runbooks/appsec/dast-nuclei-basic.sh) | [dast-nuclei-basic.md](../../runbooks/appsec/dast-nuclei-basic.md) | [github-actions-dast-nuclei.yml](../../runbooks/appsec/github-actions-dast-nuclei.yml) | [gitlab-ci-dast-nuclei.yml](../../runbooks/appsec/gitlab-ci-dast-nuclei.yml) |
| DAST (Dastardly) | [dast-dastardly-basic.sh](../../runbooks/appsec/dast-dastardly-basic.sh) | [dast-dastardly-basic.md](../../runbooks/appsec/dast-dastardly-basic.md) | [github-actions-dast-dastardly.yml](../../runbooks/appsec/github-actions-dast-dastardly.yml) | [gitlab-ci-dast-dastardly.yml](../../runbooks/appsec/gitlab-ci-dast-dastardly.yml) |
| PR review (LLM, advisory) | — | [pr-llm-security-review.md](../../runbooks/appsec/pr-llm-security-review.md) | [diff](../../runbooks/appsec/github-actions-pr-llm-security-review.yml) · [findings](../../runbooks/appsec/github-actions-pr-llm-security-review-findings.yml) | — |

**Local Docker:** When the scanner runs in a container and the app runs on the host, use `http://host.docker.internal:<port>` as the target, not `http://localhost`.

---

## Practice application (optional)

- [test-app-vulnerable-todo](../../test-app-vulnerable-todo/) — intentional weaknesses for **non-production** validation of SAST, DAST, and secrets jobs.

---

## Known gaps and roadmap

Items documented but **not** necessarily shipped as first-class runbooks in the reference package:

| Gap | Why it matters | Tracked in |
|-----|----------------|------------|
| **IaC / K8s scanning** | Release and deploy assurance | [04 Release and deploy](program/04-release-and-deploy.md) |
| **Container image scanning** (beyond filesystem SCA) | Artifact trust | [04 Release and deploy](program/04-release-and-deploy.md) |
| **SBOM + provenance** | Supply chain and audit | [04 Release and deploy](program/04-release-and-deploy.md) |
| **Single combined baseline pipeline** | One job graph per repo | Roadmap; compose from existing YAML |
| **Training / champions** | SAMM governance depth | [06 Improve and govern](program/06-improve-and-govern.md#adoption-paths) (scaled path) |
| **Central findings aggregation** | Unified triage view | Platform / catalog decision |
| **Risk-tier policy profiles** | Core vs regulated variants | Extend `framework/` when ready |

Use the [implementation master checklist](program/implementation-master-checklist.md) to assign owners and dates.

---

## Quick links

- [Policy ↔ process alignment](policy-process-alignment.md)
- [Program templates](templates/) — risk tier, classification, [threat model (catalog lite)](templates/threat-model-catalog-lite.md), ADR, PR checklist, exception, release sign-off
- [GitHub Actions setup](../../runbooks/appsec/setup-github-actions.md)
- [Full-circle overview](appsec-program-full-circle.md)
- [Policy baseline](framework/appsec-policy-baseline.md) · [Severity policy](framework/severity-policy.md) · [Glossary](glossary.md)
- [Policy baseline — minified](framework/appsec-policy-baseline-minified.md) · [Contextual enhancements](framework/appsec-policy-baseline-contextual-enhancements.md)
- [Policy evidence mapping (YAML)](framework/policy-evidence-mapping.yaml)
- [SAMM reference](program/framework-owasp-samm.md) · [SAMM coverage checklist](program/samm-coverage-checklist.md)
- [Implementation master checklist](program/implementation-master-checklist.md)

**Repository index:** The [root README](../../README.md) lists the full source tree including reference runbooks.

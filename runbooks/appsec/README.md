# AppSec program — start here

This folder is an **AppSec program template**: policy, lifecycle playbooks, OWASP SAMM alignment, and runnable scanner runbooks. Use this file as the **main user flow**; the root repo [README](../../README.md) stays a short index.

---

## Who you are → where to go

| Role | Start with | Then |
|------|------------|------|
| **Sponsor / leadership** | [Program overview](appsec-program-full-circle.md) (outcomes, baseline, gaps) | [Policy baseline](framework/appsec-policy-baseline.md) (what “must” be true) |
| **AppSec / security program owner** | This page (journey below) | [Implementation master checklist](program/implementation-master-checklist.md) |
| **Engineering lead / platform** | [03 CI Gate](program/03-ci-gate.md) + [scanner runbooks](#scanner-runbooks-and-ci-templates) | [Policy evidence mapping](framework/policy-evidence-mapping.yaml) (metadata integration) |
| **Developers** | [02 Build and Commit](program/02-build-and-commit.md) | Individual scanner guides linked below |

---

## User journey: running the program (recommended order)

Follow these steps in order the first time you adopt or reuse this template.

### Step 1 — Understand the model

Read once so everyone shares the same vocabulary.

1. [Full-circle program overview](appsec-program-full-circle.md) — lifecycle, current tooling, known gaps, SAMM positioning.
2. [OWASP SAMM reference](program/framework-owasp-samm.md) — how SAMM relates to this repo (maturity vs implementation).

**Outcome:** You know what “full circle” means here and that SAMM scores maturity; this repo supplies runbooks and policy templates.

---

### Step 2 — Define policy and evidence (Layer 1–2)

1. Copy and customize [AppSec policy baseline](framework/appsec-policy-baseline.md) to match your cyber / AppSec policy (MUST/SHOULD, risk tiers, severities, exceptions).
2. Align [Policy → evidence mapping](framework/policy-evidence-mapping.yaml) with your **application metadata** system (fields, job types, artifact types, pass criteria).

**Outcome:** Controls are normative; your platform can evaluate compliance from metadata + evidence.

---

### Step 3 — Plan the rollout

Use [Implementation master checklist](program/implementation-master-checklist.md) as the **single project tracker** (owners, dates, evidence per workstream).

**Outcome:** No silent gaps between “we have docs” and “we are operating.”

---

### Step 4 — Operate the lifecycle (phases 01–06)

Execute work **in lifecycle order**; each phase doc maps to SAMM and links forward.

| Order | Phase | Document |
|------:|-------|----------|
| 1 | Plan and design | [01-plan-and-design.md](program/01-plan-and-design.md) |
| 2 | Build and commit | [02-build-and-commit.md](program/02-build-and-commit.md) |
| 3 | CI gate | [03-ci-gate.md](program/03-ci-gate.md) |
| 4 | Release and deploy | [04-release-and-deploy.md](program/04-release-and-deploy.md) |
| 5 | Runtime and operate | [05-runtime-and-operate.md](program/05-runtime-and-operate.md) |
| 6 | Improve and govern | [06-improve-and-govern.md](program/06-improve-and-govern.md) |

**Outcome:** Process is repeatable per team; scanners plug into step 3 (and parts of 4–5).

---

### Step 5 — Wire technical controls (scanners)

Add the runbooks your policy requires. Defaults in this repo are **Docker-based** and CI-oriented.

See [Scanner runbooks and CI templates](#scanner-runbooks-and-ci-templates) below.

**Outcome:** Pipelines produce artifacts that satisfy your evidence mapping.

---

### Step 6 — Measure maturity (SAMM)

1. Fill [SAMM coverage checklist](program/samm-coverage-checklist.md) with current/target and evidence links.
2. Revisit quarterly; tie improvements back to the [implementation checklist](program/implementation-master-checklist.md).

**Outcome:** Program improvement is explicit, not ad hoc.

---

## Repository layout (how this folder is organized)

| Area | Path | Purpose |
|------|------|---------|
| **Entry / journey** | `runbooks/appsec/README.md` (this file) | User flow and navigation |
| **Program strategy** | `appsec-program-full-circle.md` | Overview, tooling summary, gaps backlog |
| **Policy & evidence** | `framework/` | Normative policy template + YAML for metadata/evidence mapping |
| **Lifecycle & SAMM** | `program/` | Phase guides (`01`–`06`), SAMM docs, checklists, implementation tracker |
| **Scanners + CI** | `runbooks/appsec/*.sh`, `*.md`, `github-actions-*.yml`, `gitlab-ci-*.yml` | Runnable controls and copy-paste pipelines |

Scanner scripts and guides live **next to** `framework/` and `program/` on purpose: easy to find from CI and from this README. A future refactor could move them under `scanners/`; if you do that, update links in this file and in the root README.

---

## Scanner runbooks and CI templates

| Control | Script | Guide | GitHub Actions | GitLab CI |
|---------|--------|-------|----------------|-----------|
| SAST | [sast-semgrep-opengrep-basic.sh](sast-semgrep-opengrep-basic.sh) | [sast-semgrep-opengrep-basic.md](sast-semgrep-opengrep-basic.md) | [github-actions-sast.yml](github-actions-sast.yml) | [gitlab-ci-sast.yml](gitlab-ci-sast.yml) |
| Secrets | [secrets-trufflehog-basic.sh](secrets-trufflehog-basic.sh) | [secrets-trufflehog-basic.md](secrets-trufflehog-basic.md) | [github-actions-secrets-trufflehog.yml](github-actions-secrets-trufflehog.yml) | [gitlab-ci-secrets-trufflehog.yml](gitlab-ci-secrets-trufflehog.yml) |
| SCA | [sca-trivy-basic.sh](sca-trivy-basic.sh) | [sca-trivy-basic.md](sca-trivy-basic.md) | [github-actions-sca-trivy.yml](github-actions-sca-trivy.yml) | [gitlab-ci-sca-trivy.yml](gitlab-ci-sca-trivy.yml) |
| DAST (ZAP) | [dast-zap-basic.sh](dast-zap-basic.sh) | [dast-zap-basic.md](dast-zap-basic.md) | [github-actions-dast-zap.yml](github-actions-dast-zap.yml) | [gitlab-ci-dast-zap.yml](gitlab-ci-dast-zap.yml) |
| DAST (Nuclei) | [dast-nuclei-basic.sh](dast-nuclei-basic.sh) | [dast-nuclei-basic.md](dast-nuclei-basic.md) | [github-actions-dast-nuclei.yml](github-actions-dast-nuclei.yml) | [gitlab-ci-dast-nuclei.yml](gitlab-ci-dast-nuclei.yml) |
| DAST (Dastardly) | [dast-dastardly-basic.sh](dast-dastardly-basic.sh) | [dast-dastardly-basic.md](dast-dastardly-basic.md) | [github-actions-dast-dastardly.yml](github-actions-dast-dastardly.yml) | [gitlab-ci-dast-dastardly.yml](gitlab-ci-dast-dastardly.yml) |

**Local Docker tip:** From the host, use `http://host.docker.internal:<port>` as the scan target, not `http://localhost`, when the scanner runs inside a container.

---

## Demo application

- [test-app-vulnerable-todo](../../test-app-vulnerable-todo/) — intentional vulnerabilities for validating SAST/DAST/secrets runbooks.

---

## Known gaps (program not “final” — intentional)

These are **documented but not fully implemented** as first-class runbooks or org-specific artifacts. They often surface when you follow the journey above.

| Gap | Why it matters | Where tracked |
|-----|----------------|----------------|
| **IaC / K8s scanning** | Release/deploy assurance | [appsec-program-full-circle.md](appsec-program-full-circle.md) Known Gaps |
| **Container image scanning** (distinct from filesystem SCA) | Artifact trust | Same |
| **SBOM + provenance** | Supply chain / audit | Same + [04-release-and-deploy.md](program/04-release-and-deploy.md) |
| **Single combined “baseline” pipeline** | One job graph per repo | Backlog; compose from existing YAML |
| **Threat model / ADR / exception templates** | Design & governance evidence | [01](program/01-plan-and-design.md), [implementation checklist](program/implementation-master-checklist.md) |
| **Training / champions package** | SAMM Governance depth | [Future components](appsec-program-full-circle.md) |
| **Central findings aggregation** | One view across tools | Not in repo; your metadata platform |
| **Risk-tier profiles** (core vs regulated) | Policy variants | Extend `framework/` with profile overlays when ready |

Use the [implementation master checklist](program/implementation-master-checklist.md) to turn gaps into dated, owned work.

---

## Quick links (all program assets)

- [Full-circle overview](appsec-program-full-circle.md)
- [Policy baseline](framework/appsec-policy-baseline.md) · [Policy baseline — controls only](framework/appsec-policy-baseline-minified.md) · [Contextual policy enhancements](framework/appsec-policy-baseline-contextual-enhancements.md) (PII, PHI, PCI, etc.)
- [Policy evidence mapping (YAML)](framework/policy-evidence-mapping.yaml)
- [SAMM reference](program/framework-owasp-samm.md)
- [SAMM coverage checklist](program/samm-coverage-checklist.md)
- [Implementation master checklist](program/implementation-master-checklist.md)

---

*Last structural pass: use this README as the canonical navigation for the AppSec program; extend the “Known gaps” table as you discover missing pieces.*

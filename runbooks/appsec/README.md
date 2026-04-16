# AppSec program — start here

This folder is an **AppSec program template**: policy, lifecycle playbooks, OWASP SAMM alignment, and runnable scanner runbooks. **Corporate Security** (or your centralized AppSec function) publishes this bundle to **operating companies and internal engineering teams** so everyone shares the same minimum bar and the same runnable controls. Use this file as the **main user flow**; the root repo [README](../../README.md) stays a short index.

**What we provide and how teams consume it**

1. **Process and program docs** — We provide phases `01`–`06`, the [policy baseline](framework/appsec-policy-baseline.md), SAMM material, and the [full-circle overview](appsec-program-full-circle.md) so operating units know *what* corporate expects and how it fits together. Several assets are still **draft / in progress**; Corporate Security will refine them—teams should still treat them as **binding guidance** once your organization adopts them, subject to your exception process.
2. **Runnable controls** — We provide each scanner as a **`.sh` runbook** (Docker-based, CI-agnostic) plus optional **`github-actions-*.yml`** / **`gitlab-ci-*.yml`** files that invoke those scripts from repo root. **Corporate policy** (your customized baseline) states *which* controls are required by risk tier; the per-control `*-basic.md` guides list secrets and tuning.
3. **Into service repositories** — Engineering teams **copy** the scripts and workflow snippets Corporate Security approves for their tier into their own repositories (paths matter; see [Using these runbooks in your own repository](#using-these-runbooks-in-your-own-repository)). That remains the default integration model: **opt in per control**, wire secrets per the runbook, and own the pipeline—**unless** your organization mandates consumption from a [corporate golden repo](#staying-current-with-upstream-runbooks) instead of ad-hoc paste.
4. **Staying current** — Copy-paste pins a snapshot. We recommend one of the patterns in [Staying current with upstream runbooks](#staying-current-with-upstream-runbooks) so teams receive **reviewed updates** from Corporate Security rather than blind-tracking public upstream.

## Live demo on GitHub

Fork this repository (or copy its layout), enable Actions, and follow **[demo-github-security-ci-walkthrough.md](demo-github-security-ci-walkthrough.md)**. The repo workflow [`.github/workflows/security-demo-gate.yml`](../../.github/workflows/security-demo-gate.yml) runs Semgrep, Trivy, and TruffleHog against **`test-app-vulnerable-todo`** by default; add the **`SNYK_TOKEN`** repository secret to also run Snyk Code and Snyk Open Source.

**Distributing to an operating company or product team?** Point them to **[Using these runbooks in your own repository](#using-these-runbooks-in-your-own-repository)** below (or share this whole file). That section is the canonical “what to copy where” checklist; individual scanner guides only add tool-specific secrets and options. **Subsidiary or divisional security** may maintain their own forked “golden” template (see [Staying current with upstream runbooks](#staying-current-with-upstream-runbooks)) as long as it **meets or exceeds** corporate minimums.

---

## Who you are → where to go

| Role | Start with | Then |
|------|------------|------|
| **Corporate Security / central AppSec** | This page + [policy baseline](framework/appsec-policy-baseline.md) | Own the golden repo, policy interpretation, and reviewed rollouts to operating units |
| **Sponsor / leadership** | [Program overview](appsec-program-full-circle.md) (outcomes, baseline, gaps) | [Policy baseline](framework/appsec-policy-baseline.md) (what corporate policy requires) |
| **AppSec / security program owner (BU or subsidiary)** | This page (journey below) | [Implementation master checklist](program/implementation-master-checklist.md) |
| **Engineering lead / platform** | [03 CI Gate](program/03-ci-gate.md) + [scanner runbooks](#scanner-runbooks-and-ci-templates) | [Policy evidence mapping](framework/policy-evidence-mapping.yaml) (metadata integration) |
| **Engineering teams (service repos)** | This page: [journey](#user-journey-running-the-program-recommended-order) + [copy/paste checklist](#using-these-runbooks-in-your-own-repository) | Per-control `*-basic.md` guides + YAML Corporate Security has approved for your tier |
| **Developers** | [02 Build and Commit](program/02-build-and-commit.md) | Individual scanner guides linked below |

---

## User journey: running the program (recommended order)

Follow these steps in order the first time your organization adopts or reuses this template. **Corporate Security** typically leads steps 1–3 with policy and risk owners; operating companies execute steps 4–6 with engineering.

### Step 1 — Understand the model

Read once so everyone shares the same vocabulary.

1. [Full-circle program overview](appsec-program-full-circle.md) — lifecycle, current tooling, known gaps, SAMM positioning.
2. [OWASP SAMM reference](program/framework-owasp-samm.md) — how SAMM relates to this repo (maturity vs implementation).

**Outcome:** You know what “full circle” means here and that SAMM scores maturity; this repo supplies runbooks and policy templates.

---

### Step 2 — Define policy and evidence (Layer 1–2)

1. Copy and customize [AppSec policy baseline](framework/appsec-policy-baseline.md) so **corporate policy** states MUST/SHOULD, risk tiers, severities, and exceptions for your enterprise (this repo ships a template; your legal and GRC teams finalize wording).
2. Align [Policy → evidence mapping](framework/policy-evidence-mapping.yaml) with your **application metadata** system (fields, job types, artifact types, pass criteria).

**Outcome:** **Corporate policy** is normative once approved; your platform can evaluate compliance from metadata + evidence.

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

See [Scanner runbooks and CI templates](#scanner-runbooks-and-ci-templates) below, and the checklist [Using these runbooks in your own repository](#using-these-runbooks-in-your-own-repository) when copying files into another repository.

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

## Using these runbooks in your own repository

The templates in this folder assume jobs run from the **repository root** and shell scripts live at **`runbooks/appsec/<name>.sh`** (see any `github-actions-*.yml` `run:` line). When an **operating company or product team** adopts a control, they should do the following **in order** (unless Corporate Security instructs you to pull from an internal golden repo instead—see below).

1. **Copy the shell scripts** you need into the same path, **`runbooks/appsec/`**, from the repo root (create the directories if missing). Without that path, pasted workflows will not find the scripts unless you edit every `run:` path.
2. **Copy the matching GitHub Actions file** from [`github-actions-*.yml`](.) into the service repo’s **`.github/workflows/`** (any filename is fine; adjust `name:` / triggers per corporate standards).
3. **GitLab:** copy the matching [`gitlab-ci-*.yml`](.) fragment into **`.gitlab-ci.yml`** or use `include:` as your platform prefers.
4. **Secrets and variables:** open the **guide** (the `*-basic.md` for that control) and configure what **Corporate Security** has approved for your environment (for example `SNYK_TOKEN`, `OPENAI_API_KEY`). Optional tuning often uses repository **variables** (`SAST_SCAN_PATH`, `LLM_MODEL`, and so on); those are documented per guide, not duplicated here.
5. **LLM PR review:** besides the workflow YAML, add the prompt file(s) described in [pr-llm-security-review.md](pr-llm-security-review.md) under `.github/`—only where corporate policy allows sending code or findings to an external model.
6. **Policy / program docs (optional):** teams may copy or link `framework/` and `program/` for context; they are **not** required for scanners to run.

**Fork for demos:** Fork this repository (or a subtree) so paths and demos stay aligned; use [demo-github-security-ci-walkthrough.md](demo-github-security-ci-walkthrough.md) to validate Actions.

### Staying current with upstream runbooks

Copy-paste is intentional and simple: the service repo **owns** the files it copied, and merges updates when **Corporate Security** or your division publishes a new baseline.

If you want **ongoing sync** with the public `open-runbooks` project **or** with your enterprise’s fork, common patterns are:

| Approach | Idea | Tradeoff |
|----------|------|----------|
| **Periodic manual or scripted copy** | Operating teams re-copy `runbooks/appsec/*.sh` and selected YAML when **Corporate Security** issues a bulletin or tagged release. | Lowest magic; relies on clear communication from the center. |
| **Git submodule** | Vendor the corporate or upstream repo under e.g. `vendor/open-runbooks/` and point CI at scripts there **or** symlink—**you must edit** pasted workflow `run:` paths if they no longer match `./runbooks/appsec/...`. | Updates are `git submodule update`; path discipline matters. |
| **`git subtree`** | Pull `runbooks/appsec` into your monorepo on a schedule or when Corporate Security cuts a release. | One repo; history is heavier than submodule; still path-aware. |
| **Corporate golden repo (recommended at scale)** | **Corporate Security maintains an internal Git repository** (the **golden template**) that stays **up to date** with reviewed changes from upstream: we tag releases, document what changed, and **operating companies consume that repo** as the canonical source—e.g. copy from it, submodule it, or invoke shared pipelines that reference it. Service teams **do not** need to track the public repo directly. | Requires Corporate Security ownership and a lightweight release cadence; best alignment with **corporate policy** and audit. |
| **Division / BU fork of the golden repo** | An **operating company or internal platform team** may **fork** the corporate golden repo (or this upstream template) into **their own internal template repository**, customize for local tooling, and still **stay at or above** corporate minimums. Corporate Security should review material deviations. | Flexibility for large orgs; risk of drift without periodic reconciliation. |

There is **no single “always latest”** model that is safe for every enterprise: upstream can change behavior, image tags, or defaults. **Corporate policy** should require either **pinning** to a known revision or **subscribing** to a **Corporate Security–approved** mirror—not blind auto-sync to public `main`.

---

## Scanner runbooks and CI templates

| Control | Script | Guide | GitHub Actions | GitLab CI |
|---------|--------|-------|----------------|-----------|
| SAST | [sast-semgrep-opengrep-basic.sh](sast-semgrep-opengrep-basic.sh) | [sast-semgrep-opengrep-basic.md](sast-semgrep-opengrep-basic.md) | [github-actions-sast.yml](github-actions-sast.yml) | [gitlab-ci-sast.yml](gitlab-ci-sast.yml) |
| SAST (Snyk Code) | [sast-snyk-code-basic.sh](sast-snyk-code-basic.sh) | [sast-snyk-code-basic.md](sast-snyk-code-basic.md) | [github-actions-sast-snyk.yml](github-actions-sast-snyk.yml) | [gitlab-ci-sast-snyk.yml](gitlab-ci-sast-snyk.yml) |
| Secrets | [secrets-trufflehog-basic.sh](secrets-trufflehog-basic.sh) | [secrets-trufflehog-basic.md](secrets-trufflehog-basic.md) | [github-actions-secrets-trufflehog.yml](github-actions-secrets-trufflehog.yml) | [gitlab-ci-secrets-trufflehog.yml](gitlab-ci-secrets-trufflehog.yml) |
| SCA | [sca-trivy-basic.sh](sca-trivy-basic.sh) | [sca-trivy-basic.md](sca-trivy-basic.md) | [github-actions-sca-trivy.yml](github-actions-sca-trivy.yml) | [gitlab-ci-sca-trivy.yml](gitlab-ci-sca-trivy.yml) |
| SCA (Snyk Open Source) | [sca-snyk-basic.sh](sca-snyk-basic.sh) | [sca-snyk-basic.md](sca-snyk-basic.md) | [github-actions-sca-snyk.yml](github-actions-sca-snyk.yml) | [gitlab-ci-sca-snyk.yml](gitlab-ci-sca-snyk.yml) |
| DAST (ZAP) | [dast-zap-basic.sh](dast-zap-basic.sh) | [dast-zap-basic.md](dast-zap-basic.md) | [github-actions-dast-zap.yml](github-actions-dast-zap.yml) | [gitlab-ci-dast-zap.yml](gitlab-ci-dast-zap.yml) |
| DAST (Nuclei) | [dast-nuclei-basic.sh](dast-nuclei-basic.sh) | [dast-nuclei-basic.md](dast-nuclei-basic.md) | [github-actions-dast-nuclei.yml](github-actions-dast-nuclei.yml) | [gitlab-ci-dast-nuclei.yml](gitlab-ci-dast-nuclei.yml) |
| DAST (Dastardly) | [dast-dastardly-basic.sh](dast-dastardly-basic.sh) | [dast-dastardly-basic.md](dast-dastardly-basic.md) | [github-actions-dast-dastardly.yml](github-actions-dast-dastardly.yml) | [gitlab-ci-dast-dastardly.yml](gitlab-ci-dast-dastardly.yml) |
| PR review (LLM, advisory) | — | [pr-llm-security-review.md](pr-llm-security-review.md) | [diff](github-actions-pr-llm-security-review.yml) · [findings](github-actions-pr-llm-security-review-findings.yml) | — |

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

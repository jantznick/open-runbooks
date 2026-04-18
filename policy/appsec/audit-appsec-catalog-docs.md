# Audit: appsec-catalog documentation vs open-runbooks program

**Purpose:** Review `appsec-catalog/frontend/docs` against this repo’s program spine (policy, lifecycle phases, SAMM reference, runbook capabilities) before merging into one documentation set. Use this as a checklist while you edit catalog pages—not as a verdict on the product.

**Scope:** Markdown under `frontend/docs/` (mirror in `public/docs/`). Does not audit React routes, DB schema, or actual score implementation—only **documented** behavior vs **program** expectations.

**Policy vs automation IDs:** The policy baseline (`framework/appsec-policy-baseline.md`) uses **descriptive requirement titles** only so it can live under a larger cyber policy. The file `policy-evidence-mapping.yaml` may still use stable **`id`** values (e.g. `AS-POL-001`) for catalogs and CI—where this audit cites `AS-*`, it refers to those **automation/mapping** identifiers unless stated otherwise.

### Producer notes (status)

- **Scoring vs policy (audit §1.4, §2, merge order):** The catalog scoring model reflects a **minimal product**, not a fully elaborated policy. The **policy baseline** here is also a template and may gain more **actionable** control wording over time. Treat the policy↔scoring gaps as **directional**: align when the product and policy mature; do not block shipping merged docs on a perfect 1:1 map.
- **Glossary:** Plan to **enhance** the merged glossary (catalog + program terms)—see §1.11.
- **Markdown renderer:** The catalog viewer is **not** a full markdown engine. Prefer **plain markdown** for merged pages; avoid HTML layouts (e.g. grid cards) unless you verify rendering or upgrade the pipeline.

---

## Executive summary

| Area | Verdict |
|------|---------|
| **Lifecycle language** | Catalog uses a **3-phase customer journey** (weeks 1–2, 3–6, ongoing). Open-runbooks uses **six SDLC phases** (01–06). They are complementary; docs should **cross-link** so readers do not confuse the two. |
| **SAMM** | Catalog `samm-assessments.md` matches the **five SAMM business functions** used in `framework-owasp-samm.md`. Add **streams / practices** and link to `samm-coverage-checklist` when merged. |
| **Policy / evidence** | Same files define a **richer target state** than the catalog’s **v1 scoring** and minimal fields. When you tighten policy or the product, reconcile **secrets**, **SCA**, and metadata—see §2. Until then, document scoring as **“v1 model”** if needed to avoid implying full policy coverage. |
| **Metadata fields** | Scoring’s **8 fields** vs YAML **metadata contract** differ; a **single dictionary** (UI ↔ policy ↔ score) is still valuable **when** you align product and policy—not a prerequisite for every merge edit. |
| **Tooling story** | Capabilities (Snyk, Tenable, Traceable, Fastly) align with policy’s “tool-agnostic controls” if you state equivalents. Open-runbooks adds **OSS/reference** tools (Semgrep, TruffleHog, Trivy, ZAP, …)—docs should position them as **reference implementations**, not replacements. |
| **Questionnaires & roadmap** | Strong fit with **01 Plan and Design** (inventory, classification) and **implementation checklist**. Add explicit links to phase docs when merged. |

---

## 1. Document-by-document notes

### 1.1 `program-overview.md`

- **Strengths:** Clear entry point; links roadmap, questionnaire, capabilities, developer checklist.
- **Gaps vs program:** No mention of **policy baseline**, **CI gate** expectations (SAST + **secrets** + SCA + DAST where applicable), or **full-circle lifecycle** (01–06).
- **Merge actions:** Reframe as a **hub**: keep services grid; add a second column or section “Program & lifecycle (template)” linking to start-here / full-circle / phases. Fix links after URL scheme for nested docs is finalized (`/docs/...`).

**Risk:** HTML `<div class="grid">` may not render correctly in the catalog’s lightweight markdown renderer—verify in browser; prefer markdown-friendly layout if broken.

---

### 1.2 `new-app-sec-customer-roadmap.md`

- **Alignment:** Phase 1 posture questionnaire → matches **inventory / baseline** themes in **01** and **Governance**. Phase 2 tool integration (SAST, SCA) → matches **03** and `AS-CI-001` / `AS-CI-003`. Phase 3 pen test + SAMM → matches **04–06** and verification/maturity themes.
- **Gaps:** Does not mention **secrets scanning** or **baseline DAST** (`AS-CI-002`, `AS-CI-004`) that the policy template treats as first-class. If the catalog program truly leads with SAST+SCA only initially, say so explicitly (“v1 pipeline includes …; secrets and DAST per rollout tier”) to avoid contradicting the merged policy doc.
- **Merge actions:** Add a short **crosswalk table**: “Catalog phase ↔ Program phase (01–06).” Link to `implementation-master-checklist.md` for internal AppSec rollout.

---

### 1.3 `application-onboarding-questionnaire.md` & `posture-analysis-questionnaire.md`

- **Alignment:** Inventory, tool integration, and “accurate catalog” align with `AS-POL-001` (metadata) and onboarding narrative in **01**.
- **Gaps:** Policy YAML expects fields such as **`risk_tier`**, **`data_classification`**, **`internet_facing`**, **`default_branch`**, **`ci_provider`** (and optional **compliance_tags**, **customer_data_types**). Scoring’s eight fields overlap partially but **names differ** (e.g. “Data Types” vs `data_classification`; no explicit `internet_facing` or `default_branch` in the scoring doc).
- **Merge actions:** Document a **canonical field dictionary** (catalog UI field → policy control ID → score dimension). Link questionnaires to **01** and to the evidence-mapping explainer.

---

### 1.4 `scoring-methodology.md`

- **Strengths:** Clear weighting by importance; knowledge vs tools; freshness for scans.
- **Gaps (high priority):**
  - **Secrets scanning** is required in open-runbooks policy (`AS-CI-002`) but **not listed** in the four tool types (SAST, DAST, Application Firewall, API Security). If the product scores secrets inside “SAST” or another bucket, **say that**; otherwise add a fifth category or subgroup.
  - **SCA** is distinct in policy (`AS-CI-003`) and in capabilities (Snyk). Tool section lists **SAST** but not **SCA** explicitly—clarify whether SCA is bundled with SAST for scoring and how “unmanaged” SCA (e.g. Trivy-only) is treated vs policy wording.
  - **IaC / container / SBOM** appear in policy as SHOULD (`AS-REL-002`, `AS-REL-003`) but are absent from scoring doc—either add “future / partial credit” language or exclude with “not in score v1.”
- **Merge actions:** Add a subsection **“How scoring maps to policy controls”** (table: score component → `AS-*` ID). Link to **implementation checklist** for “how to improve score” beyond tool integration.

---

### 1.5 `app-sec-capabilities.md`

- **Alignment:** Describes **managed** stack; policy says tool choice is implementation detail if evidence matches—consistent if you keep that sentence in the merged policy page.
- **Gaps:** No **secrets** capability called out (often GitHub secret scanning, TruffleHog, Gitleaks, etc.). No **CI secrets job** narrative. DAST named Tenable WAS—good; align with policy **baseline DAST** for internet-facing apps.
- **Merge actions:** Add **“Reference / OSS pipeline patterns”** (or link out) to open-runbooks scanner guides for teams not on the standard stack. Avoid implying Snyk is the only way to satisfy SCA/SAST if policy allows equivalents.

---

### 1.6 Product pages (`products/*.md`)

- **Alignment:** Support capabilities narrative; frontmatter `title` / `summary` is useful if the doc viewer ever reads YAML (partial support exists in `Docs.jsx` for nested paths).
- **Gaps:** None critical for program merge; ensure **internal links** use final `/docs/...` paths after restructure.

---

### 1.7 `samm-assessments.md`

- **Alignment:** Five business functions match `framework-owasp-samm.md`. Maturity 0–3 is reasonable (open-runbooks emphasizes 1–3 progression but allows “unaware” as pre-1).
- **Gaps:** No **streams**, **practices**, or link to **coverage checklist** / phase docs. Catalog reads slightly like a generic SAMM intro; open-runbooks ties SAMM to **concrete artifacts** (runbooks, checklist).
- **Merge actions:** Add bullets pointing to **samm-coverage-checklist** and **phase 06**. Optionally name 1–2 example practices per function (as in **01-plan-and-design.md**) without duplicating the whole SAMM spec.

---

### 1.8 `threat-modeling-for-developers.md`

- **Strong alignment** with **01** (threat assessment, STRIDE, DFD, trust boundaries). Complementary depth for developers.
- **Merge actions:** Link to **01** and policy `AS-DES-002`. Mention **where artifacts live** (ticket, repo, threat dragon) to match evidence types in YAML (`threat_model_document`, `design_review_record`).

---

### 1.9 `developer-checklist.md`

- **Alignment:** Matches themes in **02-build-and-commit** (secure coding, deps, secrets, errors).
- **Gaps:** Does not mention **PR security checklist** or **CI gates** explicitly—easy add with links to **03**.
- **Merge actions:** Add a final section **“Before you merge”** with pointers to SAST/secrets/SCA expectations and link to **03** + scanner guides.

---

### 1.10 `penetration-testing.md` & `domain-monitoring.md`

- **Alignment:** Fit **05-runtime-and-operate** / **04-release-and-deploy** (assurance) and operational monitoring; pen test aligns with verification beyond automated scanning.
- **Gaps:** Generic “portal” language—ensure links match real routes when merged.
- **Merge actions:** Cross-link **04** / **05** and policy ops controls (`AS-OPS-*`) where relevant.

---

### 1.11 `app-sec-defined-terms.md`

- **Alignment:** SAST, DAST, SCA, XSS, SQLi, threat modeling, AppSec—consistent with open-runbooks usage.
- **Gaps:** Missing terms the program uses heavily: **evidence**, **CI gate**, **risk tier**, **data classification**, **exception / risk acceptance**, **SBOM**, **secrets scanning** (distinct from SAST), **OWASP SAMM** (short entry), **ASVS** / **SSDF** (optional pointers).
- **Merge actions:** Expand glossary; dedupe with policy baseline terminology. Single canonical **glossary** for the merged site.

---

## 2. Policy and metadata crosswalk (action item for catalog team)

| Policy / YAML concept | Appears in catalog docs? | Notes |
|----------------------|---------------------------|--------|
| `AS-POL-001` metadata | Partially | Questionnaires + scoring “8 fields” |
| `risk_tier` | Implied (“importance”) | Align naming: importance vs risk tier |
| `data_classification` | “Data Types” | Define equivalence |
| `internet_facing` | Not in scoring list | Policy and SAMM triggers use it |
| `default_branch`, `ci_provider` | Not in scoring doc | Required in YAML for CI evidence |
| `AS-CI-001` SAST | Yes | Capabilities + roadmap |
| `AS-CI-002` Secrets | **Weak / missing** in scoring | **Fix in docs (and product if needed)** |
| `AS-CI-003` SCA | Partial | Clarify vs SAST in scoring |
| `AS-CI-004` DAST | Yes | Tenable + scoring |
| `AS-CI-005` fail on severity | Not in catalog | Add to developer or CI-facing page |
| WAF / API security | Yes | Scoring + capabilities |
| Exceptions `AS-GOV-*` | Not in catalog | Add glossary + link from **06** |

---

## 3. Terminology and phase naming

| Catalog usage | Open-runbooks usage | Recommendation |
|---------------|---------------------|----------------|
| “Phase 1–3” (customer roadmap) | “01–06” (SDLC) | Always label **customer roadmap phases** vs **lifecycle phases** |
| “Knowledge Sharing” / “Tool Usage” | Policy layers / evidence | Keep catalog terms; add one bridge paragraph |
| “Corporate” (scoring copy) | “AppSec team” / “security program” in program docs | Same idea: **central visibility** of tool integration. Unify **wording** in merged docs if “Corporate” confuses readers. |
| SAMM “0–3” | “Level 1–3” focus | See **clarification below**—not a conflict. |

**Clarification — SAMM “0–3” vs “Level 1–3” (common source of confusion):**  
OWASP SAMM maturity is often scored on a scale that includes **0** = practice not performed or unknown, then **1 → 3** = increasing maturity. The program docs here emphasize **Level 1–3** as the path once work has started. **They are not contradictory:** “0” is the baseline before Level 1. If assessments use 0–3, say that once in `samm-assessments.md` or in `framework-owasp-samm.md` so readers are not stuck comparing two numbering stories.

---

## 3b. Catalog → program: content worth pulling into open-runbooks

The **six lifecycle phases (01–06)** are broader than the catalog’s **customer journey** and questionnaires. The catalog still documents several **operating concepts** that the program repo does **not** spell out in equivalent depth. Consider folding these into the program (new subsections, appendices, or phase callouts) over time:

| Catalog artifact | What’s missing or thinner in the program today | Suggested program home |
|------------------|--------------------------------------------------|-------------------------|
| **New customer roadmap** (3 phases, weeks) | No **timeboxed engagement model** for “how we onboard an org” vs “how dev delivers software” | New short doc e.g. `program/customer-onboarding-journey.md`, or § in **06** + link from README |
| **Posture analysis questionnaire** | No **org/engineering-manager** baseline intake before app-level inventory | **01** or **06** (“baseline posture”) + governance |
| **Application onboarding questionnaire** | **01** mentions metadata; no **step-by-step intake narrative** (who fills what, what happens after submit) | **01** + `implementation-master-checklist` workstream |
| **Scoring model** (knowledge vs tools, importance weighting, freshness) | Policy/evidence without a **plain-language “how adoption is measured”** story | **06** (metrics/governance) or appendix to policy baseline |
| **Penetration testing** (engagement types, methodology outline) | Phases reference testing; no **procurement/scoping** pattern for pen test as a service | **04** / **05** subsection or `program/penetration-testing-service.md` |
| **Domain monitoring** (brand/phishing, takedowns) | **05** is runtime/ops but not **external attack surface / brand** monitoring | **05** subsection or ops runbook stub |
| **Product-specific capabilities** (managed stack pages) | Program is **tool-agnostic**; optional **“example enterprise stack”** appendix helps readers map controls to vendors | `appsec-program-full-circle.md` or new `program/example-managed-stack.md` |
| **SAMM assessment delivery** (interviews, workshop, roadmap) | `framework-owasp-samm.md` is **internal reference**; light **“assessment engagement”** narrative matches how teams buy SAMM | **06** or sibling to `samm-assessments` content when merged |

None of these require changing the **six-phase model**; they **enrich** Governance, Operations, and Verification with catalog-hardened language.

---

## 4. Suggested merge order (documentation work)

1. **Canonical glossary** (`app-sec-defined-terms.md`) + policy term alignment.  
2. **program-overview** hub + links to full-circle / README journey (markdown-friendly layout).  
3. **Roadmap** + **questionnaires** crosswalk to **01** and implementation checklist.  
4. **Capabilities** + **product** pages: OSS/reference links; secrets when you want parity with policy.  
5. **SAMM** + **developer checklist**: link to checklist, **03**, **06**; add SAMM 0–3 one-liner if assessments use it.  
6. **Scoring methodology**: policy crosswalk and extra tool categories **when product/policy catch up**—or label as v1 scope in prose.  
7. **Single `DOC_SECTIONS` config** in the catalog app + mirror `public/docs/` tree.  
8. **Program backlog:** pull high-value rows from **§3b** into open-runbooks as you consolidate repos.

---

## 5. Out of scope for this audit (still verify separately)

- Whether the **live app** enforces the same fields and tool types as the docs (field dictionary exercise).  
- Whether **integration levels** (0–4) in scoring match how CI jobs are detected in the backend.  
- Legal/compliance wording on questionnaires and pen tests.  
- Duplication sync between `frontend/docs` and `frontend/public/docs`.

---

*Generated against open-runbooks `runbooks/appsec/` and appsec-catalog `frontend/docs/` as of the audit date. Update this file as catalog or program docs change.*

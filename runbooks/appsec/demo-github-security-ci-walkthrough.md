# Walkthrough: GitHub Actions security demo (vulnerable app → scans → outcomes)

**First time adopting in your own repo?** Use **[setup-github-actions.md](setup-github-actions.md)** — sample folder layout, one or multiple workflow files, secrets, enable Actions.

---

This guide is a **hands-on demo path** for showing SAST, SCA, and secrets scanning in GitHub Actions using this repository’s runbooks and the intentional **`test-app-vulnerable-todo`** app. **Corporate Security** can use it to train **operating company** engineers before they adopt the same controls in production repos.

**This catalog does not run Actions for you:** there is no required workflow committed under `.github/workflows/` here. You **copy** `runbooks/appsec/github-actions-*.yml` and the matching `.sh` files into **your** repository (see [setup-github-actions.md](setup-github-actions.md)).

## What you can realistically show

| Outcome | Feasible here? | Notes |
|--------|----------------|--------|
| **CI runs on push/PR** | Yes | After you copy templates into **your** repo’s `.github/workflows/` (see [setup-github-actions.md](setup-github-actions.md)). |
| **Findings in logs + failing checks** | Yes | Semgrep, Trivy, and TruffleHog report issues; jobs can fail the build per policy. |
| **Downloadable reports (JSON / JSONL)** | Yes | Artifacts are uploaded on each job (`if: always()`). |
| **“Fix it for me” inside GitHub from these jobs alone** | **Partial** | The shell runbooks **detect** issues; they do not open fix PRs by themselves. For automated fixes you add **Snyk’s GitHub integration** (fix PRs), **Dependabot**, or manual remediation—called out below. |
| **Advisory narrative on a PR** | Optional | See `pr-llm-security-review.md` + `github-actions-pr-llm-security-review.yml` (needs `OPENAI_API_KEY` and is advisory, not a gate). |

The strongest **live story** is: *copy runbooks + workflows into a repo → push → checks go red → open artifacts / logs → walk through one finding → fix in a follow-up commit → green.*

## Prerequisites

- A **GitHub** account.
- A clone or zip of this repo so you can copy `runbooks/appsec/*.sh`, `runbooks/appsec/github-actions-*.yml`, and optionally `test-app-vulnerable-todo/`.
- Optional: **Snyk** account and `SNYK_TOKEN` if you copy the Snyk workflow templates.

No paid tools are required for the **default** Semgrep + Trivy + TruffleHog path.

---

## Path A — Demo repo with the vulnerable app (recommended)

Use this for a **repeatable training repo** (small, purpose-built).

1. Create a new GitHub repository (e.g. `security-scan-demo`).
2. Copy **`test-app-vulnerable-todo/`** into the repo (as a subfolder **or** flatten to root—if root, set scan path variables to `.`).
3. Copy **`runbooks/appsec/`** scripts you need, at minimum:  
   `sast-semgrep-opengrep-basic.sh`, `sca-trivy-basic.sh`, `secrets-trufflehog-basic.sh`  
   — keep path **`runbooks/appsec/`** from repo root.
4. Copy **three** workflow templates into **`.github/workflows/`** with names you like, e.g.:  
   - `github-actions-sast.yml` → `sast.yml`  
   - `github-actions-sca-trivy.yml` → `sca-trivy.yml`  
   - `github-actions-secrets-trufflehog.yml` → `secrets.yml`  
   (See [setup-github-actions.md](setup-github-actions.md) for a sample tree.)
5. **Settings → Actions → General** — allow Actions.
6. Set **repository variables** if the app is in a subfolder (e.g. `test-app-vulnerable-todo`):  
   - `SAST_SCAN_PATH` = `test-app-vulnerable-todo` (or `.` if app is at root)  
   - `SCA_SCAN_PATH` = same  
   - `SECRETS_SCAN_PATH` = same  
7. **Push** to `main` or open a **PR** — three workflows should appear under **Actions** (one per file).
8. Expect **failures** on the vulnerable tree; download **Artifacts** from each run.

---

## Path B — Drop into an existing application repo

Same as Path A, but skip copying `test-app-vulnerable-todo/`; point `*_SCAN_PATH` at your app’s directory (often `.`).

---

## Adding “fixes on the fly” (beyond failing checks)

These are **not** switched on by the shell runbooks alone:

1. **Snyk + GitHub** — Connect the repo in Snyk and enable PR checks / fix PRs per Snyk’s product flow.
2. **Dependabot** — **Settings → Code security → Dependabot** (version updates).
3. **Branch protection** — Require the **workflow or job names** you copied (e.g. `sast`, `sca-trivy`) before merge.
4. **LLM PR review (advisory)** — Copy `github-actions-pr-llm-security-review.yml` and follow `pr-llm-security-review.md`.

---

## Troubleshooting (demo day)

| Symptom | Likely cause |
|--------|----------------|
| Docker not found | Ubuntu `ubuntu-latest` includes Docker; custom runners need the Docker CLI. |
| Semgrep/Trivy very slow | Large `node_modules` in tree; first run can be heavy. |
| TruffleHog fails on fixtures | Expected on a vulnerable demo; tune path or policy. |
| Snyk jobs never appear | `SNYK_TOKEN` missing where the template requires it. |
| All green (unexpected) | Wrong `*_SCAN_PATH` or scanning an empty folder. |

---

## Related files

| Goal | File |
|------|------|
| **Exact copy-paste steps + sample layout** | [setup-github-actions.md](setup-github-actions.md) |
| **Handoff / golden repo** | [README.md](README.md) — [Using these runbooks in your own repository](README.md#using-these-runbooks-in-your-own-repository) |
| **Individual templates** | `runbooks/appsec/github-actions-*.yml` |
| **Scanner behavior / env vars** | `runbooks/appsec/*-basic.md` |
| **Demo app** | `test-app-vulnerable-todo/README.md` |

---

## Suggested demo script (10–15 minutes)

1. Show README warning on the vulnerable app.  
2. Push or PR → show **Actions** (three workflows if you copied three YAML files).  
3. Open a failed job log → one Semgrep or Trivy hit.  
4. Download one artifact → show JSON.  
5. (Optional) Snyk UI / Dependabot as “next maturity step.”  
6. (Optional) Small fix commit → re-run → **green** when appropriate.

**Expectation:** this repo gives you **detection and evidence** via copy-paste; **fix automation** is layered with vendor/GitHub features you enable separately.

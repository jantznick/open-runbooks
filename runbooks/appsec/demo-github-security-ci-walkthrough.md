# Walkthrough: GitHub Actions security demo (vulnerable app → scans → outcomes)

This guide is a **hands-on demo path** for showing SAST, SCA, and secrets scanning in GitHub Actions using this repository’s runbooks and the intentional **`test-app-vulnerable-todo`** app. **Corporate Security** can use it to train **operating company** engineers before they adopt the same controls in production repos.

## What you can realistically show

| Outcome | Feasible here? | Notes |
|--------|----------------|--------|
| **CI runs on push/PR** | Yes | Use the workflow under `.github/workflows/` in this repo (or copy templates from `runbooks/appsec/`). |
| **Findings in logs + failing checks** | Yes | Semgrep, Trivy, and TruffleHog will report issues; jobs can fail the build per policy. |
| **Downloadable reports (JSON / JSONL)** | Yes | Artifacts are uploaded on each job (`if: always()`). |
| **“Fix it for me” inside GitHub from these jobs alone** | **Partial** | The shell runbooks **detect** issues; they do not open fix PRs by themselves. For automated fixes you add **Snyk’s GitHub integration** (fix PRs), **Dependabot**, or manual remediation—called out below. |
| **Advisory narrative on a PR** | Optional | See `pr-llm-security-review.md` + `github-actions-pr-llm-security-review.yml` (needs `OPENAI_API_KEY` and is advisory, not a gate). |

So the strongest **live story** is: *clone/fork → CI runs → checks go red → open artifacts / logs → walk through one finding → fix in a follow-up commit → green.* That is honest, repeatable, and matches how most orgs use scanners first.

## Prerequisites

- A **GitHub** account.
- **Fork** or **clone** this repo (`open-runbooks` or your fork) so you have `runbooks/appsec/*.sh` and `test-app-vulnerable-todo/`.
- Optional: **Snyk** account and `SNYK_TOKEN` if you want the optional Snyk jobs in the demo workflow (Snyk Code + `snyk test`).

No paid tools are required for the **default** Semgrep + Trivy + TruffleHog path.

---

## Path A — Fastest: fork this repo on GitHub

This path uses the **built-in** workflow [`.github/workflows/security-demo-gate.yml`](../../.github/workflows/security-demo-gate.yml), which defaults scans to **`test-app-vulnerable-todo`** so you do not have to set repository variables first.

1. **Fork** `open-runbooks` (or push a copy to a new GitHub repository that includes the same layout).
2. In the fork: **Settings → Actions → General**  
   - Allow Actions to run (at least for this repository).
3. **Optional — Snyk:** **Settings → Secrets and variables → Actions → New repository secret**  
   - Name: `SNYK_TOKEN`  
   - Value: your Snyk API token  
   - If you skip this, the Snyk jobs in the demo workflow are **skipped**; Semgrep/Trivy/TruffleHog still run.
4. **Trigger a run**  
   - Push any small commit to `main`, or open a PR, or use **Actions → security-demo-gate → Run workflow** (`workflow_dispatch`).
5. **Watch** **Actions → security-demo-gate**  
   - You should see parallel jobs (SAST, SCA, secrets, and Snyk jobs if configured). Expect **failures** on a deliberately vulnerable tree—that is the demo.
6. **Artifacts**  
   - Open the run → scroll to **Artifacts** → download JSON / JSONL for Semgrep, Trivy, TruffleHog (and Snyk when enabled).
7. **Narrate one finding**  
   - Example: open `test-app-vulnerable-todo/server.js` and tie a log line to hardcoded secret / dangerous API usage.

### Optional: point scans at the whole repo

If you create a **minimal** repo with only the app at the root, set repository variables (same settings page, **Variables** tab):

- `SAST_SCAN_PATH` = `.`
- `SCA_SCAN_PATH` = `.`
- `SECRETS_SCAN_PATH` = `.`

The demo workflow uses those variables when set; otherwise it defaults to `test-app-vulnerable-todo` for this template layout.

---

## Path B — “I only want the vulnerable app + CI” in a clean repo

Use this when you want a **small** public demo repo (no full runbooks tree) or to teach “drop CI into an existing project.”

1. Create a new GitHub repository (e.g. `my-security-demo`).
2. Copy **`test-app-vulnerable-todo/`** contents to the **repository root** (or keep a subfolder and set the three `*_SCAN_PATH` variables accordingly).
3. Copy the **`runbooks/appsec/`** directory (at least the `.sh` scripts you need and any workflow YAML you use) so paths match:
   - Workflows expect: `./runbooks/appsec/<script>.sh`
4. Copy **`.github/workflows/security-demo-gate.yml`** from this repo into your new repo (same path).
5. Set **variables** so paths match your layout (often all `.` if the app is at root).
6. Add **`SNYK_TOKEN`** if you want Snyk jobs.
7. Push → watch Actions as in Path A.

---

## Adding “fixes on the fly” (beyond failing checks)

These are **not** switched on by the shell runbooks alone; they are normal GitHub / Snyk features you can demo in a **second** segment:

1. **Snyk + GitHub**  
   - Connect the repo in [Snyk](https://snyk.io) and enable PR checks / fix PRs per Snyk’s current product flow.  
   - Your `SNYK_TOKEN` CI jobs complement that but are not a substitute for the UI integration.

2. **Dependabot**  
   - **Settings → Code security → Dependabot** (enable version updates).  
   - Good for showing **dependency bump PRs** after Trivy/Snyk highlighted CVEs.

3. **Branch protection**  
   - **Settings → Rules → Rulesets** (or branch protection): require the `security-demo-gate` workflow (or specific job names) before merge—shows **governance**, not just visibility.

4. **LLM PR review (advisory)**  
   - Copy `github-actions-pr-llm-security-review.yml` and follow `pr-llm-security-review.md` if you want a **comment-only** reviewer on PRs (separate from the security gate).

---

## Troubleshooting (demo day)

| Symptom | Likely cause |
|--------|----------------|
| Docker not found | Ubuntu `ubuntu-latest` includes Docker; custom runners need the Docker CLI. |
| Semgrep/Trivy very slow | `test-app-vulnerable-todo` may include a large `node_modules` tree in git; first run can be heavy. For a snappier story, use a branch without `node_modules` committed and run `npm ci` in a prior step (you’d extend the workflow). |
| TruffleHog fails on fixtures | Expected on a vulnerable demo; tune `SECRETS_FAIL_ON_FINDINGS` or scan path for a “softer” demo if needed. |
| Snyk jobs never appear | `SNYK_TOKEN` missing or empty—jobs are gated with `if: secrets.SNYK_TOKEN != ''`. |
| All green (unexpected) | Wrong `*_SCAN_PATH` (e.g. scanning an empty folder) or severity/policy filtering in Snyk only. |

---

## Related files (copy or reference)

| Goal | File |
|------|------|
| **Handoff to operating companies** (copy order, corporate golden repo, divisional forks) | [`runbooks/appsec/README.md`](README.md) — [Using these runbooks in your own repository](README.md#using-these-runbooks-in-your-own-repository) and [Staying current with upstream runbooks](README.md#staying-current-with-upstream-runbooks) |
| One workflow, multiple scanners | `.github/workflows/security-demo-gate.yml` |
| Individual templates (pick and choose) | `runbooks/appsec/github-actions-*.yml` |
| Scanner behavior / env vars | `runbooks/appsec/*-basic.md` |
| What the demo app contains | `test-app-vulnerable-todo/README.md` |

---

## Suggested demo script (10–15 minutes)

1. Show README warning on the vulnerable app.  
2. Push or `workflow_dispatch` → show Actions graph.  
3. Open a failed job log → one Semgrep or Trivy hit.  
4. Download one artifact → show JSON structure (or pretty-print).  
5. (Optional) Show Snyk UI / Dependabot fix PR as “the next maturity step.”  
6. (Optional) Merge a tiny fix commit and re-run to show **green** when issues are addressed or policy is relaxed for the lesson.

This keeps expectations aligned: **this repo gives you detection and evidence in CI**; **fix automation** is layered with vendor/GitHub features you choose to enable.

# Runbook: LLM-assisted pull request security review (GitHub Actions)

## Purpose

Run an **advisory** security review of pull request changes using a **configurable model** and a **version-controlled custom prompt**. The workflow posts results as a **pull request comment** (or updates a single comment on new pushes).

This is **not** a substitute for SAST, SCA, or secrets scanning. It complements deterministic gates with qualitative review, at the cost of API spend, latency, and non-determinism.

## How adoption works here

**Corporate Security** provides these files as **templates**. Operating teams copy the workflow YAML into `.github/workflows/` in the service repo (and add the prompt file, secrets, and the same `runbooks/appsec/` script paths as other approved runbooks). **If the file is present, it runs** — there are no extra “enable this workflow” toggles. Use LLM review only where **corporate policy** permits sending diffs or scanner output to an external API. Optional GitHub **variables** like `LLM_MODEL` or `SAST_SCAN_PATH` only tune behavior after the workflow is adopted; they do not replace organizational approval to run the job.

The same copy-paste order (scripts under `runbooks/appsec/`, then workflow YAML) is spelled out for **all** controls in [AppSec README — Using these runbooks in your own repository](README.md#using-these-runbooks-in-your-own-repository). Ongoing sync options (including the **corporate golden repo**) are in [Staying current with upstream runbooks](README.md#staying-current-with-upstream-runbooks).

## Where it fits in the program

- Aligns with [03 CI Gate](program/03-ci-gate.md): treat this as **optional / non-blocking** unless your org explicitly accepts model risk as a gate.
- Pair with existing runbooks (SAST, SCA, secrets) rather than replacing them.

## Standalone templates

### A — Diff-based review (full PR diff)

Use:

- `runbooks/appsec/github-actions-pr-llm-security-review.yml`

Copy it to `.github/workflows/` in your repository and adjust names or triggers if you want. The template uses **OpenAI-compatible** chat completions (`/v1/chat/completions`); many providers expose the same shape.

**Prompt file:** `.github/llm-security-review-prompt.md`  
**Example to copy:** `runbooks/appsec/llm-security-review-prompt.example.md`

### B — Scanner findings only (SAST + SCA JSON)

Use:

- `runbooks/appsec/github-actions-pr-llm-security-review-findings.yml`

This workflow runs **Semgrep** and **Trivy SCA** on every matching PR (same scripts as the other templates in this folder), uploads JSON artifacts, and sends **only those results** (plus your prompt) to the LLM. Payload is usually **smaller** than the diff workflow and exposes **less full source** to the model.

**Prompt file:** `.github/llm-security-review-findings-prompt.md`  
**Example to copy:** `runbooks/appsec/llm-security-review-findings-prompt.example.md`

**Only want one scanner?** Do not add toggles — edit the pasted YAML: remove the `sast` or `sca` job, set `llm`’s `needs:` to the remaining job(s), remove the matching download step, and adjust the upload `path:` / script if your tool writes a different file. If you use **Snyk** (or another stack), replace that job’s `run:` and artifact path the same way you would for any other copied workflow.

**Default artifact paths** (Semgrep + Trivy runbooks in this repo): `artifacts/security/sast-results.json` and `artifacts/security/trivy-sca.json` — change them in the workflow file if your outputs differ.

**Note:** Scanner steps use `continue-on-error` so findings are still uploaded when a tool exits non-zero. Keep your **merge-blocking** SAST/SCA workflows as separate workflows; this one is for **advisory LLM triage**, not the only gate.

**Comment marker:** findings comments use `<!-- pr-llm-security-review-findings -->` so they do not overwrite diff-based comments from template A.

## Scope

- Open pull requests (and updates to them) on branches you configure in the pasted workflow.
- **Template A:** the PR **title** and **description** (from the webhook payload) plus the **diff** between base and head (diff is bounded by the workflow’s character cap; very long descriptions truncate at 20k characters).
- **Template B:** **scanner JSON** from the jobs in that workflow (bounded by the same style of cap).
- Repositories that may send that content to an external LLM API (governance and data-handling decision).
- **Template A** skips **Dependabot** PRs by default (`dependabot[bot]`) so you do not need Dependabot-specific secrets for this job; remove the job-level `if` in the YAML if you want LLM review on dependency PRs too.

## When to use

- You want consistent security framing on every PR without scaling human review to every line.
- You already have secret scanning and static analysis; you want narrative context and fix suggestions.

## When not to use (or gate carefully)

- **Highly sensitive code** that must not leave your environment (use on-prem models or skip this control).
- **Regulated** workloads where “AI reviewed” is not acceptable evidence without explicit policy.
- **Merge-blocking** enforcement: models miss issues and hallucinate; if you gate on this, define a narrow machine-checkable subset (not recommended for general text review).

## Preconditions

- GitHub Actions enabled; workflow permissions allow PR comments (see template `permissions`).
- An API key stored as a **repository or organization secret** (never commit keys).
- A **prompt file** checked into the repo (recommended path: `.github/llm-security-review-prompt.md`).
- Network egress from GitHub-hosted runners to your LLM endpoint (or use self-hosted runners / Azure OpenAI with allowed paths).

## Inputs (secrets and variables)

| Name | Required | Purpose |
|------|----------|---------|
| `OPENAI_API_KEY` | Yes (unless you fork the template to another auth scheme) | Bearer token for the chat completions API. |
| `LLM_MODEL` | Recommended (repository variable) | Model id (for example `gpt-4o-mini`). Keeps the model out of committed YAML if you prefer. |
| `LLM_API_BASE` | Optional | Default `https://api.openai.com/v1`. Set for Azure OpenAI, proxies, or other OpenAI-compatible endpoints. |

Prompt and behavior:

- **Prompt file**: `.github/llm-security-review-prompt.md` in the target repo (customize freely; keep instructions on scope, severity labels, and “no invented CVEs”).
- **Diff size**: the template truncates very large diffs to avoid token limits and runaway cost; tune the limit in the workflow if needed.
- **Dependabot**: the diff workflow’s job is skipped for `dependabot[bot]` (see template `if`). Use a normal branch PR to test with repository secrets, or add Dependabot secrets and remove the `if` if you want this job on Dependabot PRs.

## Outputs

- **One issue comment per PR**, updated on each run. The **latest** review is always at the top: it includes **commit list** (`git log` for `base…head`), **diff stat** (`git diff --stat` for the PR range), then the model’s markdown. Older runs are preserved under **Earlier reviews (same PR)** in a `<details>` block (nested on each push so you can expand history). Very long threads may hit GitHub’s ~65k character comment limit; the template truncates with a note.
- Optional: upload the raw model response as an artifact for audit (add a step in your fork).

## Fix PRs (advanced)

Automatically opening a **second PR** that applies model-suggested fixes is possible but **high risk**:

- **Wrong branch**: fixes must usually land on the **PR head branch** (the contributor’s branch), not the base, so they appear in the original PR. A common pattern is a new branch off the head branch, then a PR **into** that head branch.
- **Permissions**: requires `contents: write` and careful scoping; prefer a dedicated GitHub App or fine-grained token with least privilege.
- **Safety**: applying patches without human review can introduce bugs or break builds; `git apply` may fail on ambiguous suggestions.

Recommended operational split:

1. **Phase 1 — Comment only** (this template): review + suggested patches in text; humans apply changes.
2. **Phase 2 — Optional**: workflow_dispatch or label-triggered job that creates a branch and opens a PR, only after team agreement on policy and testing.

Document ownership, rollback, and who may merge autofix PRs before enabling phase 2.

## Fork and contributor PRs

GitHub does not expose repository secrets to workflows triggered by `pull_request` from **forks**. That means this pattern usually runs only for PRs from branches in the same repository unless you adopt a different trigger (for example `pull_request_target`, which has significant security implications and should only be used with a locked-down workflow). Typical choices:

- **Same-repo PRs only** for automated LLM review with a stored API key.
- **Manual / label-triggered** review after a maintainer approves running the job with secrets.
- **Organization-level** runners or an internal endpoint that does not rely on fork-accessible workflows.

## Threat and abuse notes

- **Prompt injection**: malicious PR content can try to manipulate the reviewer prompt. Instruct the model to treat the diff as untrusted data; keep system/developer instructions in your checked-in prompt file and avoid executing model output as code.
- **Secrets in diffs**: the diff can contain credentials; combine with [secrets scanning](secrets-trufflehog-basic.md) and consider blocking the LLM job if secrets tools fail.

## Quick start

**Diff workflow**

1. Copy `github-actions-pr-llm-security-review.yml` to `.github/workflows/pr-llm-security-review.yml`.
2. Copy `llm-security-review-prompt.example.md` to `.github/llm-security-review-prompt.md` and edit (or author your own prompt at that path).
3. Set repository secret `OPENAI_API_KEY` and variable `LLM_MODEL`.
4. Open a test PR and confirm a comment appears.

**Findings workflow**

1. Copy `github-actions-pr-llm-security-review-findings.yml` to `.github/workflows/pr-llm-security-review-findings.yml`.
2. Copy `llm-security-review-findings-prompt.example.md` to `.github/llm-security-review-findings-prompt.md` and edit.
3. Set repository secret `OPENAI_API_KEY` and variable `LLM_MODEL` (same as template A).
4. Open a test PR and confirm the triage comment appears.

## Related

- [SAST (Semgrep)](sast-semgrep-opengrep-basic.md) — deterministic code rules.
- [Secrets (TruffleHog)](secrets-trufflehog-basic.md) — credential detection.

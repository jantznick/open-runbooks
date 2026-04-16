# GitHub Actions: copy workflows and runbooks into your repository

This page is the **exact sequence** for: **copy files into your own repo → GitHub Actions runs on push/PR.** You do not need to fork `open-runbooks`.

---

## 1. What you copy

| What | Where it goes in **your** repo | Notes |
|------|-------------------------------|--------|
| Shell runbooks | `runbooks/appsec/<name>.sh` | Same path **from the repository root** as in this project. Copy every `.sh` that your chosen workflow(s) invoke (see each YAML `run:` line). |
| Workflow file(s) | `.github/workflows/<any-name>.yml` | **You choose the filename.** GitHub runs every `*.yml` in `.github/workflows/`. |

Templates only **call** those scripts (e.g. `./runbooks/appsec/sast-semgrep-opengrep-basic.sh`). Scanner logic stays in the `.sh` files.

**One scanner vs several**

| Approach | What to do |
|----------|------------|
| **One workflow file** | Copy **one** template, e.g. `runbooks/appsec/github-actions-sast.yml` → your `.github/workflows/sast.yml` (name is arbitrary). Copy only the `.sh` files that template runs. |
| **Several scanners (typical)** | Copy **multiple** templates into `.github/workflows/` with **different filenames**, e.g. `sast.yml`, `sca-trivy.yml`, `secrets-trufflehog.yml`. Each file becomes its **own** workflow in the Actions tab (each triggers on the `on:` you set—usually `pull_request` / `push`). Copy the union of `.sh` scripts those workflows need. |
| **One YAML file, many jobs** | Advanced: merge the `jobs:` from several templates into a **single** `.yml` yourself if you want one workflow name in the UI—there is no separate “combined” template required; it is optional editor work. |

**Sample layout in *your* repo** (three scanners, clear names):

```text
your-repo/
  .github/
    workflows/
      sast.yml              ← copied from runbooks/appsec/github-actions-sast.yml
      sca-trivy.yml         ← copied from runbooks/appsec/github-actions-sca-trivy.yml
      secrets-trufflehog.yml ← copied from runbooks/appsec/github-actions-secrets-trufflehog.yml
  runbooks/
    appsec/
      sast-semgrep-opengrep-basic.sh
      sca-trivy-basic.sh
      secrets-trufflehog-basic.sh
  … your application code …
```

The **content** of `sast.yml` is the same as `github-actions-sast.yml` from this repo; renaming to `sast.yml` is optional and only for clarity.

---

## 2. Steps (in order)

1. **Create directories** if missing: `runbooks/appsec/` and `.github/workflows/`.

2. **Copy** the required `.sh` files into `runbooks/appsec/`.

3. **Copy** one or more `runbooks/appsec/github-actions-*.yml` files into `.github/workflows/` and **rename** if you like (keep the `.yml` extension).

4. **Commit and push** to GitHub.

5. **Enable Actions** — **Settings → Actions → General** (if org policy allows).

6. **Add secrets** per the matching `*-basic.md` guides (`SNYK_TOKEN`, `OPENAI_API_KEY`, etc.) — **Settings → Secrets and variables → Actions**.

7. **Set variables** if needed (`SAST_SCAN_PATH`, `SCA_SCAN_PATH`, …) — **Variables** tab.

8. **Trigger** — push, PR, or **Run workflow** if `workflow_dispatch` is present.

9. **Confirm** — Actions runs; jobs should find `./runbooks/appsec/...` without “file not found.”

---

## 3. Per-control details

Secrets, env vars, and artifacts: **`runbooks/appsec/*-basic.md`** for each control.

LLM workflows: prompt files under `.github/` — [pr-llm-security-review.md](pr-llm-security-review.md).

---

## 4. Related links

- [Using these runbooks in your own repository](README.md#using-these-runbooks-in-your-own-repository) — checklist and golden-repo options  
- [Scanner runbooks and CI templates](README.md#scanner-runbooks-and-ci-templates) — full table of `github-actions-*.yml` filenames  
- [Demo walkthrough](demo-github-security-ci-walkthrough.md) — vulnerable app + CI story (copy-based; see Path B)
